Return-Path: <linux-kernel-owner+w=401wt.eu-S1757772AbZDPBrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757772AbZDPBrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 21:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753384AbZDPBr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 21:47:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35499 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752888AbZDPBr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 21:47:26 -0400
Date: Thu, 16 Apr 2009 03:46:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, hpa@zytor.com, tglx@linutronix.de,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, davej@redhat.com
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
Message-ID: <20090416014642.GA24029@elte.hu>
References: <alpine.LFD.2.00.0904151013260.4132@localhost.localdomain> <49E62BD5.6090508@zytor.com> <alpine.LFD.2.00.0904151241490.4132@localhost.localdomain> <20090415.142326.97287514.davem@davemloft.net> <20090415224800.GA22425@elte.hu> <alpine.LFD.2.00.0904151608470.4042@localhost.localdomain> <20090416004430.GA22616@elte.hu> <alpine.LFD.2.00.0904151757100.4042@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904151757100.4042@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > You just dont seem to understand why i find it useful. You also 
> > seem to try to deprive us the basic right of creating new, 
> > field-specific language variants we find useful in our everyday 
> > work. And that sucks.
> 
> YOU HAVE NEVER GIVEN A COHERENT REASON FOR FINDING IT USEFUL!
> 
> Yes, you bring up the same reason every time: namely that you want 
> to know what the patch does. But never _once_ have you given a 
> reason fo why that fixed-format string helps at all.

For similar reasons people have memos, stick-it's and other formal, 
automated, reflex-alike daily routine measures to make sure they 
dont forget to do something they all too easily forget otherwise.

If i apply a patch i always notice the ones without an impact line 
(it's missing from the visual appearance of a commit - just like it 
is _looking ugly_ to you - just inverted), and i dont apply one 
without either:

  1) convincing myself it does not need one
  2) or adding one

It also sticks out like a sore thumb if it's incorrect. For example 
"Impact: fix" is a bad one at a glance.

This kind of formal measure _forces_ the extraction of this very 
specific type of summary on all sides of the contribution chain - 
and it drastically reduced the number of commits i regretted in 
hindsight.

It also speeds up patch processing because seeing an impact line i 
only have to scan for code patterns contradicting that claim - 
instead of doing general scanning figuring out the type of the patch 
- then doing a second pass figuring out whether it truly matches 
that expectation. I can also prioritize and order incoming patches 
much easier if i have a rough expected impact analysis. If a list of 
patches claims to be complex i'll put it in the appropriate section 
of the day.

The number of contributors who can write meaningful changelogs or 
who can be taught to write really good changelogs is very, very low. 
I'd guesstimate somewhere around 5% of all Linux contributors. (The 
guesstimation is probably on the more generous side.)

The central problem, as i see it, is about having people with two 
rare skills:

 - good coding abilities
 - good documentation/expression abilities

Both skills are unlikely to begin with - and it is two unlikely 
factors combined, and to find a person with both skills at once is 
unlikely square two.

In fact they are even less likely to combine in the same person, for 
the following reason: both capabilities reside in the left half of 
the brain, and an over-developed skill in one activity such as 
programming supresses other activities like linguistic abilities.

It happened not once and not twice to me in the past that after a 
night spent coding i was unable to properly order a burger or some 
other meal. I was still seeing code everywere and was thinking in 
code literally - language and talking was far away.

Yes, people combining both skills still exist, and they are often 
maintainers. In fact maintainers dont spent a lot of time _writing_ 
code, so their linguistic abilities tend to be very good. It is not 
that they are not good coders - they still are - but they dont do 
extreme amounts of programming that supresses linguistic skills.

So basically your argument, as i see it, boils down to the following 
end result in practice: that maintainers should write all or most of 
the changelogs. We simplified that down to: 'maintainers write a 
single line impact summary - and try to keep the rest of the commit 
as tidy as possible'. Anything more involved than that just doesnt 
scale.

Show me one person _you_ actually taught to write good changelogs - 
just one person who was not a natural born talker to begin with. 
I'll show you a 100 other people who cannot write good commit logs. 
They'll try and will limp along, but generally they cannot.

They might not even have English as their mother tongue - but still 
can read and understand C fantastically.

I really dont know what the good solution and the good balance here 
is, i only see a lot of conflicting requirements which look 
impossible to meet.

	Ingo
