Return-Path: <linux-kernel-owner+w=401wt.eu-S1760457AbXJ3TeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760457AbXJ3TeO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 15:34:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760081AbXJ3TcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 15:32:01 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40377 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760072AbXJ3Tb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 15:31:59 -0400
Date: Tue, 30 Oct 2007 12:31:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: Mikael Pettersson <mikpe@it.uu.se>,
       Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata fixes
In-Reply-To: <47278206.2080601@garzik.org>
Message-ID: <alpine.LFD.0.999.0710301225370.30120@woody.linux-foundation.org>
References: <20071030184502.GA27246@havoc.gtf.org>
 <alpine.LFD.0.999.0710301151000.30120@woody.linux-foundation.org>
 <47278206.2080601@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 30 Oct 2007, Jeff Garzik wrote:
> 
> Can we change git-am to accept two dashes as well as three?  :)
> 
> It seems pretty common, not just with Mikael but several others who send
> patches to me.

Well, git-am actually used to be a lot less strict about the dashes, and 
we've made it *more* strict rather than less, because the more of these 
breaks we accept, the more likely it is that something that was intended 
to be part of the message gets thrown out.. So I'll say that I'm a bit 
nervous about extending it again.

The reason for the three dashes is actually that that is what a *diff* 
starts with. So if you look at what "closes" a description as far as 
git-am is concerned, they are currently all things that are likely to 
start a patch: "Index: " or "diff -" or "--- <filename>", and that last 
case was then extended to be "manual break" even without the filename 
information.

See git/builtin-mailinfo.c: patchbreak().

But you could try to sell it to Junio. He's the maintainer, and while I 
care about some other things and will argue violently against them, when 
it comes to something like this, Junio is the guy to go to.

That said, I really think you could just try to educate the people you 
work with. Maybe they just never even realized that "three dashes" is what 
you're supposed to use!

		Linus
