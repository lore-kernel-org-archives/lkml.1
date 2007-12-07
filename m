Return-Path: <linux-kernel-owner+w=401wt.eu-S1753981AbXLGCnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981AbXLGCnA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 21:43:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752990AbXLGCmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 21:42:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:37899 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854AbXLGCmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 21:42:51 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Ingo Molnar <mingo@elte.hu>, ebiederm@xmission.com
Subject: Re: [PATCH] i386 IOAPIC: de-fang IRQ compression
Date: Thu, 6 Dec 2007 21:41:04 -0500
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, protasnb@gmail.com, ak@suse.de,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
References: <200711280121.18376.lenb@kernel.org> <20071204163946.63ac73ce.akpm@linux-foundation.org> <20071205094837.GB17911@elte.hu>
In-Reply-To: <20071205094837.GB17911@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712062141.05195.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 December 2007 04:48, Ingo Molnar wrote:
> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Tue, 4 Dec 2007 13:26:49 +0100
> > Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > * Len Brown <lenb@kernel.org> wrote:
> > > 
> > > >     So while the irq compression code on i386 should really
> > > >     be deleted -- even before merging the x86_64 irq-overhaul,
> > > >     this patch simply disables it on all high volume systems
> > > >     to avoid problems #1 and #2 on most all i386 systems.
> > > >     
> > > >     A large system with pin numbers >=64 will still have compression
> > > >     to conserve limited IRQ numbers for sparse IOAPICS.  However,
> > > >     the vast majority of the planet, those with only pin numbers < 64
> > > >     will use an identity GSI -> IRQ mapping.
> > > >     
> > > >     Signed-off-by: Len Brown <len.brown@intel.com>
> > > 
> > > thanks for the patch and the extensive description. I've applied this to 
> > > x86.git.
> > 
> > Len applied it to his tree too.
> 
> Len, i think this belongs into x86.git a bit more (especially with the 
> unification activities going on all around the tree) - do you agree? 
> Andrew, i'd suggest to apply a reverted patch to between git.acpi and 
> git.x86 until this gets sorted out.

Sure.
I'm re-basing my test branch right now and can exclude this one
since it is in x86.git. (and yes, I'm interested in unifying mpparse_*.c some day)

yes, your understanding is correct -- this is not urgent 2.6.24 material,
it is just a 'regular patch':-)

Re: making the VIA part into dead-code
I had avoided that originally because I was going to nominate
this patch for the highest check-in-comment length/code-change ratio
But once I went over 1 line I blew the budget;-)

Eric,
What do you suggest we do with NR_IRQS on i386 so that we
can delete the compression code entirely?

thanks,
-Len
