Return-Path: <linux-kernel-owner+w=401wt.eu-S1759176AbZFMTGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759176AbZFMTGg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 15:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbZFMTGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 15:06:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57356 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753471AbZFMTGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 15:06:30 -0400
Date: Sat, 13 Jun 2009 20:30:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: Re: [PATCH] Bring sparc64 dynamic ftrace up to snuff...
Message-ID: <20090613183018.GB5485@elte.hu>
References: <20090613.011020.214065340.davem@davemloft.net> <alpine.DEB.2.00.0906130950220.16299@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0906130950220.16299@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Sat, 13 Jun 2009, David Miller wrote:
> 
> > 
> > Do the ftrace maintainers mind if I merge the following in via my
> > sparc-next-2.6 tree?
> 
> Not at all.
> 
> > 
> > Thanks!
> > 
> > sparc64: Add proper dynamic ftrace support.
> > 
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> > ---
> >  arch/sparc/Kconfig              |    2 +
> >  arch/sparc/include/asm/ftrace.h |   11 +++++++++
> >  arch/sparc/kernel/ftrace.c      |   47 ++++++++++++++++++++++++++------------
> >  scripts/recordmcount.pl         |   20 ++++++++++++++++
> >  4 files changed, 65 insertions(+), 15 deletions(-)
> > 
> 
> 
> > +#endif
> > +
> > diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
> > index 409596e..e694eaf 100755
> > --- a/scripts/recordmcount.pl
> > +++ b/scripts/recordmcount.pl
> > @@ -213,6 +213,26 @@ if ($arch eq "x86_64") {
> >      if ($is_module eq "0") {
> >          $cc .= " -mconstant-gp";
> >      }
> > +} elsif ($arch eq "sparc64") {
> > +    # In the objdump output there are giblets like:
> > +    # 0000000000000000 <igmp_net_exit-0x18>:
> > +    # As there's some data blobs that get emitted into the
> > +    # text section before the first instructions and the first
> > +    # real symbols.  We don't want to match that, so to combat
> > +    # this we use '\w' so we'll match just plain symbol names,
> > +    # and not those that also include hex offsets inside of the
> > +    # '<>' brackets.  Actually the generic function_regex setting
> > +    # could safely use this too.
> > +    $function_regex = "^([0-9a-fA-F]+)\\s+<(\\w*?)>:";
> > +
> > +    # Sparc64 calls '_mcount' instead of plain 'mcount'.
> > +    $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s_mcount\$";
> > +
> > +    $alignment = 8;
> > +    $type = ".xword";
> > +    $ld .= " -m elf64_sparc";
> > +    $cc .= " -m64";
> > +    $objcopy .= " -O elf64-sparc";
> >  } else {
> >      die "Arch $arch is not supported with CONFIG_FTRACE_MCOUNT_RECORD";
> >  }
> 
> The only thing outside of arch/sparc is this recordmcount.pl, and 
> that too is arch specific.
> 
> I'm fine with it.
> 
> Acked-by: Steven Rostedt <rostedt@goodmis.org>

Me too - thanks David!

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
