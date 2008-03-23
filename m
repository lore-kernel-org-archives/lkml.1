Return-Path: <linux-kernel-owner+w=401wt.eu-S1757093AbYCWRgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093AbYCWRgt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 13:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753009AbYCWRgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 13:36:39 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:63147 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbYCWRgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 13:36:39 -0400
To: Jiri Slaby <jirislaby@gmail.com>
Cc: David Miller <davem@davemloft.net>, viro@ZenIV.linux.org.uk,
       joe@perches.com, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: checkpatch [was: include/asm-x86/serial.h: checkpatch cleanups - formatting only]
References: <47E647AC.1060906@gmail.com>
	<20080323.051929.267232495.davem@davemloft.net>
	<47E64BF7.4070808@gmail.com>
	<20080323.053037.144236584.davem@davemloft.net>
	<47E651BE.1080107@gmail.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 23 Mar 2008 18:36:21 +0100
In-Reply-To: <47E651BE.1080107@gmail.com>
Message-ID: <877ift8hre.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 23 Mar 2008 17:29:51.0928 (UTC) FILETIME=[8073AB80:01C88D0B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby <jirislaby@gmail.com> writes:
> 
> It just spits out warnings/errors like compiler or some static
> analyzer, maybe I'm terribly missing something, what exactly do you
> mind on the output?

A good example are the trailing white space warnings in there. They
are just useless and a waste of time. That is something that really
should just be done automatically by maintainer scripts somewhere on
merge (and a lot of maintainers do it automatically), not waste the
valuable time of a human.

There are also a couple of other pointless warnings. e.g. I dislike
some of the style warnings -- they are far too broad. Or there 
can be good reasons to violate them occasionally. e.g. I would
rather put not a space around an operator occasionally instead
of splitting an expression to avoid going over 80 characers. 
Or the EXPORT_SYMBOL warning. WTF is that good for? Or 
the warning about if () ... else { ... }.

Also checkpatch.pl --file seems to be a good candidate for one
of the worst ideas ever merged (to be fair it was difficult
to see it would become that bad in advance -- but it got) 

On the other hand a few of the pattern matches are ful.

To fix the worst problems of checkpatch.pl one could probably 
do something like this:
- Get rid of --file
- Drop at least 50% of the style warnings (or make them 
not trigger unless a special option is given) and review all
the others.
- Concentrate on the really useful things like checking
for deprecated functions and pattern matching for a few 
common mistakes.

-Andi
