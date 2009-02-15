Return-Path: <linux-kernel-owner+w=401wt.eu-S1753412AbZBOIK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412AbZBOIK3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 03:10:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbZBOIKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 03:10:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54256 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365AbZBOIKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 03:10:20 -0500
Date: Sun, 15 Feb 2009 09:09:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Steven Rostedt <srostedt@redhat.com>, Paul Mackerras <paulus@samba.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: [PATCH 1/3] Makefile: Include arch Makefiles as late as
	possible
Message-ID: <20090215080946.GB24508@elte.hu>
References: <20090204150755.GA24163@oksana.dev.rtsoft.ru> <20090204150835.GA30027@oksana.dev.rtsoft.ru> <20090204212612.GN22608@elte.hu> <20090214195702.GB1241@uranus.ravnborg.org> <20090214220326.GA5200@elte.hu> <1234657196.26036.86.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234657196.26036.86.camel@pasglop>
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


* Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Sat, 2009-02-14 at 23:03 +0100, Ingo Molnar wrote:
> > 
> > So the question is: even with FRAME_POINTERS disabled on PPC, is 
> > __builtin_return_address(1)/(2) reliable, and is save_stack_trace() fast? (i.e.
> > can it walk down the stack frame efficiently, or does it have to scan the full
> > kernel stack) I.e. does PPC have all the material advantages of frame pointers?
> 
> Yes, we do. We effectively have frame pointers in fact, they may only be
> omitted in leaf functions but then gcc __builtin_return_address() knows
> how to handle that afaik.

So basically we want to define FRAME_POINTERS on PPC, but do not want
the -fno-omit-frame-pointers flag.

Originally (many moons ago) FRAME_POINTER _was_ just the toplevel Makefile
detail, but these days we've got a handful of secondary uses as well,
expressing the reliability of backtraces in essence.

We could split the whole option (affecting lots of files), or we could zap
that compiler flag in the PPC case - it is only PPC that worries about this
anyway.

	Ingo
