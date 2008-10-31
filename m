Return-Path: <linux-kernel-owner+w=401wt.eu-S1753560AbYJaJ4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560AbYJaJ4V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 05:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbYJaJ4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 05:56:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59915 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035AbYJaJ4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 05:56:07 -0400
Date: Fri, 31 Oct 2008 10:55:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH] tracing: fix a build error on alpha and m68k
Message-ID: <20081031095544.GI30317@elte.hu>
References: <c62985530810230548t1b569f61g34d1900bb94fde83@mail.gmail.com> <c62985530810230615s3252a54ao6488e763d72dc939@mail.gmail.com> <49008D12.5090204@gmail.com> <Pine.LNX.4.64.0810231635440.18978@anakin> <c62985530810230757r411b4e3dj4ecec649cf8cf0b3@mail.gmail.com> <Pine.LNX.4.64.0810231727430.18978@anakin> <4900B414.7090002@gmail.com> <20081023163433.GA3160@x200.localdomain> <20081030214910.GA14679@x200.localdomain> <Pine.LNX.4.64.0810310949190.22521@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810310949190.22521@anakin>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> On Fri, 31 Oct 2008, Alexey Dobriyan wrote:
> > On Thu, Oct 23, 2008 at 08:34:33PM +0400, Alexey Dobriyan wrote:
> > > On Thu, Oct 23, 2008 at 07:27:48PM +0200, Frederic Weisbecker wrote:
> > > > When tracing is enabled, some arch have included <linux/irqflags.h>
> > > > on their <asm/system.h> but others like alpha or m68k don't.
> > > > 
> > > > Build error on alpha:
> > > > 
> > > > kernel/trace/trace.c: In function 'tracing_generic_entry_update':
> > > > kernel/trace/trace.c:658: error: implicit declaration of function 'irqs_disabled_flags'
> > 
> > FYI, this error still exists in mainline (7f82f000ed030d1108b4de47d9e2d556092980c6).
> 
> Now it hit mainline (I can't be bothered to develop _new_ code to 
> fix things in -next ;-), I'm implementing irqs_disabled_flags() for 
> m68k. Stay tuned...

this (now mainline) commit should have fixed it:

 9244489: ftrace: handle archs that do not support irqs_disabled_flags

can you still see problems?

	Ingo
