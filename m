Return-Path: <linux-kernel-owner+w=401wt.eu-S1753065AbZAFMYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065AbZAFMYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 07:24:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbZAFMYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 07:24:05 -0500
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:28206 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751436AbZAFMYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 07:24:04 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=NJxRzldOQg47N9tYV0B00ENPCoQEPEtABgvnZRGxo+3JoTODTvKYnZwPhQuioqqSB3ql4rEhzsymgCBxnRvCSxTHR/UhTmOxWnoqeGohSbZwvfnV3vvMrb3V1gQ19bDMRrobfr0H63UnFZcGeHFfjKFN0RWkGnfy+FPL1dL4qTQ=  ;
X-YMail-OSG: itYn1BwVM1mowUy9VD76dHMY4E0ui5zGSNrvZL9z0wfBRBVnLWy3SIg.1Ygz0l1SWGDyvplfuEBrOXe_tkNG_oYk8aAKh2jpldZJSQd1QSZt5VOZFlcndUSxyhxofgWoRYQE3BNk6fuJKzseuATuyL9PLZW1MIrTGaHA01W.FnXsNPccTQg_hhElDY6EhA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] x86: make UV support optional
Date: Tue, 6 Jan 2009 23:23:42 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Nick Piggin <npiggin@suse.de>, Yinghai Lu <yinghai@kernel.org>,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, Cliff Wickman <cpw@sgi.com>,
       Jack Steiner <steiner@sgi.com>, Russ Anderson <rja@sgi.com>
References: <20090106060348.GA16738@wotan.suse.de> <20090106064433.GB16738@wotan.suse.de> <20090106090138.GD29917@elte.hu>
In-Reply-To: <20090106090138.GD29917@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901062323.44312.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 January 2009 20:01:38 Ingo Molnar wrote:

> > > > ---
> > > >  arch/x86/Kconfig                  |    7 +++++++
> > > >  arch/x86/include/asm/genapic.h    |   24 ++++++++++++++++++++++++
> > > >  arch/x86/include/asm/genapic_32.h |    7 -------
> > > >  arch/x86/include/asm/genapic_64.h |    9 ---------
> > > >  arch/x86/kernel/Makefile          |    5 +++--
> > > >  arch/x86/kernel/entry_64.S        |    2 ++
> > > >  arch/x86/kernel/genapic_64.c      |    3 ++-
> > > >  arch/x86/kernel/io_apic.c         |    2 +-
> > > >  8 files changed, 39 insertions(+), 20 deletions(-)
> > >
> > > how about
> > > kernel/efi.c:                   efi.uv_systab = config_tables[i].table;
> > > ?
> >
> > Good point, I missed that. Will resend a patch with that ifdef'ed
> > tomorrow unless any serious objections are raised.
>
> Looks good to me, but please also extend the Makefile changes to
> kernel/tlb_uv.c, ./kernel/uv_sysfs.c, kernel/uv_irq.c, kernel/bios_uv.c -
> UV not just the genapic bits. Perhaps do it via gradual patches.

Hmm, I think the Makefile changes should be there... the files
you reference AFAIKS are put under conditional compilation with
my patch?

