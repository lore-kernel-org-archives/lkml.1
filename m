Return-Path: <linux-kernel-owner+w=401wt.eu-S1756060AbYGPA6E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060AbYGPA6E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 20:58:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbYGPA5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 20:57:54 -0400
Received: from r00tworld.com ([212.85.137.21]:37464 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbYGPA5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 20:57:54 -0400
From: pageexec@freemail.hu
To: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 16 Jul 2008 02:56:04 +0200
MIME-Version: 1.0
Subject: Re: [stable] Linux 2.6.25.10
Reply-to: pageexec@freemail.hu
CC: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Message-ID: <487D6344.18581.1CD50DA5@pageexec.freemail.hu>
In-reply-to: <alpine.LFD.1.10.0807151716510.2867@woody.linux-foundation.org>
References: <20080703185727.GA12617@suse.de>, <487D5729.14854.1CA5C3EB@pageexec.freemail.hu>, <alpine.LFD.1.10.0807151716510.2867@woody.linux-foundation.org>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Wed, 16 Jul 2008 02:56:50 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 Jul 2008 at 17:24, Linus Torvalds wrote:

> On Wed, 16 Jul 2008, pageexec@freemail.hu wrote:
> > 
> > we went through this and you yourself said that security bugs are *not*
> > treated as normal bugs because you do omit relevant information from such
> > commits
> 
> Actually, we disagree on one fundamental thing. We disagree on 
> that single word: "relevant".

we'll see :)

> I do not think it's helpful _or_ relevant to explicitly point out how to 
> tigger a bug.

nor did i say that (actually, what i said is that it didn't belong into
the commit message, see below for more).

> It's very helpful and relevant when we're trying to chase 
> the bug down, but once it is fixed, it becomes irrelevant.

you're wrong on that however. it is important for many people to able
to perform the same verification that you do. just imagine the backports
to versions that you don't do yourselves. but organizing the dissemination
of such code is not what i've been talking about all this time.
 
> You think that explicitly pointing something out as a security issue is 
> really important, so you think it's always "relevant".

don't mistake my presence in this thread as me, an invidual arguing for his
own benefit. i already know when you fix security bugs, even when you don't
sometimes. so when i say something is relevant, it's not merely my opinion,
it's what most people dealing with security issues (both inside and outside
the linux universe) think. with that said, let's move on:

> And I take mostly the opposite view. I think pointing it out is
> actually likely to be counter-productive. 

you keep saying that, but you don't explain *why*.

> For example, the way I prefer to work is to have people send me and the 
> kernel list a patch for a fix, and then in the very next email send (in 
> private) an example exploit of the problem to the security mailing list 
> (and that one goes to the private security list just because we don't want 
> all the people at universities rushing in to test it). THAT is how things 
> should work.

fine with me, i wasn't talking about that at all though ;).

> Should I document the exploit in the commit message? Hell no.

fully understood and agreed. never even asked for that.

>  It's private for a reason, even if it's real information. It was real
> information for the developers to explain why a patch is needed, but
> once explained, it shouldn't be spread around unnecessarily. 

agreed (with the same additonal thoughts as above on the trigger code).

ok, so let's make it simpler for everyone to understand what is at issue
here. it seems that we agree that there're several levels of information
that exist when it comes to security bugs and we don't understand each
other as to what should go into a commit and what should stay out. let
me propose a categorization and you tell me what you think you would be
willing to put into a commit (feel free to break them up further if that's
what it takes).

1. simple words/phrases that one can grep for (mentally or automated)
   examples: 'security', 'exploitable', 'DoS', 'buffer overflow', etc

2. simple sentence describing roughly what kind of security bug it is
   example: fix exploitable null function pointer dereference in foo.

3. sample code able to trigger the bug and cause an oops/crash but not
   privilege elevation, no effort made to be 'weapons grade' (does not
   support several archs, kernel versions, etc)

4. proof-of-concept exploit that triggers the bug, and demonstrates its
   effect (say privilege elevation) with manual tweaking (say, you look
   up an address in System.map and the like, but nothing automated)

5. full blown weaponized exploit

i believe 3-5 are definitely not commit message material. 1 or 2 are.
5 should never be published or disseminated, 3 and 4 may be distributed
to interested parties.

cheers,
  PaX Team

