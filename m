Return-Path: <linux-kernel-owner+w=401wt.eu-S937243AbXHOWtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937243AbXHOWtc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 18:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937374AbXHOWsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 18:48:20 -0400
Received: from web52505.mail.re2.yahoo.com ([206.190.48.188]:22753 "HELO
	web52505.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S937375AbXHOWsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 18:48:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=ir9M2lZ1oPogIF55APTqMObvyXrFVgwr/mXmxiQcyuHpot7o46PDbKI2kqmBjVWJv9EHQeJVXTh+67aT2ALSACgsAI9ffP9GXEw0g5QsX7Qjmh6YcUwWQ5xVlqUAqS857wsskwPqX+BW7gaeum9I042FQQzHMvpaGjZgQ20fQ/0=;
X-YMail-OSG: x1_J6g0VM1mgGCNEXZ2x5go7cV2B_oNFzy.IHgPv9pVuwKuIFGEG_9kLs1c_yZHP.IUmg2UlLFwfzE_7yZczj9f085f4IIsa3kgpJKCbz9r27OkkIzVfh52DDGSr0nSlcZOM0KIjTFhhosI-
Date: Wed, 15 Aug 2007 15:48:15 -0700 (PDT)
From: Marc Perkel <mperkel@yahoo.com>
Subject: Re: Thinking outside the box on file systems
To: Valdis.Kletnieks@vt.edu
Cc: Phillip Susi <psusi@cfl.rr.com>, Kyle Moffett <mrmacman_g4@mac.com>,
       Michael Tharp <gxti@partiallystapled.com>, alan <alan@clueserver.org>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       valdis@turing-police.cc.vt.edu
In-Reply-To: <21905.1187212837@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <291255.29775.qm@web52505.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Valdis.Kletnieks@vt.edu wrote:

> On Wed, 15 Aug 2007 13:50:17 PDT, Marc Perkel said:
> > I don't see it as being any worse that what we
> have
> > now. To open a file you have to start at the
> bottom
> > and open each directory and evaluate the
> permissions
> > on the way to the file. In my system you have to
> look
> > up the permission of the string at each "/"
> separator.
> > Seems to me that every system would have these
> same
> > steps.
> 
> No - you need to look at the *whole* string - that's
> the
> whole *point* of your system, remember?
> 
> Just a few msgs back, you gave a nice example of
> having a file with \ in the name rather than /
> because
> it came from a Windows user. So you *do* need to
> check *every*
> pattern against the filename, because it *could*
> match.
> In a system with several hundred thousand or more
> patterns,
> that could be painful.
> 
> Also, you need to figure out how to deal with all
> the various
> silly corner cases that people will end up trying to
> do.
> 
> Consider the rules:
> 
> peter '*a*' can create
> peter '*b*' cannot create
> 
> Peter tries to create 'foo-ab-bar' - is he allowed
> to or not?
> 

First - I'm proposing a concept, not writing the
implementation of the concept. You are asking what
happens when someone write conflicting rules. That
depends on how you implement it. Conflicting rules can
cause unpredictable results.

It may be as simple as first rule wins. Or it may
require all the rules to be true. In the above example
I would say it is not allowed because it matches a
denial condition. 

The point is that one can choose any rule system they
want and the rules applies to the names of the files
and the permissions of the users.

> For an exersize, either write a program or do by
> hand:
> 
> Create a list of patterns that correctly express the
> ownership
> and permissions of *every* file on your current
> Linux box.
> 
> Then repeat on a large box with multiple users and a
> few Oracle
> databases or webservers.
> 
> Then write a small tool, that given that list, a
> username,
> a filename, and the operation (read, write, open,
> unlink, etc),
> says "Yes or No".
> 
> Then run 'strace /bin/ls' in a large directory, take
> all the
> filenames listed in the strace output, and see if
> your tool can
> answer "yes or no" fast enough to make 'ls'
> feasible.
> 
> Come back when you get that part done, and we'll
> discuss how it
> would have to work in the kernel.

All you would have to do is create a set of rules that
emulates the current rules and you would have the same
results.

> 


Marc Perkel
Junk Email Filter dot com
http://www.junkemailfilter.com


       
____________________________________________________________________________________
Boardwalk for $500? In 2007? Ha! Play Monopoly Here and Now (it's updated for today's economy) at Yahoo! Games.
http://get.games.yahoo.com/proddesc?gamekey=monopolyherenow  
