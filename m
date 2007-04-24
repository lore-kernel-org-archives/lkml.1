Return-Path: <linux-kernel-owner+w=401wt.eu-S1423129AbXDXVb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423129AbXDXVb6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 17:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423128AbXDXVb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 17:31:58 -0400
Received: from holomorphy.com ([66.93.40.71]:45262 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423127AbXDXVb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 17:31:56 -0400
Date: Tue, 24 Apr 2007 14:27:17 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: "Li, Tong N" <tong.n.li@intel.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       Juliusz Chroboczek <jch@pps.jussieu.fr>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Bill Davidsen <davidsen@tmr.com>, Willy Tarreau <w@1wt.eu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Message-ID: <20070424212717.GR31925@holomorphy.com>
References: <462D37D2.3060208@goop.org> <5FD5754DDBA0B1499B5A0B4BB5419485F34BEB@fmsmsx411.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5FD5754DDBA0B1499B5A0B4BB5419485F34BEB@fmsmsx411.amr.corp.intel.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2007 at 05:59:06PM -0700, Li, Tong N wrote:
> I don't know if we've discussed this or not. Since both CFS and SD claim
> to be fair, I'd like to hear more opinions on the fairness aspect of
> these designs. In areas such as OS, networking, and real-time, fairness,
> and its more general form, proportional fairness, are well-defined
> terms. In fact, perfect fairness is not feasible since it requires all
> runnable threads to be running simultaneously and scheduled with
> infinitesimally small quanta (like a fluid system). So to evaluate if a
> new scheduling algorithm is fair, the common approach is to take the
> ideal fair algorithm (often referred to as Generalized Processor
> Scheduling or GPS) as a reference model and analyze if the new algorithm
> can achieve a constant error bound (different error metrics also exist).

Could you explain for the audience the technical definition of fairness
and what sorts of error metrics are commonly used? There seems to be
some disagreement, and you're neutral enough of an observer that your
statement would help.


On Mon, Apr 23, 2007 at 05:59:06PM -0700, Li, Tong N wrote:
> I understand that via experiments we can show a design is reasonably
> fair in the common case, but IMHO, to claim that a design is fair, there
> needs to be some kind of formal analysis on the fairness bound, and this
> bound should be proven to be constant. Even if the bound is not
> constant, at least this analysis can help us better understand and
> predict the degree of fairness that users would experience (e.g., would
> the system be less fair if the number of threads increases? What happens
> if a large number of threads dynamically join and leave the system?).

Carrying out this sort of analysis on various policies would help, but
I'd expect most of them to be difficult to analyze. cfs' current
->fair_key computation should be simple enough to analyze, at least
ignoring nice numbers, though I've done nothing rigorous in this area.


-- wli
