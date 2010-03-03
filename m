Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab0CCQ5r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 11:57:47 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48596 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754446Ab0CCQ5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 11:57:44 -0500
Date: Wed, 3 Mar 2010 08:46:54 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 19/62] Driver-Core: devtmpfs - remove EXPERIMENTAL and
 enable it by default
In-Reply-To: <m1635eow8a.fsf@fess.ebiederm.org>
Message-ID: <alpine.LFD.2.00.1003030839550.3627@localhost.localdomain>
References: <20100302230933.GA32287@kroah.com> <1267572541-410-19-git-send-email-gregkh@suse.de> <m1635eow8a.fsf@fess.ebiederm.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 2 Mar 2010, Eric W. Biederman wrote:

> Greg Kroah-Hartman <gregkh@suse.de> writes:
>> 
> > From: Kay Sievers <kay.sievers@vrfy.org>
> >
> > All major distros enable devtmpfs on recent systems, so remove
> > the EXPERIMENTAL flag, and enable it by default to reflect how it
> > is used today.
> 
> Default y?
> 
> Default y is the wrong thing for DEVTMPFS_MOUNT.  It changes the
> userspace semantics so I can't see how this is safe in the general
> case.
> 
> I also looked and the most recent bleeding edge distro I have fedora
> core 12 doesn't even compile in devtmpfs so this extraordinary claim
> that all major distros are using devtmpfs is far from true today.  It
> is certainly rare enough that changing there is not yet justification
> for changing the default.

Yeah, this justification is pure and utter sh*t.

We don't just randomly move it from EXPERIMENTAL to make it 'default y'.

In fact, as mentioned yesterday in an unrelated thread, we NEVER make 
something 'default y' unless it is required to maintain _old_ semantics 
(ie some config option that is required for previous behavior to be true), 
or unless it cures cancer.

Guys, I'll say it one more time: developers always feel that _their_ 
particular code is so important that it needs to be 'default y', because 
obviously their code must be used by everybody.

But that is pure and utter CRAP.

Something like the core input layer might be 'default y' because quite 
frankly, for 99% of users, if you don't enable it, the machine is useless. 
And the original keyboard driver used to be compiled in without question. 
And people who really don't want the input layer really _are_ special.

But some random new feature that nobody actually uses, has no legacy 
reasons? Nope. It's simply not 'default y' material.

So I'm not going to pull this crap. People need to learn that 'default y' 
is just WRONG.

Greg, please shut down people like Kay that want to enable something by 
default. We want a _minimal_  working config, not a maximal. If somebody 
has a distro that needs this, they can enable it _then_. Not "let's try to 
make people enable it whether they need it or not, because they _might_".

Because "might need it" is simply not good enough. A "must have" is the 
only reason to do 'default y'.

		Linus
