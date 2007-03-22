Return-Path: <linux-kernel-owner+w=401wt.eu-S1030268AbXCVINa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030268AbXCVINa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 04:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030274AbXCVINa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 04:13:30 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:58169 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030268AbXCVIN1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 04:13:27 -0400
Date: Thu, 22 Mar 2007 09:10:31 +0100
From: =?ISO-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] i386 GDT cleanups: Use per-cpu GDT immediately upon
 boot
Message-ID: <20070322091031.33a753fe@frecb000686.frec.bull.fr>
In-Reply-To: <1174521510.2713.61.camel@localhost.localdomain>
References: <1174457426.11680.132.camel@localhost.localdomain>
	<1174458636.11680.143.camel@localhost.localdomain>
	<1174458730.11680.145.camel@localhost.localdomain>
	<1174458938.11680.150.camel@localhost.localdomain>
	<m1aby7c59k.fsf@ebiederm.dsl.xmission.com>
	<1174478153.11680.183.camel@localhost.localdomain>
	<m1wt1abkuo.fsf@ebiederm.dsl.xmission.com>
	<1174521510.2713.61.camel@localhost.localdomain>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 22/03/2007 09:15:25,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 22/03/2007 09:15:28,
	Serialize complete at 22/03/2007 09:15:28
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Hi Rusty,

On Thu, 22 Mar 2007 10:58:30 +1100 Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Wed, 2007-03-21 at 10:51 -0600, Eric W. Biederman wrote:
> > Rusty Russell <rusty@rustcorp.com.au> writes:
> > 
> > > On Wed, 2007-03-21 at 03:31 -0600, Eric W. Biederman wrote:
> > >> Rusty Russell <rusty@rustcorp.com.au> writes:
> > >> > -/*
> > >> > - * The boot_gdt_table must mirror the equivalent in setup.S and is
> > >> > - * used only for booting.
> > >> > - */
> > >> 
> > >> It looks like you are killing a useful comment here for no good reason.
> > >
> > > Hi Eric,
> > >
> > > 	I think one has to look harder, then.  There is no "equivalent in
> > > setup.S": there is no setup.S, and it's certainly not clear what GDT
> > > this "must mirror": it doesn't mirror any GDT at the moment.
> > 
> > see the gdt in:
> > arch/i386/boot/setup.S
> 
> Erk, what a dumb mistake.  Apologies for my snarky comment above 8(
> 
> > If anything the comment should read these values are fixed by the boot
> > protocol and we can't change them.
> 
> Since lguest doesn't use setup.S, it's outside my experience.  I'll just
> leave the comment, and try to pretend this never happened 8)
> 
> Thanks muchly,
> Rusty.
> ==
> Now we are no longer dynamically allocating the GDT, we don't need the
> "cpu_gdt_table" at all: we can switch straight from "boot_gdt_table"
> to the per-cpu GDT.  This means initializing the cpu_gdt array in C.


  Why not take on the opportunity to rename boot_gt_table to boot_gtd,
to avoid the duplicate T(able)?

  Sébastien.
