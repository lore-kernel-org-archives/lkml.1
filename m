Return-Path: <linux-kernel-owner+w=401wt.eu-S1754625AbYEZKtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbYEZKtL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 06:49:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436AbYEZKs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 06:48:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55225 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753425AbYEZKsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 06:48:55 -0400
Date: Mon, 26 May 2008 12:48:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@linux.intel.com>,
       Jan Kara <jack@suse.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Top 10 bugs/warnings for the week of March 23rd, 2008
Message-ID: <20080526104832.GG23261@elte.hu>
References: <4836EE8C.1010200@linux.intel.com> <20080524222304.GD20563@atrey.karlin.mff.cuni.cz> <20080524153020.1df96cf2@linux.intel.com> <20080524224554.GA5970@mit.edu> <20080526093913.GG13529@elte.hu> <20080526101646.GD24507@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080526101646.GD24507@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0012]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Theodore Tso <tytso@MIT.EDU> wrote:

> On Mon, May 26, 2008 at 11:39:13AM +0200, Ingo Molnar wrote:
> > Exactly why is pulling an USB stick considered "stupid"? Last i checked 
> > there was no physical lock preventing users from doing that.
> > 
> > Sure, pulling a mounted USB stick is inconvenient ... for _us_ 
> > kernel developers. But the user really doesnt care and shouldnt 
> > care.
> 
> Because they could lose data?  Because if the kernel wakes up and 
> tries writing to the USB stick right as they pull it out, it could 
> physically damage the flash format?  I know, stupid reason...  :-)

user can lose data in many other ways, that's not the issue - the issue 
here is something very crutial: the kernel gets confused about a _very_ 
common user-triggerable condition.

That confusion must not happen in a modern OS and the kernel should be 
resilient and cope with such external events. And we must not 
deprioritize it with an incorrect "user did something stupid" tag... 
That argument might have been valid 15 years ago when floppies could be 
locked and you needed a needle to force-eject it but it is rather lame 
today when unplugging an USB stick is as easy as moving the mouse.

If there's something stupid here it's the kernel not dealing with that 
condition properly. Yes, the "user action" here looks "trivial" to the 
user but what happens below is indeed very hard technically, but who 
said that writing an OS from scratch would be an easy task? ;-)

	Ingo
