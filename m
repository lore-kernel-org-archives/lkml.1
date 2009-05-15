Return-Path: <linux-kernel-owner+w=401wt.eu-S1757121AbZEOX1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121AbZEOX1V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 19:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754687AbZEOX1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 19:27:12 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:36510
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214AbZEOX1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 19:27:11 -0400
X-Greylist: delayed 423 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 May 2009 19:27:11 EDT
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Florian Mickler <florian@mickler.org>
Subject: Re: http://www.kernel.org/doc/local/git-quick.html#bisect
Date: Fri, 15 May 2009 18:20:04 -0500
User-Agent: KMail/1.9.10
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20090515121829.60de2210@schatten>
In-Reply-To: <20090515121829.60de2210@schatten>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905151820.05246.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 May 2009 05:18:29 Florian Mickler wrote:
> Hi Rob!
>
> I'm writing to this emailadress, because I went down from $subject to
> doc/local to doc/  and yours was the first email-adress I found.
>
> Who is maintaining $subject? I found it via google searching for git
> bisect.

Um, me?

I wrote it way back when, because I had to learn how to use git enough to do a 
bisect and it wasn't properly documented then.  (At least three other people 
have written up their own bisect howtos on it since then.)

People poke me about it from time to time, but mostly I personally use 
mercurial.

> [ rest of mail is only relevant for git-quick.html maintainer: ]
>
> The git-bisect description is really _wrong_. ( There should be a 
> stronger word for that... like ''badwrong'' or smth).

The sky is falling, the sky is falling!

> You _never_ _never_ guess "git bisect
> good" or "git bisect bad".

Yes I do, and it works just fine.

> Instead you should use
> git bisect skip or
> git bisect visualize and choose another commit to test.

I believe that both of those options were implemented _after_ I wrote the 
above document.  (People keep telling me that the user interface of git can't 
be said to "suck" because it keeps changing.)

> If you guess wrong, your bisection result is not valid anymore.

Which is why it tells you how to back up to where you guessed so you can try 
it the other way when you guess wrong.  (Did you stop reading when you 
encountered the first thing you disagreed with?)  Lemme cut and paste the 
appropriate chunk:

  If you guess wrong (hint: every revision bisect wants
  to test after that comes out the opposite of your guess, all the way to the
  end) do a <b>git bisect replay ../bisect.log</b> to restart from your
  saved position, and guess the other way.

The ability to do that sort of thing would presumably be why they implemented 
the replay option in the first place.

> (and that really sucks, because all your compiliations after that one
> are _worthless_ ).

No, they demonstrate that the bug isn't in that fork, at which point you back 
up and check the other fork.

These days they've added stuff to do it in a slightly more automated fashion, 
but I note that I was bisecting in mercurial before it had any bisect 
support, just using the sequence numbers and a basic understanding of how 
branches and merges work on a nonlinear repository.  I wrote a doc for people 
who might conceivably want to understand how the process actually _works_...

> But if you defer the decision for that commit (via git-skip) you at
> least get a range of commits including the bad
> commit, or if the commit immidiatly before the bad commit is
> buildable, you even get the right bad commit.
>
> i'm quoting the text that neeeds to be _removed_:

I'm going to give you the benefit of the doubt and assume that "neeeds" isn't 
a typo rather than a "badwrong" _word_ indicating how _falling_ 
the -=>*[(SKY)]*<=- is today.

Last time somebody poked me about this I added this bit:

  Note: you can also tell git itself to skip a commit you can't test with
  git bisect skip.  Unfortunately, the git-bisect man page gives this
  warning about the "skip" command:

    But computing the commit to test may be slower afterwards and git may
    eventually not be able to tell the first bad among a bad and one or more
    "skip"ped commits.

Which is what the Ubuntu 8.04 (still the LTS release, until october anyway) 
man page for git-bisect says.  I.E. the automation can't actually guarantee 
it will find the problem, and this describes a manual way so you can 
understand what it's actually doing.

Let me know when they sky _finishes_ falling for you, and then if you'd like 
to send a slightly less hysterical message I might take a closer look at what 
git's doing this week and see if it's actually changed since the last time I 
was paying attention.  (Keep in mind that since my laptop's still running 
Ubuntu LTS, because 8.10's wireless support spontaneously ate itself so badly 
I had to reinstall, and 9.04 doesn't like Intel 3D chipsets.  So I'll have to 
build git from source to see how the "current" versions differ from that...)

But you have yet to convince me anything's actually wrong...

Rob
-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds
