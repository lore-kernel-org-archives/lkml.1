Return-Path: <linux-kernel-owner+w=401wt.eu-S1762977AbYD3MUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762977AbYD3MUG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 08:20:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757090AbYD3MTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 08:19:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59279 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755985AbYD3MTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 08:19:55 -0400
Date: Wed, 30 Apr 2008 14:18:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: David Miller <davem@davemloft.net>, tiwai@suse.de, mchehab@infradead.org,
       akpm@linux-foundation.org, linux-dvb-maintainer@linuxtv.org,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
       efault@gmx.de
Subject: Re: [patch, -git] media/video/sound build fix, TEA5761/TEA5767
Message-ID: <20080430121854.GC30735@elte.hu>
References: <20080430110115.GA5633@elte.hu> <s5hiqxzwqak.wl%tiwai@suse.de> <20080430.041703.89847530.davem@davemloft.net> <20080430112959.GA32556@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430112959.GA32556@uranus.ravnborg.org>
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> [OT to the actual problem]
> 
> I have envisioned something like a "requires tag" that would list what 
> a config symbols needs.
> 
> Like in this case it would have been:
> 
> 	requires V4L
> 
> This should in the frontends then if the user selects a symbol where 
> the 'requires' are not satisfied with a window listing the menuentries 
> for the symbol that the user needs to enable to satisfy what the 
> original symbol requires.
> 
> This is the only way to do this in a way so the user is actually aware 
> that enabling a webcam also enables USB. Or at least this is my best 
> suggestion.

but auto-selecting USB is the obvious thing that most users expect...

I.e. they expect a static hierarchy of 'every component' that exists and 
that can be selected. [yes there are complications like multiple-choice, 
but that's the minority]

Users want to browse the hierarchy and pick their things - and _at most_ 
the tool should warn if there's side side-effects of a selection - users 
will likely not mind that enabling a webcam also enables USB (in the 
overwhelming majority of the cases they couldnt care less about that).

But otherwise it should all be automatic.

And i dont even think there should be any additional Kconfig 
complication. Kconfig should be made _simpler_, not more complex. 
Maintainers list dependencies and that's it. No "select" needed at all! 
The stuff that needs to be selected automatically derives from the 
"depends on" tree that we code.

in fact even dependencies between modules of source code should be 
auto-discovered most of the time.

The symbol dependency tree from an allyesconfig kernel could give a 99% 
accurate map of all the dependencies that exist in the code. Why burden 
humans with that? We've got better things to do than to figure out 
dependencies between source code as the dependencies can be totally 
non-obvious.

Humans might want to _optimize_ the dependencies after the fact and get 
rid of unnecessary dependencies (so that the kernel gets smaller, etc.), 
but there should be no correctness ramifications of it visible to 
developers or users.

So the whole thing is being thought about exactly upside down i believe.

	Ingo
