Return-Path: <linux-kernel-owner+w=401wt.eu-S1752383AbYA2SPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383AbYA2SPS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 13:15:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbYA2SOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 13:14:21 -0500
Received: from iabervon.org ([66.92.72.58]:32774 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933388AbYA2SOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 13:14:18 -0500
Date: Tue, 29 Jan 2008 13:14:15 -0500 (EST)
From: Daniel Barkalow <barkalow@iabervon.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Richard Heck <rgheck@bobjweil.com>, Gene Heskett <gene.heskett@gmail.com>,
       Zan Lynx <zlynx@acm.org>, Calvin Walton <calvin.walton@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux ide Mailing list <linux-ide@vger.kernel.org>
Subject: Re: Problem with ata layer in 2.6.24
In-Reply-To: <20080129121201.2f727f5f@core>
Message-ID: <alpine.LNX.1.00.0801291202550.13593@iabervon.org>
References: <200801272122.21823.gene.heskett@gmail.com> <1201539043.31293.7.camel@zem> <1201540830.6526.19.camel@localhost> <200801281230.32910.gene.heskett@gmail.com> <alpine.LNX.1.00.0801281248190.13593@iabervon.org> <479E1D9E.3000900@bobjweil.com>
 <20080129121201.2f727f5f@core>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2008, Alan Cox wrote:

> > not one problem but lots---is sufficiently widespread that a Mini HOWTO, 
> > say, would be really welcome and, I'm guessing, widely used.
> 
> We don't see very many libata problems at the distro level and they for
> the most part boil down to
> 
> - error messages looking different - Most bugs I get are things like
> media errors (timeout looks different, UNC report looks different)

The SCSI error reporting really ought to include a simple interpretation 
of the error for end users ("The drive doesn't support this command" "A 
sector's data got lost" "The drive timed out" "The drive failed" "The 
drive is entirely gone"). There's too much similarity between the message 
you get when you try a SMART test that doesn't apply to the drive and what 
you get when the drive is broken.

> - faulty hardware being picked up because we actually do real error
> checking now. We now check for and give some devices more slack while
> still doing error checking. Both IDE layers also added blacklists for
> stuff like the TSScorp DVD drives. Qemu has now had its bugs patched.

I think this is the big source of unhappy users (and, of course, they all 
look the same and the reports stay findable by Google, so it looks a lot 
worse than it is). People getting this problem in distro kernels probably 
really do want to have a way to report it with enough detail from logs to 
get it dealt with and then switch back to old IDE until the fix propagates 
through.

And it's possible that the error recovery is suboptimal in some cases. It 
seems to like resetting drives too much; perhaps if it keeps seeing the 
same problem and resetting the drive, it should decide that the drive's 
error reporting is just bad and just ignore that error like the old IDE 
did (but, in this case, after saying what it's doing).

	-Daniel
*This .sig left intentionally blank*
