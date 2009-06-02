Return-Path: <linux-kernel-owner+w=401wt.eu-S1753567AbZFBMuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567AbZFBMuV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 08:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbZFBMuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 08:50:10 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:54513 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbZFBMuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 08:50:09 -0400
Date: Tue, 2 Jun 2009 14:48:54 +0200
From: Harald Welte <HaraldWelte@viatech.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, lkml@morethan.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: LOCK prefix on uni processor has its use
Message-ID: <20090602124854.GB9823@prithivi.gnumonks.org>
References: <200905221139.26941.lkml@morethan.org> <200905221946.01808.lkml@morethan.org> <4A1748A9.1020306@zytor.com> <200905231304.55973.lkml@morethan.org> <4A188A48.5000208@zytor.com> <20090527170118.GC4024@prithivi.gnumonks.org> <87vdnmmnac.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vdnmmnac.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 08:08:27PM +0200, Andi Kleen wrote:
> Harald Welte <HaraldWelte@viatech.com> writes:
> > * All X86 instructions except rep-strings are atomic wrt interrupts.
> > * The lock prefix has uses on a UP processor: It keeps DMA devices from
> >   interfering with a read-modify-write sequence
> 
> In theory yes, but not in Linux -- normal drivers simply don't use LOCK in
> any way on a UP kernel.

well, they might have inadvertedly used LOCK as part of regular spinlocks,
until LOCK_PREFIX was removed, right?

> > Now the question is: Is this a valid operation of a driver?  Should the driver
> > do such things, or is such a driver broken? 
> 
> The driver is broken because if it relies on this it will not work on a UP kernel.
> Also it's not portable and in general a bad idea.

I agree.  I was not referring to any real/known driver.  I was just trying to
figure out what kind of problem the VIA/Centaur CPU guys tried to describe when
indicating that the LOCK prefix should be used on UP to avoid DMA interfering
with read-modify-write CPU instructions.

-- 
- Harald Welte <HaraldWelte@viatech.com>	    http://linux.via.com.tw/
============================================================================
VIA Free and Open Source Software Liaison
