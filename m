Return-Path: <linux-kernel-owner+w=401wt.eu-S1755513AbYHMJQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbYHMJQI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 05:16:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752560AbYHMJPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 05:15:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58633 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505AbYHMJPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 05:15:55 -0400
Date: Wed, 13 Aug 2008 11:15:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frans Meulenbroeks <fransmeulenbroeks@gmail.com>
Cc: Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch]fastboot: remove duplicate unpack_to_rootfs()
Message-ID: <20080813091536.GI23417@elte.hu>
References: <1218607669.3463.9.camel@sli10-desk.sh.intel.com> <20080813074503.GB398@elte.hu> <20080813075236.GA8052@elte.hu> <ac9c93b10808130111ua3d4630v63f7d3754d2ca12e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac9c93b10808130111ua3d4630v63f7d3754d2ca12e@mail.gmail.com>
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


* Frans Meulenbroeks <fransmeulenbroeks@gmail.com> wrote:

> 2008/8/13, Ingo Molnar <mingo@elte.hu>:
> >
> >  * Ingo Molnar <mingo@elte.hu> wrote:
> >
> >  > the dry_run variable is now unused in unpack_to_rootfs() and could be
> >  > eliminated.
> >
> >  also, while we are materially touching init/initramfs.c, that file has
> >  collected a few uglies in the past few years, checkpatch --file says:
> >
> >   total: 7 errors, 7 warnings, 3 checks, 562 lines checked
> >
> >  it has a few other problems as well that can be seen if you look at the
> >  file. Unused macros:
> >
> >   /* Diagnostic functions (stubbed out) */
> >   #define Assert(cond,msg)
> >   #define Trace(x)
> >   #define Tracev(x)
> >   #define Tracevv(x)
> >   #define Tracec(c,x)
> >   #define Tracecv(c,x)
> >
> >   #define STATIC static
> >   #define INIT __init
> >
> These are not really unused. A few lines later it reads:
> 
> #include "../src/inflate.c"
> 
> These macros are used within inflate.c

oh, i _knew_ i saw this zlib ugliness sometime in the past.

> (and perhaps the inclusion of inflate.c is not a good idea, maybe this 
> should be in lib.a note that inflate.c is also included in 
> init/do_mounts_rd.c; fortunately this is all init code (which is 
> probably why include was used in the first place))

definitely. It's a different patch though.

	Ingo
