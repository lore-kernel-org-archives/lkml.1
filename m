Return-Path: <linux-kernel-owner+w=401wt.eu-S1161529AbXD2XAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161529AbXD2XAt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 19:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161523AbXD2XAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 19:00:49 -0400
Received: from mail.gmx.net ([213.165.64.20]:53197 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1161529AbXD2XAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 19:00:39 -0400
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       mchehab@infradead.org, mkruky@linuxtv.org, linux-dvb@linuxtv.org
Content-Type: text/plain; charset="us-ascii"
Date: Mon, 30 Apr 2007 01:00:37 +0200
From: "Uwe Bugla" <uwe.bugla@gmx.de>
In-Reply-To: <alpine.LFD.0.98.0704291412500.9964@woody.linux-foundation.org>
Message-ID: <20070429230037.95120@gmx.net>
MIME-Version: 1.0
References: <20070429182209.267430@gmx.net>
 <alpine.LFD.0.98.0704291147530.9964@woody.linux-foundation.org>
 <20070429205925.129920@gmx.net>
 <alpine.LFD.0.98.0704291412500.9964@woody.linux-foundation.org>
Subject: Re: Critical points about kernel 2.6.21 and pseudo-authorities
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Authenticated: #8359428
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX194ZFV7OLx4MGwTxudPvHOufpwOsenUvP0/GldRQQ
 +uTPSMBXEvRQYXhhs7M1m5BWJQEWlIF4eRrw== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: 2lZUIkFEa0A7QWXhCjEzFEU/Njh6dA63
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-------- Original-Nachricht --------
Datum: Sun, 29 Apr 2007 14:19:22 -0700 (PDT)
Von: Linus Torvalds <torvalds@linux-foundation.org>
An: Uwe Bugla <uwe.bugla@gmx.de>
CC: linux-dvb@linuxtv.org, mkruky@linuxtv.org, mchehab@infradead.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Betreff: Re: Critical points about kernel 2.6.21 and pseudo-authorities

> 
> 
> On Sun, 29 Apr 2007, Uwe Bugla wrote:
> > 
> > I have been trying diff and other tools in various variants (except 
> > git-bisect that I cannot handle because I do not understand the practice
> > of it).
> 
> git bisect is _really_ simple if you already have a git tree anyway. And 
> even if you don't, getting one isn't really hard either. Just do
> 
> 	git clone
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git linux-2.6
> 
> and you have a tree (it will take a little while - it's going to dowload 
> about 170MB or so of stuff, so the initial clone is going to be a bit 
> painful unless you have a fast internet connection).
> 
> Once you have the git tree, assuming that 2.6.21-rc7 worked for you, it's 
> really as easy as just saying
> 
> 	git bisect start
> 	git bisect good v2.6.21-rc7
> 	git bisect bad v2.6.21
> 
> and git will think for a short while (most of the time is going to be 
> checking out the new tree) and give you a tree to test.
> 
> Just build, boot, and test that tree.
> 
> If it was fine, do
> 
> 	git bisect good
> 
> and git will pick a new tree to test. And if it wasn't, instead just do 
> "git bisect bad", and git will pick _another_ version to test. Do this a 
> few times, and git will tell you which commit introduced them.
> 
> There were just 125 commits in between 2.6.21-rc7 and the final one, so it
> should be quite quick - bisection basically does a binary search, so doing
> seven reboots should have you with the result.
> 
> The fact that it already works in 2.6.21-git2 obviously means that _I_ end
> up being less interested, but the -stable tree people would love to hear 
> what broke!

Hi again Linus,
my deep thanks for your excellent explication of git-bisect.
But I unfortunately owe a 100Kbit flatrate, and so downloading some 170 MB git tree will need the time amount of one entire night (11.5 kb /s if I am lucky - no more).
Just to take up a different approach:

The difference between 2.6.21-rc7 and 2.6.21 official does not play any role at all.

On the other hand I found out that:
2.6.21-rc7 made my AMD K7 router work fine
2.6.21 official hung my AMD K7 router up
2.6.21-git1 hung my AMD K7 router up
2.6.21-git2 made my AMD K7 router work.

In so far the diff between 2.6.21-git1 and 2.6.21-git2 obviously solves the problem.
Or am I saying something wrong as far as logical terms are concerned?

> 
> > I like small and effective kernels instead of blown up RAM waste.
> > This is no Windoze, man, this is Linux!
> 
> Yes. But if you cannot be polite and *RESPECTFUL*, you won't get anywhere 
> at all.
> 
> This is Linux, not Windows. But that also means that those developers that
> you denigrate aren't getting paid by you, and if you don't show them 
> respect, they'll totally ignore you.
> 
> 		Linus

Now this is the old problem about it all: the hypocricy factor, the utmost small, if not to say pre-pubertarian character plus some other obviously counter-productive character traits in those so-called "maintainers" who behave like kids, but not like grown-ups at all!
Not only you, but also Andrew perfectly and willingly step into the hypocritic trap and do not even feel that they are trapped!

For the majority of all cases of the so-called "maintainer personnel" at linuxtv.org the statement of some missing "politeness" or some missing "respect" is nothing but an utmost dumb, kiddish, human mediocre and utmost stupid and utmost hypocritic excuse for bare naked incompatibility, dumbness, wrong solidarity, kiddishness and technical incompetence.

They are building up pseudo-authorities to hide their lack of competence, no matter if their lack of competence funds on technical or human lacks.
And at least the Brazilian Mauro Carvalho Chehab does go even so far to soap in Andrew Morton's face with this enourmous threat of incompetence, kiddishness, incompatibility, hypocricy, lies, stigmatisations, stubbornness, lack of experience, pre-pubertarian behaviour, fascistoid opinion dictatorship as part of a deep immature anti-democratic and reactionary personality structure.

Would you call Mauro Carvalho Chehab a maintainer!
I can certify you that I cannot, even if I try. And I want him to be substituted as quick as possible as he is the biggest mismatch of gatekeeper one can ever imagine.

And it is not only me personally perceiving this that there are people missing who can go upright and offer sophisticated and good work.
Plus a real sophisticated discussion behaviour, in technical and in human terms.
Going upright is thus far away from the behaviour NOT to be able to tolerate any criticism at all.

Solution: This whole new quite young linuxtv.org team is missing a real grown up and experienced team leader. Not only that is definitely too much for Mauro Carvalho Chehab. That is the pain - the consistence of the whole group is the pain, that's all. Too young, too many lacks of human skills, and missing an appropriate team leader.............

So, if I show respect or not, or if I show politeness or not will never change the whole structural situation at all, as great parts of the whole team is a disease:
1. By Chehab being the team leader the whole fish stinks from the head startup.
Solution: Substitution of Mauro Carvalho Chehab as quick as possible - even quicker than a storm!
2. By Krufky being one part of it, doing good work, but executing wrong solidarities by his bowing behaviour towards pseudo-authorities although he knows better at least technically this is a question of wrong or right leadership, nothing else
3. By Abraham offering us great ranting aims that never are being put into practice out of certified missing human skills and missing technical knowledge (the four completely unusable 2.6 kernels were never apologized by himself) urgent substitution  is utmost necessary.

CLEARER: If anyone of the people knowing the deeper context claims those "gatekeeper methods" to be a consequence of missing "respect" or missing "politeness" then those people are either strictly dumb and superficial, or they owe a gesture that I would call a "Well, I know, but I do not want to see what's going on"-disease, nothing else.

Another term to describe the latter would be "bureaucratic lamb head behaviour".

See, Linus, if for instance Andrew Morton mails me some statement from that Chehab going: "Again, do not take the patches from Uwe - he is always regarding things through his personal prisma, and the rest he simply does not perceive at all"

then this is nothing but a gesture full of lies (somehow typical for this Brazilian fascistoid opinion block head dictator), but it simply shows that the linuxtv.org teamleader is a horrible mismatch, nothing else!

His mediocrity and dumbness simply defines through the fact that he is using stigmatizations very soon in a so-called "discussion" because he misses
a. human skills
b. technical proven arguments and theses 
c. enough experience, human or technical one.

And the biggest threat and shame is the proven fact that Andrew Morton does obey to such a stupid reactionary idiot and let his face soap in by this dirty Brazilian hypocrite instead of giving contributions at least a chance through his mm-tree.

So there are exactly two solutions:
1. Andrew Morton should not obey to Chehab anymore and be real open
2. Chehab and Abraham should be substituted as quick as possible without any hesitation in no way!!!!

The one that got to be fired with the most urgent priority is called Mauro Carvalho Chehab. This is no maintainer, this is no gatekeeper, but this is nothing but a real personified ape or disease.

And the argument whether those people are paid for their work or not is exactly as important as if a sack of rice falls down somewhere in capitalist China or not.....
OBSOLETE!!!

Yours sincerely
Uwe

-- 
"Feel free" - 10 GB Mailbox, 100 FreeSMS/Monat ...
Jetzt GMX TopMail testen: http://www.gmx.net/de/go/topmail
