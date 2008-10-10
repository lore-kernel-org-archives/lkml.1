Return-Path: <linux-kernel-owner+w=401wt.eu-S1759326AbYJJNNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759326AbYJJNNT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 09:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756043AbYJJNNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 09:13:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52102 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755825AbYJJNNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 09:13:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH 2/2] first callers of process_deny_checkpoint()
Date: Fri, 10 Oct 2008 15:17:16 +0200
User-Agent: KMail/1.9.9
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       containers@lists.linux-foundation.org, arnd@arndb.de,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <20081009190405.13A253CB@kernel> <1223585671.11830.40.camel@nimitz> <20081010084614.GA319@elte.hu>
In-Reply-To: <20081010084614.GA319@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810101517.17809.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 10 of October 2008, Ingo Molnar wrote:
> 
> * Dave Hansen <dave@linux.vnet.ibm.com> wrote:
> 
> > On Thu, 2008-10-09 at 14:43 -0500, Serge E. Hallyn wrote:
> > > Hmm, I don't know too much about aio, but is it possible to succeed with
> > > io_getevents if we didn't first do a submit?  It looks like the contexts
> > > are looked up out of current->mm, so I don't think we need this call
> > > here.
> > > 
> > > Otherwise, this is neat.
> > 
> > Good question.  I know nothing, either. :)
> > 
> > My thought was that any process *trying* to do aio stuff of any kind 
> > is going to be really confused if it gets checkpointed.  Or, it might 
> > try to submit an aio right after it checks the list of them.  I 
> > thought it best to be cautious and say, if you screw with aio, no 
> > checkpointing for you!
> 
> as long as there's total transparency and the transition from CR-capable 
> to CR-disabled state is absolutely safe and race-free, that should be 
> fine.
> 
> I expect users to quickly cause enough pressure to reduce the NOCR areas 
> of the kernel significantly ;-)
> 
> In the long run, could we expect a (experimental) version of hibernation 
> that would just use this checkpointing facility to hibernate?

Surely not ACPI-compliant.

Apart from this I don't see why not, but OTOH I'm not particularly interested
in implementing that.

Thanks,
Rafael
