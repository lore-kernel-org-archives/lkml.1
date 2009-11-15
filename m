Return-Path: <linux-kernel-owner+w=401wt.eu-S1751642AbZKOVNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642AbZKOVNb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 16:13:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751238AbZKOVNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 16:13:30 -0500
Received: from mail.perches.com ([173.55.12.10]:1084 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbZKOVN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 16:13:29 -0500
Subject: Re: [PATCH] sysctl.c: Change a .proc_handler = proc_dointvec to
 &proc_dointvec,
From: Joe Perches <joe@perches.com>
To: Julia Lawall <julia@diku.dk>, Andy Whitcroft <apw@canonical.com>
Cc: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Am??rico Wang <xiyou.wangcong@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0911152139020.30372@ask.diku.dk>
References: <1258249925.16857.198.camel@Joe-Laptop.home>
	 <20091115065958.GA2459@hack> <20091115081126.GD15432@elte.hu>
	 <1258273714.21668.13.camel@Joe-Laptop.home>
	 <20091115083951.GA27393@elte.hu> <m1hbswm7dk.fsf@fess.ebiederm.org>
	 <20091115103307.GB24931@elte.hu>
	 <1258306299.21668.30.camel@Joe-Laptop.home>
	 <Pine.LNX.4.64.0911151916100.27042@ask.diku.dk>
	 <1258313031.21668.73.camel@Joe-Laptop.home>
	 <Pine.LNX.4.64.0911152139020.30372@ask.diku.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 15 Nov 2009 13:13:34 -0800
Message-ID: <1258319614.21668.115.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-11-15 at 21:40 +0100, Julia Lawall wrote:
> On Sun, 15 Nov 2009, Joe Perches wrote:
> > On Sun, 2009-11-15 at 19:20 +0100, Julia Lawall wrote:
> > > Searching for things that are declared as functions (either a definition 
> > > or a prototype), and then referenced as &f gives over 2000 results in 
> > > almost 600 files.
> > Just curious, do you know how many are referenced
> > without the &?
> I got over 95000 (not checked in detail, though).

Thanks.

I think that ~25+:1 ratio makes a good case for an
eventual conversion of the remaining uses.

> > If what is desired is kernel wide consistent use, yes.
> > What I would like is file/subsystem consistent use.
> > 
> > Looking at sysctl.c and seeing that different use
> > stand out was odd.
> 
> It would be possible to count the number of occurrences in a given file, 
> and then change the ones that have the less popular format, or a format 
> that occurs less than some percentage of time.

Maybe it'd be useful to add a coccinelle/spatch
directory in scripts and add these scripts so
that files and subsystems can updated over time.

I can not find a directory of coccinelle input
scripts for linux at:
http://coccinelle.lip6.fr/download.php
Is there a list somewhere?

Perhaps add a checkpatch test as well though
that might be an interesting test to write in
perl.


