Return-Path: <linux-kernel-owner+w=401wt.eu-S1754679AbYL2LJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679AbYL2LJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 06:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbYL2LJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 06:09:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51239 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753014AbYL2LJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 06:09:07 -0500
Date: Mon, 29 Dec 2008 12:08:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@infradead.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: reboot.c declare port_cf9_safe before they get
	used
Message-ID: <20081229110855.GA5065@elte.hu>
References: <1230049288.14358.4.camel@jaswinder.satnam> <20081227103141.GF14639@elte.hu> <1230540199.3715.11.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1230540199.3715.11.camel@jaswinder.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinder@infradead.org> wrote:

> Hello Ingo,
> 
> On Sat, 2008-12-27 at 11:31 +0100, Ingo Molnar wrote:
> 
> > btw., this is ugly now:
> > 
> > > --- a/arch/x86/kernel/reboot.c
> > > +++ b/arch/x86/kernel/reboot.c
> > > @@ -22,6 +22,7 @@
> > >  #endif
> > >  
> > >  #include <mach_ipi.h>
> > > +#include "../pci/pci.h"
> > 
> > could you send another patch that moves arch/x86/pci/pci.h to 
> > arch/x86/include/asm/pci_x86.h (and update all the pci.h include sites)?
> > 
> 
> 1. I send ﻿[PATCH] move arch/x86/pci/pci.h to
> arch/x86/include/asm/pci_x86.h but I forget to write x86: before this
> patch.

no, your patch is fine. I routinely fix up commit logs.

Jesse, is it fine to you if we push this via the x86 tree? A couple of 
usage sites of arch/x86/pci/pci.h arose that use ../pci/pci.h kind of ugly
#include prefixes, which justifies moving the file to
arch/x86/include/asm. No change in behavior.

	Ingo
