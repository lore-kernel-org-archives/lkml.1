Return-Path: <linux-kernel-owner+w=401wt.eu-S1762105AbXGES4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762105AbXGES4j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 14:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760243AbXGES4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 14:56:30 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34250 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760168AbXGES42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 14:56:28 -0400
Date: Thu, 5 Jul 2007 11:56:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ftp.linux.org.uk>
cc: linux-sparse@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] bloody mess with __attribute__() syntax
In-Reply-To: <20070705180742.GP21478@ftp.linux.org.uk>
Message-ID: <alpine.LFD.0.98.0707051144560.9434@woody.linux-foundation.org>
References: <20070705093528.GK21478@ftp.linux.org.uk>
 <alpine.LFD.0.98.0707050930330.9434@woody.linux-foundation.org>
 <20070705170918.GO21478@ftp.linux.org.uk> <alpine.LFD.0.98.0707051014380.9434@woody.linux-foundation.org>
 <20070705180742.GP21478@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 5 Jul 2007, Al Viro wrote:
> 
> I.e. you get per-attribute rules (fsckloads of them) and no way to tell
> what do the attributes apply to unless you know the rules for given attribute.

It basically boils down to "__attribute__((x))" is basically a _single_ 
keyword.

There is no "__attribute__" on its own, or "x" on its own. The two do not 
make sense separately. 

And that's the _accurate_ way of seeing attribute. Seeing it as a "type 
attribute" is actively wrong, and that kind of thinking just leads you 
down the wrong path (not just with qualifiers, but with __attribute__ as 
done by gcc itself, where it's used for more than type attributes).

> I just don't like having no relationship between the syntax and operations
> on types, that's all.

You seem to think that "__attribute__" has some meaning of its own.

Not true. 

Gcc already has things like

	__attribute__((extended))

which acts not on types or variables, but on expressions and statements.

And it does not *make*sense* to think of that as just another "attribute". 
It is *not* about the same kind of attributes as the type attributes at 
all! If you think it is, you're thinking about it wrong. It's a totally 
different kind of thing.

So instead of thinking about "__attribute__" as having some stand-alone 
semantic meaning (it does *not*), think of it the way I do: the 
"__attribute__" part is just an escape sequence into an extended parsing 
thing, and "__attribute__((extended))" is really just another way to give 
a way to say the _extended_ thing, without having to make it a keyword, 
with all that implies.

In other words, I think your "__qualifier__" idea is fundamentally wrong, 
because it misses the real _point_ of "attribute()". 

The real point of "__attribute__" is that it's mis-named. But that does 
not mean that it should be named "__qualifier__", because that just 
re-inforces the initial mistake. Instead, it probably _should_ have been 
named "__extension__", or something like that (or maybe "__escape__" or 
"__magic_keyword__").

That ends up explaining all the gcc semantics. Because "__attribute__" as 
gcc uses it really isn't about attributes per se, it's about extensions to 
C semantics, in a way that doesn't violate the C rules that much, and in a 
way that doesn't introduce infinite numbers of special identifiers in the 
same global name-space.

So yes, I'd be ok with renaming it, and I don't think "__attribute__" is a 
wonderful name, but we named it for gcc compatibility, so we're kind of 
stuck with the name. But that doesn't mean that we have to be stuck with 
thinking about it as a "symbol node attribute", because it really isn't, 
and has never been that, even in gcc.

		Linus
