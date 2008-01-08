Return-Path: <linux-kernel-owner+w=401wt.eu-S1754688AbYAHSxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688AbYAHSxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 13:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbYAHSxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 13:53:05 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:35200 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbYAHSxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 13:53:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=ZaoGJ7GXlAvlkfmzPEjCiAM/tq1CioHoYcRYLrnLRvHleTLYGsZ2s1lNmkpasDaGkfGRbIHNz/ZpXMJB5tkly5Kg1cDK+0id2TWcB6C4ualAMYHhYJTqvKmPRwHOjiG/7kXL6Kb2ruTPHguyzHavH1AnBbM4OXtR4lU9PRy2rl0=
Date: Tue, 8 Jan 2008 21:52:56 +0300
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       paolo.ciarrocchi@gmail.com, gorcunov@gmail.com
Subject: Re: [JANITOR PROPOSAL] Switch ioctl functions to ->unlocked_ioctl
Message-ID: <20080108185255.GA4627@martell.zuzino.mipt.ru>
References: <20080108164015.GC31504@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080108164015.GC31504@one.firstfloor.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2008 at 05:40:15PM +0100, Andi Kleen wrote:
> Here's a proposal for some useful code transformations the kernel janitors
> could do as opposed to running checkpatch.pl.
> 
> Most ioctl handlers still running implicitely under the big kernel 
> lock (BKL). But long term Linux is trying to get away from that. There is a new
> ->unlocked_ioctl entry point that allows ioctls without BKL, but the code
> needs to be explicitely converted to use this.
> 
> The first step of getting rid of the BKL is typically to make it visible
> in the source. Once it is visible people will have incentive to eliminate it.
> That is how the BKL conversion project for Linux long ago started too.
> On 2.0 all system calls were still implicitely BKL and in 2.1 the
> lock/unlock_kernel()s were moved into the various syscall functions and then
> step by step eliminated.
> 
> And now it's time to do the same for all the ioctls too.
> 
> So my proposal is to convert the ->ioctl handlers all over the tree 
> to ->unlocked_ioctl with explicit lock_kernel()/unlock_kernel.

Thanks, Andi! I think it'd very useful change.
