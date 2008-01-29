Return-Path: <linux-kernel-owner+w=401wt.eu-S934047AbYA2TOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934047AbYA2TOl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 14:14:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765693AbYA2TO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 14:14:27 -0500
Received: from iabervon.org ([66.92.72.58]:35051 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933761AbYA2TO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 14:14:26 -0500
Date: Tue, 29 Jan 2008 14:14:13 -0500 (EST)
From: Daniel Barkalow <barkalow@iabervon.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Richard Heck <rgheck@bobjweil.com>, Gene Heskett <gene.heskett@gmail.com>,
       Zan Lynx <zlynx@acm.org>, Calvin Walton <calvin.walton@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux ide Mailing list <linux-ide@vger.kernel.org>
Subject: Re: Problem with ata layer in 2.6.24
In-Reply-To: <20080129184613.16846ae5@core>
Message-ID: <alpine.LNX.1.00.0801291354240.13593@iabervon.org>
References: <200801272122.21823.gene.heskett@gmail.com> <1201539043.31293.7.camel@zem> <1201540830.6526.19.camel@localhost> <200801281230.32910.gene.heskett@gmail.com> <alpine.LNX.1.00.0801281248190.13593@iabervon.org> <479E1D9E.3000900@bobjweil.com>
 <20080129121201.2f727f5f@core> <alpine.LNX.1.00.0801291202550.13593@iabervon.org> <20080129184613.16846ae5@core>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2008, Alan Cox wrote:

> > The SCSI error reporting really ought to include a simple interpretation 
> > of the error for end users ("The drive doesn't support this command" "A 
> > sector's data got lost" "The drive timed out" "The drive failed" "The 
> > drive is entirely gone"). There's too much similarity between the message 
> > you get when you try a SMART test that doesn't apply to the drive and what 
> > you get when the drive is broken.
> 
> That would be the SCSI verbose messages option. I think the Eric
> Youngdale consortium added it about Linux 1.2. Nowdays its always built
> that way.

I've seen a lot of verbosity out of SCSI messages, but I haven't seen a 
straightforward interpretation of the problem in there. It's all 
information useful for debugging, not information useful for system 
administration.

> > And it's possible that the error recovery is suboptimal in some cases. It 
> > seems to like resetting drives too much; perhaps if it keeps seeing the 
> > same problem and resetting the drive, it should decide that the drive's 
> > error reporting is just bad and just ignore that error like the old IDE 
> > did (but, in this case, after saying what it's doing).
> 
> Nothing like casually praying the users data hasn't gone for a walk is
> there. If we don't act on them the users don't report them until
> something really bad occurs so that isn't an option.

On the other hand, bringing the system down because a device is 
misbehaving is a poor idea. I've personally recovered most of the data off 
of a dying drive because the system was willing to let me keep using the 
drive anyway; IIRC, the drive didn't work at all after a reboot, so I 
would have lost all the data instead of only a little had the system 
insisted on a perfectly functioning drive in order to use it at all.

There ought to be some middle ground between doing nothing until the 
computer really breaks and breaking the computer before then, but that's 
an issue not specific to libata.

	-Daniel
*This .sig left intentionally blank*
