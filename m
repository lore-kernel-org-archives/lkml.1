Return-Path: <linux-kernel-owner+w=401wt.eu-S1754401AbZFGO22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401AbZFGO22 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 10:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753063AbZFGO2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 10:28:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50521 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645AbZFGO2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 10:28:20 -0400
Date: Sun, 7 Jun 2009 16:28:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Figo.zhang" <figo1802@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND]X86:microcode: fix vfree()
Message-ID: <20090607142819.GD21340@elte.hu>
References: <1244351929.3355.13.camel@myhost> <20090607140113.GI12088@elte.hu> <1244384315.3402.5.camel@myhost> <20090607142118.GB21340@elte.hu> <1244384715.3402.8.camel@myhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244384715.3402.8.camel@myhost>
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


* Figo.zhang <figo1802@gmail.com> wrote:

> On Sun, 2009-06-07 at 16:21 +0200, Ingo Molnar wrote:
> > (Note: it's not a 'resend', it's v2 of the patch)
> > 
> > * Figo.zhang <figo1802@gmail.com> wrote:
> > 
> > > vfree() does its own 'NULL' check, so no need for check before
> > > calling it.
> > > 
> > > Signed-off-by: Figo.zhang <figo1802@gmail.com>
> > > ---   
> > > arch/x86/kernel/microcode_amd.c |   13 +++++--------
> > >  1 files changed, 5 insertions(+), 8 deletions(-)
> > > 
> > > diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
> > > index 453b579..8f52cf4 100644
> > > --- a/arch/x86/kernel/microcode_amd.c
> > > +++ b/arch/x86/kernel/microcode_amd.c
> > > @@ -257,10 +257,9 @@ static int install_equiv_cpu_table(const u8 *buf)
> > >  
> > >  static void free_equiv_cpu_table(void)
> > >  {
> > > -	if (equiv_cpu_table) {
> > > -		vfree(equiv_cpu_table);
> > > -		equiv_cpu_table = NULL;
> > > -	}
> > > +	vfree(equiv_cpu_table);
> > > +	equiv_cpu_table = NULL;
> > > +
> 
> i motify by vim, you said this line?

yes, that extra empty newline should not be there. (i.e. the line 
should be removed)
 
	Ingo
