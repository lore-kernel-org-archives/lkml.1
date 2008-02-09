Return-Path: <linux-kernel-owner+w=401wt.eu-S1754128AbYBIPOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbYBIPOK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 10:14:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753270AbYBIPNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 10:13:42 -0500
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:52778 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbYBIPN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 10:13:28 -0500
Date: Sat, 9 Feb 2008 16:13:22 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/5] CPA: Split static_protections into required_static_prot and advised_static_prot
Message-ID: <20080209151322.GB6773@basil.nowhere.org>
References: <20080208536.837219990@suse.de> <20080208163612.D76421B41AA@basil.firstfloor.org> <alpine.LFD.1.00.0802091525400.3145@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802091525400.3145@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 09 Feb 2008 15:07:02.0159 (UTC) FILETIME=[6CB571F0:01C86B2D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 09, 2008 at 03:56:02PM +0100, Thomas Gleixner wrote:
> On Fri, 8 Feb 2008, Andi Kleen wrote:
> > There is a big difference between NX and RO. NX absolutely has to be cleared
> > or the kernel will fail while RO just can be set, but does not need to.
> > And for a large page area not setting NX if there is a area below 
> > it that needs it is essential, while making it ro is optional again.

Optional as in it doesn't need to be forced.

> 
> No, it's not optional. Making the PMD RO will write protect all 4k
> PTEs below independent of their setting. So there is the same
> restriction as we have with NX.

If there is a boundary between a RO area
and a RW area and you want to map it with 2MB pages then NX is required,
but RO is optional on the page and if you prefer TLB use minimalization
over debugging it is optional. Is it clear now? 

Note the behaviour for pageattr and thus DEBUG_RODATA / debugging
sitations where you don't care about your TLB this
does not change, this makes only a difference for the initial init_32
direct mapping setup.

-Andi
