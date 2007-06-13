Return-Path: <linux-kernel-owner+w=401wt.eu-S1756206AbXFMGxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbXFMGxE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 02:53:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754852AbXFMGwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 02:52:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:58095 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695AbXFMGwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 02:52:54 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
To: Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       stin Piszcz <jpiszcz@lucidpixels.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Reply-To: 7eggert@gmx.de
Date: Wed, 13 Jun 2007 08:52:23 +0200
References: <8tyOc-8f0-17@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1HyMiN-0000oB-TR@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX18a/6XRj2p2QtZd8dDQ2jxIrY6XUfHSJIg2O3R
 QFvGUInBP1atX3z4icyVTY+s/UVyV5bGyti0D7bD9L0e3yK4sM
 FO2/SYNgmIXiF6SGEq0Vw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes <jesse.barnes@intel.com> wrote:

> On some machines, buggy BIOSes don't properly setup WB MTRRs to
> cover all available RAM, meaning the last few megs (or even gigs)
> of memory will be marked uncached.  Since Linux tends to allocate
> from high memory addresses first, this causes the machine to be
> unusably slow as soon as the kernel starts really using memory
> (i.e. right around init time).
> 
> This patch works around the problem by scanning the MTRRs at
> boot and figuring out whether the current end_pfn value (setup
> by early e820 code) goes beyond the highest WB MTRR range, and
> if so, trimming it to match.  A fairly obnoxious KERN_WARNING
> is printed too, letting the user know that not all of their
> memory is available due to a likely BIOS bug.

Wouldn't it be better to correct the MTRR, if possible? As far as I read
here (LKML), the BIOS did not merge the entries, and this waste caused the
last part of the memory not to be covered. Off cause you can't DTRT for all
buggy MTRR setups, but if you're lucky, optionally merging the MTRR and
adding the rest of the memory may sometimes do the trick ...
-- 
Funny quotes:
10. Nothing is fool proof to a talented fool.

Friﬂ, Spammer: v9Ttukbw@NO.7eggert.dyndns.org
