Return-Path: <linux-kernel-owner+w=401wt.eu-S1762307AbYEHKNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762307AbYEHKNQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 06:13:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757771AbYEHKM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 06:12:59 -0400
Received: from www.tglx.de ([62.245.132.106]:36532 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757731AbYEHKM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 06:12:58 -0400
Date: Thu, 8 May 2008 12:12:37 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Mirco Tischler <mt-ml@gmx.de>, Ingo Molnar <mingo@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [BUG]:WARNING: at arch/x86/kernel/rtc.c:122 in 2.6.26-rc1
In-Reply-To: <48222742.5040008@firstfloor.org>
Message-ID: <alpine.LFD.1.10.0805081207050.3318@apollo.tec.linutronix.de>
References: <1210183536.28099.10.camel@mtlp.tischlernetz>  <alpine.LFD.1.10.0805072102010.3318@apollo.tec.linutronix.de>  <1210188734.5456.14.camel@mtlp.tischlernetz>  <alpine.LFD.1.10.0805072253480.3318@apollo.tec.linutronix.de> <1210196777.26103.8.camel@mtlp.tischlernetz>
 <48222742.5040008@firstfloor.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2008, Andi Kleen wrote:
> 
> > May  7 21:52:04 kernel: [4294896.091827] Extended CMOS year: 2000
> > May  7 21:52:04 kernel: [4294896.091827] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> > May  7 21:52:04 kernel: [4294896.091827] Back to C!
> > May  7 21:52:04 kernel: [4294896.091827] Extended CMOS year: 2000
> 
> If the data is read correctly (and it looks like it) then just the bit
> is wrong and we should ignore it I guess. So just remove the
> WARN_ON_ONCE()?

You put a printk there in the first place :) I changed it to
WARN_ON_ONCE as one line printks are more likely to be ignored.

I'm all for it to remove the while BCD check, which is hardcoded to
ALWAYS_BCD = 1 since linux 1.0.

This oddball case is interesting as it just triggered once and it
looks more like a hardware glitch than something we need to worry
about.

Thanks,
	tglx
