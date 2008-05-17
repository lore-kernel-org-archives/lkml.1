Return-Path: <linux-kernel-owner+w=401wt.eu-S1759863AbYEQUid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759863AbYEQUid (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 16:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758574AbYEQUi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 16:38:26 -0400
Received: from www.tglx.de ([62.245.132.106]:35074 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758373AbYEQUiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 16:38:25 -0400
Date: Sat, 17 May 2008 22:37:16 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Theodore Tso <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [GIT pull] x86 fixes for 2.6.26
In-Reply-To: <alpine.LFD.1.10.0805170944000.3020@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0805172022180.14337@apollo.tec.linutronix.de>
References: <alpine.LFD.1.10.0805170037180.3255@apollo.tec.linutronix.de> <alpine.LFD.1.10.0805161544080.3020@woody.linux-foundation.org> <20080517015705.GA20375@mit.edu> <alpine.LFD.1.10.0805161933240.3020@woody.linux-foundation.org> <20080517145802.GB6978@mit.edu>
 <alpine.LFD.1.10.0805170944000.3020@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

On Sat, 17 May 2008, Linus Torvalds wrote:
> and in that sense they look very much non-managerial. But those ~200 
> commits are still just two hundred out of 1900 commits total! We *need* 
> managers, not just grunts. And I can well imagine how stressful it is to 
> not just do the two hundred commits, but also try to orchestrate the other 
> ~1700 ones.

Hey, I can confirm that. :)

One of the main obstacles of going a more managerial way is that x86
is not yet in a shape which allows us to have real independent topic
branches. The other one is the way we worked for 5 years in
maintaining the preempt-rt patch and the related subprojects which
trickled slowly into mainline. The second obstacle is the one which is
easier to overcome.

The work which was started by the x86 merger is still in progress and
there is aside of the obvious "merge the two _32/_64 versions" a lot
of work necessary to distangle stuff which is intermingled across the
arch/x86 code base for historic reason.

The balancing act between cleaning up these problems and at the same
time not stalling further development completely is what causes quite
a lot of work and in consequence the headaches with our repository
management.

We are not yet at a point where we can rely on a probabilistic non
conflict of e.g. mcheck changes with boot process modifications.

We made pretty good progress to get there, but it would be naive to
say that we are ready for a pure topic related reliance on downstream
developers, which you can observe for example in networking. And
networking did not switch into this mode from one day to the other
either and has the luxory of a rather clean code base which makes it
easy to have clearly separated and (most of the time) independent
topic branches.

I really want to emphasise that the developers who were confronted by
us with the request to clean up stuff _before_ adding new features
were very cooperative and are responsible for the majority of the 1900
commits which we juggled into shape. If you have a close look at the
nature of the commits which were done by Ingo and me, you'll notice
that they are often just the fixup of the fallout of this patch
flood. Honestly, I did not imagine that the uptake of the new x86 tree
would be so huge.

We know that we need to adjust our workflow and trim it into the
lazy^Wmanagerial direction, but this needs some time to establish the
"independent" sub topics and find out those downstream developers who
are willing and capable to do their own topic. This is something which
does not happen overnight, but you are right that providing a stable
base to work on and an append-only forest of topic trees/branches is
definitely helpful.

Thanks,

	tglx
