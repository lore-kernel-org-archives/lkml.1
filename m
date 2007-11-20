Return-Path: <linux-kernel-owner+w=401wt.eu-S1760116AbXKTRN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760116AbXKTRN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 12:13:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755206AbXKTRNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 12:13:51 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:39326 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbXKTRNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 12:13:50 -0500
Date: Tue, 20 Nov 2007 09:05:19 -0800
From: Greg KH <greg@kroah.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Greg KH <gregkh@suse.de>,
       David <david@unsolicited.net>,
       Javier Kohen <jkohen@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [stable] Soft lockups since stable kernel upgrade to 2.6.23.8
Message-ID: <20071120170519.GB15954@kroah.com>
References: <1195323695.5240.16.camel@null.tough.com.ar> <20071117191211.GA12757@kroah.com> <473F498D.9090703@unsolicited.net> <20071117203705.GA21045@kroah.com> <473F88B0.1030309@goop.org> <20071119232252.GC3528@suse.de> <47423B26.1090607@goop.org> <20071120060525.GF20436@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071120060525.GF20436@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2007 at 07:05:25AM +0100, Ingo Molnar wrote:
> 
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> > Greg KH wrote:
> > > Can you try applying the patch below to see if that solves the problem
> > > for you?
> > >   
> > 
> > I don't think this patch will help; it only has cosmetic changes in
> > addition to the original message printing fix.  I think it also needs
> > change a3b13c23f186ecb57204580cc1f2dbe9c284953a:
> > 
> > diff -r 79f0ea1e0e70 -r 06f060ab58aa kernel/softlockup.c
> 
> yes, it does need the cpu_clock() changes as i mentioned.
> 
>   commit a3b13c23f186ecb57204580cc1f2dbe9c284953a
>   Author: Ingo Molnar <mingo@elte.hu>
>   Date:   Tue Oct 16 23:26:06 2007 -0700
> 
>     softlockup: use cpu_clock() instead of sched_clock()
> 
>     sched_clock() is not a reliable time-source, use cpu_clock() instead.
> 
> but we only have cpu_clock() from v2.6.23 onwards - so we should not 
> apply the original patch to v2.6.22. (we should not have applied your 
> patch that started the mess to begin with - but that's another matter.)

Well, I can easily back that one out, if that is easier than adding 2
more patches to try to fix up the mess here.

Let me know if you feel that would be best.

thanks,

greg k-h
