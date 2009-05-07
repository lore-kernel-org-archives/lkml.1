Return-Path: <linux-kernel-owner+w=401wt.eu-S1759493AbZEGJPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759493AbZEGJPz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 05:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755537AbZEGJPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 05:15:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41152 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754385AbZEGJPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 05:15:44 -0400
Date: Thu, 7 May 2009 11:13:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org
Subject: Re: [PATCH] x86: ptrace debugreg checks rewrite
Message-ID: <20090507091357.GA26433@elte.hu>
References: <20090504001601.GL16631@x200.localdomain> <20090504002431.GA17556@x200.localdomain> <20090506095629.GC15323@elte.hu> <20090506203852.D9AC9FC39E@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506203852.D9AC9FC39E@magilla.sf.frob.com>
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


* Roland McGrath <roland@redhat.com> wrote:

> > > On Mon, May 04, 2009 at 04:16:01AM +0400, Alexey Dobriyan wrote:
> > > > +static int ptrace_check_debugreg(int _32bit,
> > > > +				 unsigned long dr0, unsigned long dr1,
> > > > +				 unsigned long dr2, unsigned long dr3,
> > > > +				 unsigned long dr6, unsigned long dr7)
> > > > +{
> > > > +	/* Breakpoint type: 00: --x, 01: -w-, 10: undefined, 11: rw- */
> > > > +	unsigned int rw[4];
> > > > +	/* Breakpoint length: 00: 1 byte, 01: 2 bytes, 10: 8 bytes, 11: bytes */
> > > 								        4 bytes, of course
> > 
> > Roland, Oleg, do you have any pending/planned changes in this area?
> 
> I don't.  I expect the only future work on this arch debugreg 
> stuff to be via the hw_breakpoint work, extending that and/or 
> building new things on it.

Yes. That work, despite being in its upteenth iteration, is taking a 
frustratingly long amount of time to get even to a minimal "review 
passed, lets commit and test this in a tree a bit" intermediate 
stage though.

I've Cc:-ed K.Prasad and Alan Stern. Roland, Oleg, would you be 
interested in having a look at that thread, to help drive it 
forward?

The last iteration was posted to lkml on Apr 24:

  [Patch 00/12] Hardware Breakpoint Interfaces

and it has a good deal of ptrace, signal handling and other impact 
as well.

	Ingo
