Return-Path: <linux-kernel-owner+w=401wt.eu-S1758301AbYHOUDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758301AbYHOUDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 16:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751062AbYHOUDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 16:03:04 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:28171 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbYHOUDC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 16:03:02 -0400
Date: Fri, 15 Aug 2008 22:02:30 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>, srostedt@redhat.com
Subject: Re: [PATCH 0/3] ftrace: handle kernel code remove
Message-ID: <20080815200230.GA18516@uranus.ravnborg.org>
References: <20080815024716.480118113@goodmis.org> <20080815092844.GD22209@elte.hu> <20080815093851.GB9312@elte.hu> <20080815094827.GA21766@elte.hu> <20080815100600.GA29180@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080815100600.GA29180@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2008 at 12:06:00PM +0200, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > >   http://redhat.com/~mingo/misc/config-Fri_Aug_15_11_34_53_CEST_2008.bad
> > 
> > the problem is that i'm building a 32-bit kernel on a 64-bit host, and 
> > the scripts/recordmcount.pl script does not create the temporary 
> > object files in the proper (32-bit) output ELF format.
> 
> the crude hack below got me going for now - but this needs a proper 
> solution.

recordmount.pl should use the already define environment variables:
$CC + $CFLAGS
$LD + $LDFLAGS
$OBJCOPY, $OBJCOPYFLAGS
$OBJDUMP

We need to set $OBJCOPYFLAFS to a sensible variable in arch/x86/Makefile
And we should introduce $OBJDUMPFLAGS too.

This would solve all the problems - no?

I am limited in time atm - so relying on one of you to create the patch
and do some testing.

	Sam
