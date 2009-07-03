Return-Path: <linux-kernel-owner+w=401wt.eu-S1758553AbZGCSXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758553AbZGCSXX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 14:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756644AbZGCSXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 14:23:16 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40853 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756472AbZGCSXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 14:23:15 -0400
Date: Fri, 3 Jul 2009 19:24:29 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] vt: add an event interface
Message-ID: <20090703192429.52bab220@lxorguk.ukuu.org.uk>
In-Reply-To: <20090703161021.GA21399@elte.hu>
References: <20090703064518.GA30674@elte.hu>
	<20090703100834.6cb241b6@lxorguk.ukuu.org.uk>
	<20090703091655.GB3902@elte.hu>
	<20090703104459.1d9d0bbf@lxorguk.ukuu.org.uk>
	<20090703095432.GC21141@elte.hu>
	<20090703110620.64fd1283@lxorguk.ukuu.org.uk>
	<20090703102234.GA32128@elte.hu>
	<20090703114431.37abd528@lxorguk.ukuu.org.uk>
	<20090703131727.GA3207@elte.hu>
	<20090703143746.0379b2ee@lxorguk.ukuu.org.uk>
	<20090703161021.GA21399@elte.hu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The thing is, IMO if the author or the affected maintainer(s) are 
> not willing to do _basic_ cleanup of new drivers, they simply dont 
> deserve more substantial review.

That ignores what is actually going on:

Firstly what happens is someone posts a draft of their new driver. What
they get back is
- Mails from people who clearly can't work a compiler but can run
  checkpatch and have nothing useful to do, who complain about spaces and
  brackets
- Little or no feedback on actual code

What they actually need is

- Feedback on the code - particularly algorithms, areas they could use
  kernel library functions better, obvious design flaws
- Feedback on gross style issues ("Dude lose the Hungarian notation") NOT
  "Checkpatch says line 151 has a bogus space haha you suck" which is how
  the sort of replies they get today must feel. Even things like "here's
  a handy indent script". Stupid as it sounds I stopped one driver vendor
  throwing in the towel simply because they didn't know about indent,
  nobody told them and they thought they'd have to assign one of their
  developers to play space pusher.

There is a simple reason for focussing on big code issues (and major
style) first:

If the code has minor style issues then fine for a new driver at the end
of the day it is important to clean it up. That goes even for the stuff
Checkpatch doesn't handle (like taste). There is however no point doing
that for minor style until the code is algorithmically and generally
stylistically in shape because much of what you clean up may not be there
in the final version anyway.

So the world the checkpatch nutters create is one where a newcomer cannot
get useful feedback on their code without fixing every single space, in
order to be told after that actually you know 2/3rds of that code can be
deleted and use the rbtree library instead. That's just wrong and a huge
block to new users. What is worse is for a lot of submissions what you
actually get is the can't work a C compiler checkpatch nutters whining
about silly spaces issues and then when that is finished the actual
submission gets ignored - totally - despite the efforts of a few people
(official hero AKPM notably) to catch them all.

In the case where someone submits a new driver that is elegant code with
minor style problems, then and only then is it appropriate to say "please
tidy that comment to fit 80 columns". It would be nice if the people
doing that could a) program and b) bothered to say things like "nice
code, structure looks right, just needs a final polish" rather than
parroting checkpatch pastes.

(Real world reality check for people here: Faced with a student who hands
in a badly presented first draft of a school assignment with good basic
facts does the teacher
    - read out loud each minor spelling mistake for the class to laugh at
 or - point out the strong areas, categorise the general weaknesses and
      suggest strategies for improvement, and while maybe suggesting
      using the spellchecker, believe the student can work that out if
      they are told it will be important next time

 Its an obvious answer, yet the kernel list is increasingly operating in
 the wrong mode and we (all) need to fix that.
)

> So such unclean drivers you mention above should probably go to 
> drivers/staging/ - that is an effort that tries to de-crappify 
> drivers before they get mixed into core drivers.

Staging is a big help as it provides an idiot evasion system, but most
people submitting initial patches and bits of code don't know about it.
 
> All in one, i dont see at all the harm from people looking at 
> stylistic issues first

Imagine if Shakespeare had first been reviewed from the point of view of
stylistic compliance with the recommended grammar, language and spelling
of his day.

I have one big driver in mind btw which I suspect will hit staging at some
point when released. It passes checkpatch perfectly. Its everything a
checkpatch weenie could dribble over. Its also absolutely godawful. It's
been recommended to go via staging for that reason.

We are going to get lots more wasted effort of that kind unless people
both in the community and outside it stop treating checkpatch as a rule
system, an arbiter of taste and the definition of what goes in tree.
Right now there are people out there writing contracts to "provide a
Linux driver that passes the checkpatch script", not that works or is
good upstream code.

Incidentally if there are people reading this who really enjoy all the
niggly little checkpatch hunting and twiddling its a great use of that
talent to pick off older in tree code and fix it to pass checkpatch. That
code is already in tree, and wants tidying.

Alan
