Return-Path: <linux-kernel-owner+w=401wt.eu-S1422952AbXD3ECo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422952AbXD3ECo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 00:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422967AbXD3ECo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 00:02:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422952AbXD3ECm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 00:02:42 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Christoph Hellwig <hch@lst.de>
X-Fcc: ~/Mail/utrace
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] utrace: remove exports
In-Reply-To: Christoph Hellwig's message of  Wednesday, 18 April 2007 20:01:13 +0200 <20070418180113.GA18485@lst.de>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20070430040232.EB3DD1801A4@magilla.sf.frob.com>
Date: Sun, 29 Apr 2007 21:02:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> All the exports in utrace are totally unused, and not really something
> I'd want modules to use anyway :)

Previously you said:

> EXPORT_SYMBOL_GPL(utrace_attach);
> 
> 	There is not modular user of this, so this and the other utrace_
> 	functions should not be exported.  Nor do I think that exporting
> 	such a low-level process control is nessecary a good idea, but
> 	we'll have to evaluate that if patches to add users show up.

If you remove the exports, just throw the whole thing away.
The reason utrace exists is to be used by modules.

It's true that the only users around are some simple test and demo
modules I've done, and some unfinished and experimental work such as
uprobes.  When useful things built on utrace get hashed out and in a
functional state ready for general consumption, then it may be time to
put them in the kernel tree.  (All the work I'm aware of is pretty well
public already, just not in any condition to be submitted.)

There is something of a chicken and egg problem here.  In the current
kernel, most people consider adding or enhancing a user debugging
facility to be intractable.  The intent of utrace is to make
experimenting and developing in this area feasible.  If it's not there,
people can't play with it.  If someone has to have a serious use before
it can be there, it's never going to be easy for anyone to get their
feet wet so they might wind up producing something serious.  

I hope there settles to be one main, nice, new thing at a higher level
with a sane user-level interface, that most everyone wants to use.
Manifestly, I have been taking my sweet time coming up with something
worth talking about so far.  Even when I do produce something like that,
I don't expect everyone to like everything about it that I like.
Someone else might produce something better or sooner or both--but noone
else seems to want to do something else new at the lowest layer.  The
basic utrace interface is about as straightforward in the core kernel
implementation context as it can be while allowing multiple unrelated
higher-level agents to coexist, and cleaning up the interfaces into
machine-dependent code.  The complexities it does have stem from efforts
to make it easier not to write bugs in the higher layers and to make it
harder to write bugs that badly derail user processes or the system
overall.  The hope is to give people a chance to write interesting
things and mitigate some of the most onerous debugging of such things.
Perhaps one day everything anyone wants to do will be based around a
higher-level thing by me or someone else, and the need for the low-level
utrace platform will fall away.  But I tend to think there will always
be some specialized uses for which people want a lower-level base to
work on.  I think of utrace like the block device layer: most people
don't care about that layer, they just want to use a filesystem and
other things above that; but there are always people who want to do some
special thing directly on the lower level, or want to start over
building an entirely different style of filesystem.


Thanks,
Roland
