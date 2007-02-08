Return-Path: <linux-kernel-owner+w=401wt.eu-S1161050AbXBHX3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161050AbXBHX3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 18:29:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161070AbXBHX3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 18:29:36 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:38490 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161050AbXBHX3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 18:29:33 -0500
Date: Fri, 9 Feb 2007 00:29:06 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.21
In-Reply-To: <20070208150710.1324f6b4.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.61.0702090023270.24888@yvahk01.tjqt.qr>
References: <20070208150710.1324f6b4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 8 2007 15:07, Andrew Morton wrote:

>scheduled-removal-of-sa_xxx-interrupt-flags-fixups.patch
>scheduled-removal-of-sa_xxx-interrupt-flags-fixups-2.patch
>scheduled-removal-of-sa_xxx-interrupt-flags.patch
>scheduled-removal-of-sa_xxx-interrupt-flags-ata-fix.patch
>
> This removes SA_INTERRUPT and friends, so 10000000 external drivers won't
> compile any more.  I think I'd prefer to find a way to get usage of SA_* to
> spit a deprecated warning.

Here's an idea:

#define SA_INTERRUPT sa_interrupt_with_warning()
static inline int sa_interrupt_with_warning(void) {
    if(more_or_less_often)
        printk(fat_warning);
    return 0x123456; /* whatever numerical value it is */
}


Jan
-- 
ft: http://freshmeat.net/p/chaostables/
