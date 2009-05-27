Return-Path: <linux-kernel-owner+w=401wt.eu-S933685AbZE0SZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933685AbZE0SZL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 14:25:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933503AbZE0SWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 14:22:45 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:41041 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933489AbZE0SWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 14:22:43 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: LOCK prefix on uni processor has its use
Date: Wed, 27 May 2009 13:22:39 -0500
User-Agent: KMail/1.9.9
Cc: Harald Welte <HaraldWelte@viatech.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <200905221139.26941.lkml@morethan.org> <20090527170118.GC4024@prithivi.gnumonks.org> <87vdnmmnac.fsf@basil.nowhere.org>
In-Reply-To: <87vdnmmnac.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905271322.41768.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed May 27 2009, Andi Kleen wrote:
> Harald Welte <HaraldWelte@viatech.com> writes:
> > * All X86 instructions except rep-strings are atomic wrt interrupts.
> > * The lock prefix has uses on a UP processor: It keeps DMA devices from
> >   interfering with a read-modify-write sequence
> 
> In theory yes, but not in Linux -- normal drivers simply don't use LOCK in any way
> on a UP kernel.
> 
> We discussed exactly this in the earlier subthread :)
> 
> > Now the question is: Is this a valid operation of a driver?  Should the driver
> > do such things, or is such a driver broken? 
> 
> The driver is broken because if it relies on this it will not work on a UP kernel.
> Also it's not portable and in general a bad idea.
> 
> > When would that occur?  I'm trying
> > to come up with a case, but typically you e.g. allocate some DMA buffer and
> > then don't touch it until the hardware has processed it.
> 
> Is it known which driver has this problem?
> 
> -Andi (who finds hpa's "timing theory" to be more believable anyways)
> 

I still have not come up with a solid, testable, theory to explain the
order of magnitude in up-time before the kernel locks with/with-out 'lock'.

But we are definitely pecking around the edges of the problem.  ;)

Today's lockdep build has just passed its previous record by hard-coding
the pci cache line size to be the same as the cpu's cache line size. (a WAFG).
Until we hear back from the VIA-CPU people, I just guessed that since the
chip set was designed for use with the processor...

Mike
