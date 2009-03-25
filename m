Return-Path: <linux-kernel-owner+w=401wt.eu-S1755982AbZCYXMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982AbZCYXMG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 19:12:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752336AbZCYXLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 19:11:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36486 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750849AbZCYXLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 19:11:54 -0400
Date: Wed, 25 Mar 2009 16:02:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ric Wheeler <rwheeler@redhat.com>
cc: Jeff Garzik <jeff@garzik.org>, Theodore Tso <tytso@mit.edu>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <49CA9AD2.1080402@redhat.com>
Message-ID: <alpine.LFD.2.00.0903251600310.3032@localhost.localdomain>
References: <20090324093245.GA22483@elte.hu> <20090324101011.6555a0b9@lxorguk.ukuu.org.uk> <20090324103111.GA26691@elte.hu> <20090324132032.GK5814@mit.edu> <alpine.LFD.2.00.0903241053200.3032@localhost.localdomain> <20090324184549.GE32307@mit.edu>
 <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain> <49C93AB0.6070300@garzik.org> <20090325093913.GJ27476@kernel.dk> <49CA86BD.6060205@garzik.org> <20090325194341.GB27476@kernel.dk> <49CA9346.6040108@garzik.org> <alpine.LFD.2.00.0903251337410.3032@localhost.localdomain>
 <49CA9AD2.1080402@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 Mar 2009, Ric Wheeler wrote:
> 
> One concern with doing this above the file system is that you are not in the
> context of a transaction so you have no clean promises about what is on disk
> and persistent when. Flushing the cache is primitive at best, but the way
> barriers work today is designed to give the transactions some pretty critical
> ordering semantics for journalling file systems at least.
> 
> I don't see how you could use this approach to make a really robust, failure
> proof storage system, but it might appear to work most of the time for most
> people :-)

You just do a write barrier after doing all the filesystem writing, and 
you return with the guarantee that all the writes the filesystem did are 
actually on disk.

No gray areas. No questions. No "might appear to work". 

Sure, there might be other writes that got flushed _too_, but nobody 
cares. If you have a crash later on, that's always true - you don't get 
crashes at nice well-defined points.

			Linus
