Return-Path: <linux-kernel-owner+w=401wt.eu-S1751882AbZKOVeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbZKOVeJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 16:34:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751168AbZKOVeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 16:34:08 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:43631 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbZKOVeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 16:34:08 -0500
Date: Sun, 15 Nov 2009 22:34:10 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Am??rico Wang <xiyou.wangcong@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] sysctl.c: Change a .proc_handler = proc_dointvec to
 &proc_dointvec,
In-Reply-To: <1258319614.21668.115.camel@Joe-Laptop.home>
Message-ID: <Pine.LNX.4.64.0911152232090.30372@ask.diku.dk>
References: <1258249925.16857.198.camel@Joe-Laptop.home>  <20091115065958.GA2459@hack>
 <20091115081126.GD15432@elte.hu>  <1258273714.21668.13.camel@Joe-Laptop.home>
  <20091115083951.GA27393@elte.hu> <m1hbswm7dk.fsf@fess.ebiederm.org> 
 <20091115103307.GB24931@elte.hu>  <1258306299.21668.30.camel@Joe-Laptop.home>
  <Pine.LNX.4.64.0911151916100.27042@ask.diku.dk>  <1258313031.21668.73.camel@Joe-Laptop.home>
  <Pine.LNX.4.64.0911152139020.30372@ask.diku.dk> <1258319614.21668.115.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Nov 2009, Joe Perches wrote:

> On Sun, 2009-11-15 at 21:40 +0100, Julia Lawall wrote:
> > On Sun, 15 Nov 2009, Joe Perches wrote:
> > > On Sun, 2009-11-15 at 19:20 +0100, Julia Lawall wrote:
> > > > Searching for things that are declared as functions (either a definition 
> > > > or a prototype), and then referenced as &f gives over 2000 results in 
> > > > almost 600 files.
> > > Just curious, do you know how many are referenced
> > > without the &?
> > I got over 95000 (not checked in detail, though).
> 
> Thanks.
> 
> I think that ~25+:1 ratio makes a good case for an
> eventual conversion of the remaining uses.

OK, I will try to look into it sometime soon.

> > > If what is desired is kernel wide consistent use, yes.
> > > What I would like is file/subsystem consistent use.
> > > 
> > > Looking at sysctl.c and seeing that different use
> > > stand out was odd.
> > 
> > It would be possible to count the number of occurrences in a given file, 
> > and then change the ones that have the less popular format, or a format 
> > that occurs less than some percentage of time.
> 
> Maybe it'd be useful to add a coccinelle/spatch
> directory in scripts and add these scripts so
> that files and subsystems can updated over time.
> 
> I can not find a directory of coccinelle input
> scripts for linux at:
> http://coccinelle.lip6.fr/download.php
> Is there a list somewhere?

At the bottom of the download page there is a tool called coccicheck that 
runs Coccinelle on a set of semantic patches.  It comes with a set of 
examples.

http://coccinelle.lip6.fr/distrib/coccicheck-0.1.tgz

julia

> Perhaps add a checkpatch test as well though
> that might be an interesting test to write in
> perl.
> 
> 
> 
