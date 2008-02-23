Return-Path: <linux-kernel-owner+w=401wt.eu-S1758715AbYBWPu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758715AbYBWPu7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 10:50:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbYBWPuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 10:50:52 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45029 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955AbYBWPuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 10:50:51 -0500
Date: Sat, 23 Feb 2008 16:50:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: John Levon <levon@movementarian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       sandmann@redhat.com, tglx@tglx.de, hpa@zytor.com
Subject: Re: [PATCH] x86: add the debugfs interface for the sysprof tool
Message-ID: <20080223155031.GA28365@elte.hu>
References: <20080219123756.6261c13c@laptopd505.fenrus.org> <20080223001130.d8922136.akpm@linux-foundation.org> <20080223113724.GB31304@elte.hu> <20080223135335.GA28464@totally.trollied.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080223135335.GA28464@totally.trollied.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* John Levon <levon@movementarian.org> wrote:

> >   [ The newbie user eventually finds out that opcontrol help text is
> >     buggy and that -s does not mean --start, but --setup. ]
> 
> It's astonishing that you would know about this, complaining about 
> this, but not file a bug report. Same goes for the rest.

i found out about this particular issue just today, when i wrote this 
mail, so consider this as my bugreport.

And i have to say, most of the usability deficits in oprofile are very 
obvious, so consider this as a general "the oprofile commands suck in 
almost every detail" bugreport. Tools should fundamentally be 
one-stop-shops. I personally wouldnt mind the lack of a GUI at all if 
the command line tool was _obvious to use_. If the principle was: get 
the current histogram to the user. A tool should work _hard_ to get 
something (_anything_) useful out by default. Transparently start up any 
background state and procesing that is needed - and hide it as much as 
possible. Try to figure out where the vmlinux is, if there's any. Do 
_not_ put the user through any extra chores if not absolutely necessary. 
Display information that tells the user what happened. Etc., etc. - 
these are all basic principles.

imagine if the "ls" command, instead of listing files, showed 60 lines 
of options, and when i picked "-l" it would, instead of listing files 
already, ask me: "do you really mean the current filesystem?". And if i 
said "list whatever filesystem i wanted" then it would also say "because 
dm-crypt is not configured into the kernel I cannot display encrypted 
information, use me with --no-crypt".

and as i sit here, i tried "opreport" once again, to just see what it 
does by default. It just hung there, displaying nothing. For minutes. 
Then i got suspicious and straced it. It loops in stat()s in one huge 
directory that has amassed more than 20 thousand sample files in the 
last few hours. This is such a basic usecase, tell me that this never 
happened to you and that nobody ever came to the idea to display "sorry, 
this might take a few minutes, 10% of the files are processed so far" 
sort of feel-good messages to the user?

but generally i cannot fix and report and fight over all the crap that 
people do - that would mean i'd have to complain about Linux all day, 
non-stop. What i can do is to tell apart the better solutions from the 
worse solutions when they get submitted to me. And guess what? One 
little isolated 200 lines patch in x86.git and the people who sat on 
their accomplishments for years are up in arms and oppose it. I must be 
doing something right i guess :-/

	Ingo
