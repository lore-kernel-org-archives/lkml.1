Return-Path: <linux-kernel-owner+w=401wt.eu-S1763205AbZFLJWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763205AbZFLJWE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 05:22:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbZFLJVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 05:21:54 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:50349 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755568AbZFLJVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 05:21:54 -0400
Subject: Possible memory leak via tty_ldisc_try_get
From: Catalin Marinas <catalin.marinas@arm.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: ARM Ltd
Date: Fri, 12 Jun 2009 10:21:48 +0100
Message-Id: <1244798508.26670.20.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Jun 2009 09:21:49.0414 (UTC) FILETIME=[36F32060:01C9EB3F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

I noticed you pushed some changes to drivers/char/tty_ldisc.c recently.
I now get about 12 kmemleak reports like below (on an ARM platform):

kmemleak: unreferenced object 0xdfaffd60 (size 32):
  comm "init", pid 1, jiffies 4294937946
  backtrace:
    [<c007b8fc>] kmemleak_alloc+0x14c/0x260
    [<c0079624>] kmem_cache_alloc+0x90/0x98
    [<c0147428>] tty_ldisc_try_get+0x14/0xac
    [<c01475a4>] tty_ldisc_get+0x18/0x40
    [<c0147850>] tty_ldisc_reinit+0x28/0x5c
    [<c01478ac>] tty_ldisc_release+0x28/0x3c
    [<c0143450>] tty_release_dev+0x3cc/0x428
    [<c01434b8>] tty_release+0xc/0x14
    [<c007eb60>] __fput+0x104/0x1c4
    [<c007bb48>] filp_close+0x70/0x7c
    [<c007bbc8>] sys_close+0x74/0xa8
    [<c0022dc0>] ret_fast_syscall+0x0/0x2c
    [<ffffffff>] 0xffffffff

Could you please check whether the code is leaking memory? Let me know
if you need more information.

Thanks.

-- 
Catalin

