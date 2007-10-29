Return-Path: <linux-kernel-owner+w=401wt.eu-S1753393AbXJ2VML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393AbXJ2VML (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 17:12:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752082AbXJ2VL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 17:11:58 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40341 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbXJ2VL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 17:11:57 -0400
Subject: Re: [stable] 2.6.23 regression: top displaying 9999% CPU usage
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Frans Pop <elendil@planet.nl>,
       Chuck Ebbert <cebbert@redhat.com>, Greg KH <greg@kroah.com>,
       stable@kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20071029204116.GA13026@elte.hu>
References: <200710122231.50739.elendil@planet.nl>
	 <4725D2A5.1050908@linux.vnet.ibm.com> <20071029200425.GA830@elte.hu>
	 <200710292133.48125.borntraeger@de.ibm.com>
	 <20071029204116.GA13026@elte.hu>
Content-Type: text/plain
Date: Mon, 29 Oct 2007 22:11:04 +0100
Message-Id: <1193692264.5644.82.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-10-29 at 21:41 +0100, Ingo Molnar wrote:
> * Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> 
> > > -	return clock_t_to_cputime(utime);
> > > +	p->prev_utime = max(p->prev_utime, clock_t_to_cputime(utime));
> > > +	return p->prev_utime;
> > >  }
> > [...]
> > 
> > I dont think it will work. It will make utime monotic, but stime can 
> > still decrease. For example let sum_exec_runtime increase by a tiny 
> > little bit while utime will get a full additional tick. stime is 
> > sum-utime. So stime can still go backwards. So I think that we need 
> > this kind of logic for stime as well, no?
> 
> yeah, probably. Peter?

/me dons the brown paper bag while mumbling an agreement of sorts.

I'll not attempt to come up with a patch as I fear I'll just make a
bigger mess in my current state, hope to feel better tomorrow..

