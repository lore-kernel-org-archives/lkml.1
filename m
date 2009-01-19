Return-Path: <linux-kernel-owner+w=401wt.eu-S1759168AbZASLQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759168AbZASLQg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 06:16:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756264AbZASLQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 06:16:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45792 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753713AbZASLQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 06:16:25 -0500
Date: Mon, 19 Jan 2009 12:15:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL -tip v3] fix 39 'make headers_check' warnings
Message-ID: <20090119111552.GA18996@elte.hu>
References: <1232287474.3130.19.camel@localhost.localdomain> <20090118172800.GB22624@elte.hu> <20090118185034.GA26908@elte.hu> <1232331011.3129.4.camel@localhost.localdomain> <1232331646.5570.5.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232331646.5570.5.camel@brick>
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


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> On Mon, 2009-01-19 at 07:40 +0530, Jaswinder Singh Rajput wrote:
> > On Sun, 2009-01-18 at 19:50 +0100, Ingo Molnar wrote:
> > >  
> > > why does such a change introduce new code? It is duplicating existing code 
> > > instead of cleaning it all up.
> > > 
> > 
> > That's why I was requesting you to check asm/swab.h because I was in 
> > doubt whether we need these functions in userspace or not.
> > 
> > If we do not need these functions in userspace then I will clean these 
> > up.
> > 
> 
> As part of doing the swab.h splitout it was very tempting to just stop 
> exporting _all_ of the asm/swab.h files now that there is a 
> linux/swab.h. But I ended up leaving things as they were on arches that 
> did expose their arch specific versions to userspace.

i'd argue for a much narrower interface to user-space - we export so much 
stuff (more than 700 headers) and in such an unstructured way (75,000 
lines of code) that it's plain crazy.

So if you think no x86 userspace actually needs swab.h, we can just wrap 
it all in __KERNEL__. I guess we cannot remove swab.h from 
include/linux/Kbuild, right?

	Ingo
