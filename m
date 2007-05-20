Return-Path: <linux-kernel-owner+w=401wt.eu-S1760954AbXETV1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760954AbXETV1i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 17:27:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757024AbXETV1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 17:27:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:57950 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756917AbXETV13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 17:27:29 -0400
Date: Mon, 21 May 2007 00:24:22 +0200
From: Andi Kleen <ak@suse.de>
To: Folkert van Heusden <folkert@vanheusden.com>
Cc: Andi Kleen <ak@suse.de>, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>, Rik van Riel <riel@redhat.com>,
       righiandr@users.sourceforge.net, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
Subject: Re: signals logged / [RFC] log out-of-virtual-memory events
Message-ID: <20070520222422.GT2012@bingen.suse.de>
References: <464C9D82.60105@redhat.com> <Pine.LNX.4.61.0705202235430.13923@yvahk01.tjqt.qr> <20070520205500.GJ22452@vanheusden.com> <200705202314.57758.ak@suse.de> <20070520212036.GL22452@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070520212036.GL22452@vanheusden.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 20, 2007 at 11:20:36PM +0200, Folkert van Heusden wrote:
> > > +	switch(sig) {
> > > +	case SIGQUIT: 
> > > +	case SIGILL: 
> > > +	case SIGTRAP:
> > > +	case SIGABRT: 
> > > +	case SIGBUS: 
> > > +	case SIGFPE:
> > > +	case SIGSEGV: 
> > > +	case SIGXCPU: 
> > > +	case SIGXFSZ:
> > > +	case SIGSYS: 
> > > +	case SIGSTKFLT:
> > 
> > Unconditional? That's definitely a very bad idea. If anything only unhandled
> > signals should be printed this way because some programs use them internally. 
> 
> Use these signals internally? Afaik these are fatal, stopping the
> process. So using them internally would be a little tricky.

All of them are catchable.

> 
> > But I think your list is far too long anyways.
> 
> So, which ones would you like to have removed then?

SIGFPE at least and the accounting signals are dubious too. SIGQUIT can
be also relatively common.

-Andi
