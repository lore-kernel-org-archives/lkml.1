Return-Path: <linux-kernel-owner+w=401wt.eu-S1161451AbXDXHbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161451AbXDXHbd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 03:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161411AbXDXHbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 03:31:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57902 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161451AbXDXHbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 03:31:32 -0400
Date: Tue, 24 Apr 2007 09:31:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rogan Dawes <lists@dawes.za.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Gene Heskett <gene.heskett@gmail.com>,
       Juliusz Chroboczek <jch@pps.jussieu.fr>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Peter Williams <pwil3058@bigpond.net.au>,
       ck list <ck@vds.kolivas.org>, Thomas Gleixner <tglx@linutronix.de>,
       William Lee Irwin III <wli@holomorphy.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bill Davidsen <davidsen@tmr.com>, Willy Tarreau <w@1wt.eu>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Message-ID: <20070424073103.GA29054@elte.hu>
References: <20070421160008.GA28783@elte.hu> <200704220959.34978.kernel@kolivas.org> <87647oblx5.fsf@pps.jussieu.fr> <alpine.LFD.0.98.0704221620310.9964@woody.linux-foundation.org> <20070423013429.GB25162@wotan.suse.de> <alpine.LFD.0.98.0704230844410.9964@woody.linux-foundation.org> <20070423191143.GA16849@elte.hu> <alpine.LFD.0.98.0704231227300.9964@woody.linux-foundation.org> <20070423203317.GA26668@elte.hu> <462DAC06.9040309@dawes.za.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <462DAC06.9040309@dawes.za.net>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Rogan Dawes <lists@dawes.za.net> wrote:

> >        if (p_to && p->wait_runtime > 0) {
> >                p->wait_runtime >>= 1;
> >                p_to->wait_runtime += p->wait_runtime;
> >        }
> >
> >the above is the basic expression of: "charge a positive bank balance". 
> >
> 
> [..]
> 
> > [note, due to the nanoseconds unit there's no rounding loss to worry 
> > about.]
> 
> Surely if you divide 5 nanoseconds by 2, you'll get a rounding loss?

yes. But not that we'll only truly have to worry about that when we'll 
have context-switching performance in that range - currently it's at 
least 2-3 orders of magnitude above that. Microseconds seemed to me to 
be too coarse already, that's why i picked nanoseconds and 64-bit 
arithmetics for CFS.

	Ingo
