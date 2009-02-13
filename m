Return-Path: <linux-kernel-owner+w=401wt.eu-S1759609AbZBMR1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759609AbZBMR1V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 12:27:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750980AbZBMR1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 12:27:13 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:48703 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbZBMR1M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 12:27:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=ilyaVVm4xa58XuhhfrIua2hv7f//ox+3fnAWhVVfoBxW1juv0VwS7OKrf4uZ/yPhoM
         gBWkrP0EJ0Y50fbfGPuZ6c/sdgwZ8QFmzpqGGlWv33cxaVLJGRORSA4nBiqNG6PACrjK
         CAYpcRp5Na4r8bCYkHVEYIYtzbvRIrXl2vexo=
From: Diego Calleja <diegocg@gmail.com>
To: Dave Airlie <airlied@linux.ie>
Subject: "Can not ioremap virtual address" (was Re: [git pull] drm)
Date: Fri, 13 Feb 2009 18:28:22 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc4-00178-g071a0bc; KDE/4.2.0; x86_64; ; )
Cc: torvalds@linux-foundation.org, dri-devel@lists.sf.net,
       linux-kernel@vger.kernel.org, Eric Anholt <eric@anholt.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>
References: <alpine.DEB.2.00.0902090827390.32114@skynet.skynet.ie>
In-Reply-To: <alpine.DEB.2.00.0902090827390.32114@skynet.skynet.ie>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200902131828.22680.diegocg@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Lunes 09 Febrero 2009 09:30:57 Dave Airlie escribió:
> Hi Linus,
>
> Please pull the 'drm-fixes' branch from
> ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git
> drm-fixes

A commit from this merge is causing an error in my machine:

commit ab657db12d7020629f26f30d287558a8d0e32b41
Author: Eric Anholt <eric@anholt.net>
Date:   Fri Jan 23 12:57:47 2009 -0800

    drm/i915: Set up an MTRR covering the GTT at driver load.


(found using bisection)

The error:
[   20.270956] [drm] Initialized i915 1.6.0 20080730 on minor 0
[   20.289492] [drm:i915_initialize] *ERROR* can not ioremap virtual address 
for ring buffer

And in Xorg.0.log: (II) intel(0): direct rendering: Failed


But...excluding that printk, everything works OK, including "direct rendering: 
Yes"...

There's a related thread here: http://lkml.org/lkml/2009/2/13/139

