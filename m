Return-Path: <linux-kernel-owner+w=401wt.eu-S1757291AbZGFAly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291AbZGFAly (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 20:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756596AbZGFAlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 20:41:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39291 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756130AbZGFAlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 20:41:47 -0400
Date: Sun, 5 Jul 2009 17:40:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ulrich Drepper <drepper@gmail.com>
cc: Miklos Szeredi <miklos@szeredi.hu>, dhowells@redhat.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org,
       mtk.manpages@gmail.com
Subject: Re: [RFC PATCH] vfs: new open(2) flag to open filesystem node
In-Reply-To: <a36005b50907051235h17f559c6w1937998c7eec0b0@mail.gmail.com>
Message-ID: <alpine.LFD.2.01.0907051735030.3210@localhost.localdomain>
References: <E1MLa4R-00054S-94@pomaz-ex.szeredi.hu> <2547.1246393535@redhat.com>  <E1MLruc-0007O1-Sp@pomaz-ex.szeredi.hu> <a36005b50907051235h17f559c6w1937998c7eec0b0@mail.gmail.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 5 Jul 2009, Ulrich Drepper wrote:
> 
> I am still not sure whether this shouldn't rather be an implementation
> of POSIX's O_SEARCH or whether it is already an O_SEARCH
> implementation.

Umm. That makes no sense at all.

O_SEARCH is only meaningful for directories. For anything else, it's not 
at all POSIX - it's expressly defined to be "undefined".

So clearly, O_SEARCH is absolutely the _wrong_ thing to do. Claiming that 
"it is POSIX" is pure and utter garbage, because it is _not_ POSIX in any 
relevant way. Sure, POSIX allows us to have flying monkeys out of our 
butts when you specify O_SEARCH, but where's the advantage? Undefined 
behavior is undefined behavior. 

It would be clearly and unambiguously _better_ to have another O_xyz flag, 
that people can then do

	#ifdef O_xyz
		.. get some well-defined Linux extension behavior ..
	#endif

in their source code, rather than overlead an undefined case with random 
crap.

			Linus
