Return-Path: <linux-kernel-owner+w=401wt.eu-S1756649AbYGJUZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649AbYGJUZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 16:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbYGJUZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 16:25:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56150 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbYGJUZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 16:25:18 -0400
Date: Thu, 10 Jul 2008 22:24:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Mike Travis <travis@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
Message-ID: <20080710202453.GA7534@elte.hu>
References: <4876194E.4080205@linux-foundation.org> <48761C06.3020003@zytor.com> <48762A3B.5050104@linux-foundation.org> <48762DD2.5090802@zytor.com> <487637A1.4080403@linux-foundation.org> <m1prpl4pmh.fsf@frodo.ebiederm.org> <48764C21.4020601@zytor.com> <m1fxqhzhcu.fsf@frodo.ebiederm.org> <4876608B.10408@sgi.com> <m1zloptrwt.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1zloptrwt.fsf@frodo.ebiederm.org>
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


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> Mike Travis <travis@sgi.com> writes:
> 
> 
> > The biggest growth came from moving all the xxx[NR_CPUS] arrays into 
> > the per cpu area.  So you free up a huge amount of unused memory 
> > when the NR_CPUS count starts getting into the ozone layer.  4k now, 
> > 16k real soon now, ??? future?
> 
> Hmm.  Do you know how big a role kernel_stat plays.
> 
> It is a per cpu structure that is sized via NR_IRQS.  NR_IRQS is by 
> NR_CPUS. So ultimately the amount of memory take up is 
> NR_CPUS*NR_CPUS*32 or so.
> 
> I have a patch I wrote long ago, that addresses that specific nasty 
> configuration by moving the per cpu irq counters into pointer 
> available from struct irq_desc.
> 
> The next step which I did not get to (but is interesting from a 
> scaling perspective) was to start dynamically allocating the irq 
> structures.

/me willing to test & babysit any test-patch in that area ...

this is a big problem and it's getting worse quadratically ;-)

	Ingo
