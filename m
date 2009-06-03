Return-Path: <linux-kernel-owner+w=401wt.eu-S1755933AbZFCUBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933AbZFCUBp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 16:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323AbZFCUBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 16:01:38 -0400
Received: from r00tworld.com ([212.85.137.21]:41513 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbZFCUBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 16:01:37 -0400
From: pageexec@freemail.hu
To: "Larry H." <research@subreption.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 03 Jun 2009 22:00:52 +0200
MIME-Version: 1.0
Subject: Re: Security fix for remapping of page 0 (was [PATCH] Change ZERO_SIZE_PTR to point at unmapped space)
Reply-to: pageexec@freemail.hu
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Christoph Lameter <cl@linux-foundation.org>, linux-mm@kvack.org,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org
Message-ID: <4A26D674.10117.2E18A862@pageexec.freemail.hu>
In-reply-to: <alpine.LFD.2.01.0906031145460.4880@localhost.localdomain>
References: <20090530230022.GO6535@oblivion.subreption.com>, <alpine.LFD.2.01.0906031142390.4880@localhost.localdomain>, <alpine.LFD.2.01.0906031145460.4880@localhost.localdomain>
X-mailer: Pegasus Mail for Windows (4.50 PB1)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Wed, 03 Jun 2009 22:00:56 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 Jun 2009 at 11:50, Linus Torvalds wrote:

> 
> 
> On Wed, 3 Jun 2009, Linus Torvalds wrote:
> > 
> > That means that you've already by-passed all the main security. It's thus 
> > by definition less common than attack vectors like buffer overflows that 
> > give you that capability in the first place.
> 
> Btw, you obviously need to then _also_ pair it with some as-yet-unknown 
> case of kernel bug to get to that NULL pointer (or zero-sized-alloc 
> pointer) problem. 

are you saying it's hard to find 'as-yet-unknown' null-deref bugs? what about
'already-known-but-not-yet-fixed-in-distro-kernel' ones? especially when the
disclosure process was, let's say, less than 'full'.

> You _also_ seem to be totally ignoring the fact that we already _do_ 
> protect against NULL pointers by default.

this whole discussion about NULL derefs is quite missing the point by the way.
the proper bug class is about unintended userland ptr derefs by the kernel,
of which NULL derefs are a small subset only. and you can't protect against
it by default or otherwise by banning userland from using its address space ;).

fixing ZERO_SIZE_PTR is about not making the mess of mixing userland/kernel
addresses worse, that's all. small piece of the parcel but then it's obviously
correct too.

> So I really don't see why you're making a big deal of this. It's as if you 
> were talking about us not randomizing the address space - sure, you can 
> turn it off, but so what? We do it by default.

and the amount of it is easily bruteforceable not to mention lack of
protection against said bruteforce. don't rest on your laurels yet ;).

> So it boils down to:
> 
>  - NULL pointers already cannot be in mmap memory

not all NULL deref bugs are literally around address 0, there's often an
offset involved, sometimes even under the attacker's control (a famous
userland example is discussed in 
   http://documents.iss.net/whitepapers/IBM_X-Force_WP_final.pdf
).

> (unless a distro has 
>    done something wrong - outside of the kernel)

do you have data about which distros and kernels enable this? and how
they handle v86 and stuff? suid root equivalent or something better?

