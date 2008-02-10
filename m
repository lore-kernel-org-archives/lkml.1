Return-Path: <linux-kernel-owner+w=401wt.eu-S1755466AbYBJWLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466AbYBJWLs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 17:11:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbYBJWLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 17:11:41 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:53271 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbYBJWLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 17:11:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=Jv69o1Rp+4QsE9mkTOUKY9K4VTnl+puUg3JaBzcYq9cCM5RGupaHs8ycDAdXPr4zRK7G+qzpgQLWVIm4XogMeImQo9/MAIqsbrvCPOT75wnZg7/JKKdSMq07ovyQf2EAsM/D1UVt3u/aInIPMg0mMfWm5iApHnZCkR5j176qte8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] kgdb light, v6
Date: Sun, 10 Feb 2008 23:24:59 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
References: <20080210071331.GC3851@elte.hu> <200802102155.46505.bzolnier@gmail.com> <20080210210900.GA27162@elte.hu>
In-Reply-To: <20080210210900.GA27162@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802102324.59821.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sunday 10 February 2008, Ingo Molnar wrote:

[...]

> > > +__setup("kgdboc=", kgdboc_option_setup);
> > 
> > no need for obsolete __setup, we have module_param_call() below
> 
> it's needed for bzImage kernels. I just tested it and without __setup() 
> no init sequence is run and KGDB is not activated.

weird, should work with "kgdboc.kgdboc=" parameter

[...]

> > > +#ifndef KGDB_MAX_BREAKPOINTS
> > > +# define KGDB_MAX_BREAKPOINTS	1000
> > > +#endif
> > > +
> > > +#define KGDB_HW_BREAKPOINT	1
> > 
> > unused
> 
> hm, both KGDB_MAX_BREAKPOINTS and KGDB_HW_BREAKPOINT are used.

my bad

[...]

> > if kgdb_isremovedbreak() helper is moved before kgdb_set_sw_break() 
> > and converted to return 'i' on success and '-1' on failure then it can 
> > be used instead the above for () loop
> 
> dunno - that would complicate arch/x86/kernel/kgdb.c's use of 
> kgdb_isremovedbreak() and looks a bit complex. If you feel strongly 

the whole difference w.r.t. arch/x86/kernel/kgdb.c should be:

-	if (exception == 3 && kgdb_isremovedbreak(regs->ip - 1)) {
+	if (exception == 3 && kgdb_isremovedbreak(regs->ip - 1) >= 0) {

> about it, could you send a patch?

well, maybe in the future if nobody fixes it :)

[ added as low-prio to my TODO... ]

Thanks for fixing all the other stuff.

Bart
