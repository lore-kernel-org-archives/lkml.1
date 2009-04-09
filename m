Return-Path: <linux-kernel-owner+w=401wt.eu-S1761386AbZDILgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761386AbZDILgf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 07:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbZDILg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 07:36:26 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:17706 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbZDILgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 07:36:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=gidl0j3L/R6F86VMZRzLUuo/mH8DCfAMmBCbaCur951sVE6guH/4Z9PxKLZacNahEy
         ZF9DZsyftMUZUHq9Le5zHGIrkk/MRfuh3Iy3B/KxlPvLrVKl1EXptmnYbyBNUXeivSwy
         zW05cyYBjqNCdW964Ow1Z+ZN6MVxA9LrQwqLU=
MIME-Version: 1.0
Date: Thu, 9 Apr 2009 19:36:24 +0800
Message-ID: <f17812d70904090436kd03744brca4a4bc4b85bba8@mail.gmail.com>
Subject: [REGRESSION] commit 66c1ca0: {fbmem: fix fb_info->lock and 
	mm->mmap_sem ...} causes Xfbdev not working
From: Eric Miao <eric.y.miao@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrea Righi <righi.andrea@gmail.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This happens on my Marvell PXA310-based Littleton platform with
Angstrom Distribution. The offending paths are many:

FBIOPUT_VSCREENINFO:
  lock_fb_info()
  --> fb_set_var()
    --> fb_notifier_call_chain() [FBINFO_MISC_USEREVENT]
      --> fbcon_event_notifier() [FB_EVENT_MODE_CHANGE]
        --> lock_fb_info()

OK, now hang. I'd suggest a clean fix to the original assumption of
circular locking
issue and revert this commit first.

-- 
Cheers
- eric
