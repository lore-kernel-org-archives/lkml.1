Return-Path: <linux-kernel-owner+w=401wt.eu-S1765389AbZLQVWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765389AbZLQVWT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 16:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765357AbZLQVWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 16:22:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59617 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757903AbZLQVWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 16:22:15 -0500
Date: Thu, 17 Dec 2009 13:22:12 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: linux-kernel@vger.kernel.org
Subject: Re: [git pull] vfs pile 2
In-Reply-To: <20091217183952.GC18217@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.2.00.0912171316220.15740@localhost.localdomain>
References: <20091217162454.GA18217@ZenIV.linux.org.uk> <alpine.LFD.2.00.0912170831030.15740@localhost.localdomain> <20091217180319.GB18217@ZenIV.linux.org.uk> <alpine.LFD.2.00.0912171008220.15740@localhost.localdomain>
 <20091217183952.GC18217@ZenIV.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 17 Dec 2009, Al Viro wrote:
> 
> reflog had been pruned already; still no effect.  Moreover, after looking
> through the loose objects, I've found several commits that are definitely
> reachable from master and now from your tree as well.  E.g.
> objects/ea/ff8079d4f1016a12e34ab323737314f24127dd
> is one of those - it's a commit and it's both in mainline *and* happens
> to be tip of master.  No questions about being unreachable and AFAICS
> no reasons whatsoever to leave it as a loose object...

If you want a maximal pack, use "git repack -Adl"

The default gc thing will stop when it hits stuff that has been packed 
already, which can leave _older_ unpacked objects unpacked. And since my 
own repo isn't always fully packed, and git will only remove local objects 
if they are available as _packed_ objects in the reference tree (ie my 
repo), you'll end up with that kind of situation.

I usually repack my tree a couple of times per release, no more often, so 
you'll seldom see _perfect_ packing.

		Linus

