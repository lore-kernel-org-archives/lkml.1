Return-Path: <linux-kernel-owner+w=401wt.eu-S1758386AbXFDR2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758386AbXFDR2u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 13:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756394AbXFDR2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 13:28:43 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39267 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755934AbXFDR2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 13:28:42 -0400
Date: Mon, 4 Jun 2007 10:28:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matt Mackall <mpm@selenic.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: lguest rebroken in 2.6.22-rc3-mm1
Message-Id: <20070604102820.a4a0ee15.akpm@linux-foundation.org>
In-Reply-To: <20070604171932.GE11115@waste.org>
References: <20070522223828.GV11115@waste.org>
	<1179876460.20705.157.camel@localhost.localdomain>
	<20070604171932.GE11115@waste.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jun 2007 12:19:33 -0500 Matt Mackall <mpm@selenic.com> wrote:

> On Wed, May 23, 2007 at 09:27:40AM +1000, Rusty Russell wrote:
> > On Tue, 2007-05-22 at 17:38 -0500, Matt Mackall wrote:
> > > [    0.120007] EIP is at resync_sc_freq+0x4b/0x56
> > 
> > Hi Matt,
> > 
> > 	Thanks for the report!  Andrew should have these two patches queued,
> > but here they are again:
> > 
> > If you set tsc_disable (eg "notsc" on cmdline), sched-clock.c gives a
> > divide by zero on boot.
> > 
> > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> > 
> > ---
> >  arch/i386/kernel/sched-clock.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > ===================================================================
> > --- a/arch/i386/kernel/sched-clock.c
> > +++ b/arch/i386/kernel/sched-clock.c
> > @@ -103,7 +103,7 @@ static void resync_sc_freq(struct sc_dat
> >  static void resync_sc_freq(struct sc_data *sc, unsigned int newfreq)
> >  {
> >  	sc->sync_base = jiffies;
> > -	if (!cpu_has_tsc) {
> > +	if (!cpu_has_tsc || tsc_disable) {
> >  		sc->unstable = 1;
> >  		return;
> >  	}
> 
> Looks like this one got lost in rc3-mm1.
> 

Andi said that he fixed the zero-divide by other means?
