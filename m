Return-Path: <linux-kernel-owner+w=401wt.eu-S1751454AbYLHSDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454AbYLHSDr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 13:03:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750761AbYLHSDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 13:03:37 -0500
Received: from nn7.de ([85.214.94.156]:35514 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbYLHSDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 13:03:37 -0500
Subject: Re: [Bug #11698] 2.6.27-rc7, freezes with &gt; 1 s2ram cycle
From: Soeren Sonnenburg <kernel@nn7.de>
To: "Rafael J\. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <200812072116.08218.rjw@sisk.pl>
References: <49ZBswjGjrL.A.ECE.BGyNJB@chimera>
	 <TpbYvO5GPt.A.nTF.2GyNJB@chimera> <1228373948.3927.39.camel@localhost>
	 <200812072116.08218.rjw@sisk.pl>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 08 Dec 2008 17:30:43 +0100
Message-Id: <1228753843.3935.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-12-07 at 21:16 +0100, Rafael J. Wysocki wrote:
> On Thursday, 4 of December 2008, Soeren Sonnenburg wrote:
> > On Wed, 2008-12-03 at 23:40 +0100, Rafael J. Wysocki wrote:
> > > This message has been generated automatically as a part of a report
> > > of regressions introduced between 2.6.26 and 2.6.27.
> > > 
> > > The following bug entry is on the current list of known regressions
> > > introduced between 2.6.26 and 2.6.27.  Please verify if it still should
> > > be listed and let me know (either way).
> > > 
> > > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11698
> > > Subject		: 2.6.27-rc7, freezes with &gt; 1 s2ram cycle
> > > Submitter	: Soeren Sonnenburg <kernel@nn7.de>
> > > Date		: 2008-09-29 11:29 (66 days old)
> > > References	: http://marc.info/?l=linux-kernel&m=122268780926859&w=4
> > > Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > well it freezes at any s2ram resume attempt, even without X just from
> > console.
> 
> There are quite some things you can try.
> 
> First, it would be helpful to verify if it also fails in the minimal
> configuration, ie. when booted with init=/bin/bash, as described
> in Documentation/power/basic-pm-debugging.txt under
> "Testing minimal configuration".

OK, I've found the problem:

1. it does work with init=/bin/bash
2. it did not work after doing a binary search in the modules, even
removing all modules did not help
3. I figured out that it only happens when I update the CPU's microcode,
(booting with init=/bin/bash and /etc/init.d/microcode.ctl start
triggers it)

Even better: s2ram always gave me my display back when s2ram under
console.

Now I wonder if this is Bug #12100 ?
Unfortunately I need the microcode update, as I am suffering from
a) PAT WC disabled due to known CPU erratum.
b) coretemp coretemp.0: Errata AE18 not fixed, update BIOS or microcode of the CPU!

Anyway I now have a chance to test whether #11698 still occurs.

Soeren
