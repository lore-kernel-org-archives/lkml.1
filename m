Return-Path: <linux-kernel-owner+w=401wt.eu-S1757266AbZCDTef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266AbZCDTef (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 14:34:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756747AbZCDTeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 14:34:24 -0500
Received: from mx1.emlix.com ([193.175.82.87]:47533 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755680AbZCDTeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 14:34:23 -0500
Date: Wed, 4 Mar 2009 20:33:53 +0100
From: Johannes Weiner <jw@emlix.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>,
       Russell King <rmk@arm.linux.org.uk>, Bryan Wu <cooloney@kernel.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Paul Mundt <lethal@linux-sh.org>, Greg Ungerer <gerg@uclinux.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch -v2] flat: fix data sections alignment
References: <E1LerUo-0000NE-Q3@mailer.emlix.com> <8bd0f97a0903041004g467cbe47jc7c66261da01348c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0903041004g467cbe47jc7c66261da01348c@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Message-Id: <E1LewqM-0005Tp-R1@mailer.emlix.com>
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 04, 2009 at 01:04:00PM -0500, Mike Frysinger wrote:
> On Wed, Mar 4, 2009 at 08:51, Johannes Weiner wrote:
> > The flat loader uses an architecture's flat_stack_align() to align the
> > stack but assumes word-alignment is enough for the data sections.
> >
> > However, on the Xtensa S6000 we have registers up to 128bit width
> > which can be used from userspace and therefor need userspace stack and
> > data-section alignment of at least this size.
> 
> could this perhaps be a gcc problem ?  x86 has a similar problem with
> sse and they addressed it with a function attribute.  after all, just
> because your stack started out 128bit aligned doesnt mean gcc will
> keep it that way when calling other functions.  so having the stack
> start out aligned would only "fix" the stack for the application's
> entry point right (which would in practice bubble up to main()) ?  so
> you'd be right back where you started ...

gcc generates sp changes only ever in multiples of 16 deltas, I just
checked it again with various amounts of stack variables.

The stack frames allocate themselves with an ENTRY instruction and the
generated code I read here allocates stack frames of n * 16 bytes.

So we are good to go as long as the initial stack frame is properly
aligned.

> -mike

	Hannes
