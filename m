Return-Path: <linux-kernel-owner+w=401wt.eu-S1754409AbXJ3HiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409AbXJ3HiR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 03:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752797AbXJ3HiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 03:38:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45423 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771AbXJ3HiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 03:38:03 -0400
Date: Tue, 30 Oct 2007 08:37:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, --cc@redhat.com,
       avi@quramnet.com, kvm-devel@lists.sourceforge.net,
       John Stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH] raise tsc clocksource rating
Message-ID: <20071030073736.GA21843@elte.hu>
References: <11936994092607-git-send-email-gcosta@redhat.com> <alpine.LFD.0.9999.0710292315280.3186@localhost.localdomain> <200710301339.23628.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710301339.23628.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> No.  tsc is very good, it's not perfect.  If a paravirt clock 
> registers 400 it really means "pick me over the tsc".

often the TSC is not perfect, but _IF_ it's perfect, using the paravirt 
driver is a pessimisation in performance.

the main problem at the moment is that there's no mechanism at the 
moment to convey to the guest the information that the TSC is "perfect", 
and to convey the calibration values.

> That's *why* they use > 400: it's in the documentation.

static values do not capture conditional quality like that of the TSC.

and just in case it's not obvious: i am not arguing for the inclusion of 
the patch, i'm just pointing out the plain fact that in the case where 
the TSC _is_ reliable, 5 different clocksource drivers for has obvious 
disadvantages. Anyone arguing against that simple point needs his head 
examined :) Once we can pass around calibration information from the 
host to the guest (which we dont do at the moment) there will be reason 
not to use the native clocksource driver in the guest.

in the long run, the paravirt clocksource drivers must become _fallback_ 
drivers, for the case when the TSC is not perfect. Instead of the 
current "lets try to make it reliable but also nearly as fast as the 
TSC", which leads to inevitable breakage on SMP.

	Ingo
