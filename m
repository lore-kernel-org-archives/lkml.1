Return-Path: <linux-kernel-owner+w=401wt.eu-S1756202AbYBXNp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbYBXNp0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 08:45:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751317AbYBXNpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 08:45:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46219 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753144AbYBXNpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 08:45:10 -0500
Date: Sun, 24 Feb 2008 14:44:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Theodore Tso <tytso@mit.edu>, John Levon <levon@movementarian.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       sandmann@redhat.com, tglx@tglx.de, hpa@zytor.com
Subject: Re: [PATCH] x86: add the debugfs interface for the sysprof tool
Message-ID: <20080224134421.GA31845@elte.hu>
References: <20080219123756.6261c13c@laptopd505.fenrus.org> <20080223001130.d8922136.akpm@linux-foundation.org> <20080223113724.GB31304@elte.hu> <20080223135335.GA28464@totally.trollied.org.uk> <20080224131001.GA7150@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080224131001.GA7150@mit.edu>
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


* Theodore Tso <tytso@MIT.EDU> wrote:

> The abdication of responsibility and the lack of trying to solve the 
> usability issues is one of the things that really worries me about 
> *all* of Linux's RAS tools.  We can and should do better!  And it's 
> really embarassing that the RAS maintainers seem (I assume you are one 
> of the oprofile maintainers), seem to be blaming this on the victims, 
> the people who are complaining about using *your* tool.  Yes, it's a 
> shame that Ingo didn't try to fix your tool; open source, and scratch 
> your own itch and all of that.  To be sure.  But at the *same* *time* 
> don't you have enough pride to take a look at a tools which so 
> obviously has massive lacks in the usability department, and tried to 
> fix it years ago?  There's more than enough blame to go around twenty 
> times over, I would think.

i agree with most of your mail but i beg to differ with what you wrote 
about my role :-/ The specific bug/issue i discovered with oprofile i 
discovered on the very day i wrote about it to lkml.

In any case i'm not the one to fix oprofile - i cannot fix or report all 
itches that i have in ~1 billion lines of userspace - i would have to 
spend my whole life complaining ;-)

I'm the one to make sure that patches for useful userspace tools that 
get submitted to me eventually go upstream, one way or another. Sysprof 
has been around for years, had to rely on a (trivial) external module 
and AFAIK the feature even predates oprofile's stack-trace support. The 
API is butt-ugly and it's being fixed. So if then it should have been 
the oprofile folks porting over sysprof to their new API ... claiming 
otherwise would rewrite history i think.

a quick glance at oprofile's stack-trace/callgraph support shows it 
being rather buggy: it uses __copy_from_user_inatomic() from NMI 
context, which is bad because that can fault and re-enable NMIs, causing 
stack recursion/corruption. Fixing it is nontrivial. I'm not sure how 
much this feature has been tested - but with a sucky userspace kernel 
features _do not get tested_ - it's as simple as that! I'd be happier 
with sysprof's pure and simple "we only care about time events" initial 
approach and evolve this field via actual interest from users.

	Ingo
