Return-Path: <linux-kernel-owner+w=401wt.eu-S1757315AbZALVwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315AbZALVwT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 16:52:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753819AbZALVwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 16:52:03 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38388 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753560AbZALVwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 16:52:00 -0500
Date: Mon, 12 Jan 2009 13:51:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tim Abbott <tabbott@MIT.EDU>
Cc: andi@firstfloor.org, jbarnold@MIT.EDU, linux-kernel@vger.kernel.org,
       vda.linux@googlemail.com, andersk@MIT.EDU, wdaher@MIT.EDU,
       knikanth@suse.de
Subject: Re: [PATCH 1/7] Make section names compatible with
 -ffunction-sections -fdata-sections
Message-Id: <20090112135127.7a0bb392.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.0901011725320.10164@vinegar-pot.mit.edu>
References: <1228521840-3886-1-git-send-email-jbarnold@mit.edu>
	<1228521840-3886-2-git-send-email-jbarnold@mit.edu>
	<8763lxwv0d.fsf@basil.nowhere.org>
	<alpine.DEB.2.00.0812311410070.2230@vinegar-pot.mit.edu>
	<20081231195215.GU496@one.firstfloor.org>
	<alpine.DEB.2.00.0812311649180.2230@vinegar-pot.mit.edu>
	<20090101083230.34cffeac.akpm@linux-foundation.org>
	<alpine.DEB.2.00.0901011725320.10164@vinegar-pot.mit.edu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Jan 2009 14:20:35 -0500 (EST)
Tim Abbott <tabbott@MIT.EDU> wrote:

> On Thu, 1 Jan 2009, Andrew Morton wrote:
> 
> > OK, it hits a lot of files in minor ways.
> >
> > You could ask Linus to merge it late in the -rc1 merge window (please
> > cc me on the email).  Or you could just send it to me (with the usual
> > cc's) and I'll toss it into my 2.6.29-rc1 pile.  I doubt if it'll cause
> > much trouble.  But please do check its applicability to linux-next - people
> > have been moving arch files into different directories lately.
> 
> Andrew,
> 
> I've attached for you a version of the patch the applies to current 
> linux-next (next-20090102).
> 
> It does not apply to Linus' current master because d3794979a in linux-next 
> adds use of the ".data.percpu.first" section name, which this patch 
> updates to ".kernel.data.percpu.first".  I think it'll be easiest to just 
> merge this after d3794979a.
> 
> If a version of d3794979a is not going to be merged first, there will be 
> two merge conflicts that are easy to resolve as they are changes to code 
> added by d3794979a, but we'll then need to fix d3794979a before merging 
> d3794979a.
> 

I don't think anyone will want to carry this in a non-mainline tree for
any amount of time.  it'd be best to squeeze it into mainline pretty
much immediately.  But...

> This patch was originally written by Denys Vlasenko, but it has been
> substantially modified by Anders Kaseorg and Tim Abbott to update it
> to apply to the current kernel and fix bugs.  Any bugs were added by
> Anders Kaseorg and Tim Abbott.
> 
> The purpose of this patch is to make it possible to build the kernel
> with "gcc -ffunction-sections -fdata-sections".
> 
> The problem is that with -ffunction-sections -fdata-sections, gcc
> creates sections like .text.head and .data.nosave whenever someone has
> innocuous code like this:
> 
> static void head(...) {...}
> 
> or this:
> 
> static int nosave = 1;
> 
> somewhere in the kernel.
> 
> The kernel linker scripts are confused by such names, and thus put
> these sections in the wrong places.
> 
> This patch renames all "magic" section names used by the kernel to not
> have this format, eliminating the possibility of such collisions.
> 
> Ksplice's 'run-pre matching' process is much simpler if the original
> kernel was compiled with -ffunction-sections and -fdata-sections.
> 

The changelog gives us no reason to do that.

So we `make it possible to build the kernel > with "gcc
-ffunction-sections -fdata-sections"'.  So what?  Where is the value in
that?

