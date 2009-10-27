Return-Path: <linux-kernel-owner+w=401wt.eu-S1755668AbZJ0PjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668AbZJ0PjR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 11:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755582AbZJ0PjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 11:39:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:60077 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755543AbZJ0PjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 11:39:16 -0400
Subject: Re: [RFC] to rebase or not to rebase on linux-next
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Nicolas Pitre <nico@fluxnic.net>, "Luck, Tony" <tony.luck@intel.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Robert Richter <robert.richter@amd.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Jean Delvare <khali@linux-fr.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20091027075954.GA32640@elte.hu>
References: <4AE19A74.1090709@garzik.org> <20091023123555.GA25366@elte.hu>
	 <57C9024A16AD2D4C97DC78E552063EA3E33D0174@orsmsx505.amr.corp.intel.com>
	 <20091023134115.GD27097@elte.hu>
	 <alpine.LFD.2.00.0910231424440.21460@xanadu.home>
	 <20091023191631.GA1879@elte.hu>
	 <1256326512.26028.34.camel@gandalf.stny.rr.com>
	 <20091023205400.GA8356@elte.hu> <20091023215958.GA4139@merkur.ravnborg.org>
	 <1256599588.26028.340.camel@gandalf.stny.rr.com>
	 <20091027075954.GA32640@elte.hu>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 27 Oct 2009 11:39:16 -0400
Message-Id: <1256657956.26028.408.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-27 at 08:59 +0100, Ingo Molnar wrote:

> For any reasonably complex change you simply need to wait a bit anyway 
> to gather feedback. And for trivial/obvious/small patches it makes 
> little sense to upset the Git history just to add the tags.
> 
> (And if there's frequent problems with small changes that were supposed 
> to be easy you need to revisit the quality process.)

Sure, but I'm not talking about changing the patch, I'm talking about a
late "reviewed by" or "tested-by". These usually do come after a patch
set has been moved into the final git push. It would be nice to flag a
commit that it was tested by someone.

If we have to change the commit to add tested-by, then it changes the
SHA1, and if you're going to change the commit, you may be tempted to
make a small fix somewhere too. And that small fix might have an
unexpected result and nullifies the "tested-by".

Sure you can say, "don't do that" but its human nature. Someone will,
and when this patch is proven to break something, it will be
embarrassing to the tester who put their name on it.

> 
> So no, the rewinding of published for-pull git trees are not fine in 
> Linux. It's OK to post a declaredly RFC git tree with some 
> to-be-reworked patches in it - but it's not OK to publish a git tree for 
> pull and rebase it after that. You'll certainly see me complain if you 
> do that (and Linus will complain to me if i do that).

I agree with this to. And for complex changes, I usually do a RFC post
first.  But after comments and we get a good commit going, then I
sometimes get "tested-by" after the final version has been posted.
Because they tested that version.

My suggestion is to add an "annotation" commit that can tag another
commit with something like a "tested-by". This way a tester can say,
they tested this particular commit, and if someone changes it, the SHA1
will no longer match. And then we can also have a record of what commit
was tested by who, after the fact that it went into git.

A tester could have a git tree that you could pull from that only adds
annotations of what they tested. This would add to git a history of what
changes were tested by who.

Just my $0.02.

-- Steve


