Return-Path: <linux-kernel-owner+w=401wt.eu-S1757308AbXJ2Ulv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308AbXJ2Ulv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 16:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752845AbXJ2Uln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 16:41:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44168 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826AbXJ2Ulm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 16:41:42 -0400
Date: Mon, 29 Oct 2007 21:41:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, Frans Pop <elendil@planet.nl>,
       Chuck Ebbert <cebbert@redhat.com>, Greg KH <greg@kroah.com>,
       stable@kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [stable] 2.6.23 regression: top displaying 9999% CPU usage
Message-ID: <20071029204116.GA13026@elte.hu>
References: <200710122231.50739.elendil@planet.nl> <4725D2A5.1050908@linux.vnet.ibm.com> <20071029200425.GA830@elte.hu> <200710292133.48125.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710292133.48125.borntraeger@de.ibm.com>
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


* Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> > -	return clock_t_to_cputime(utime);
> > +	p->prev_utime = max(p->prev_utime, clock_t_to_cputime(utime));
> > +	return p->prev_utime;
> >  }
> [...]
> 
> I dont think it will work. It will make utime monotic, but stime can 
> still decrease. For example let sum_exec_runtime increase by a tiny 
> little bit while utime will get a full additional tick. stime is 
> sum-utime. So stime can still go backwards. So I think that we need 
> this kind of logic for stime as well, no?

yeah, probably. Peter?

	Ingo
