Return-Path: <linux-kernel-owner+w=401wt.eu-S1752784AbYLIGza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbYLIGza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 01:55:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbYLIGzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 01:55:17 -0500
Received: from nn7.de ([85.214.94.156]:52612 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673AbYLIGzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 01:55:16 -0500
Subject: Re: [Bug #11698] 2.6.27-rc7, freezes with &gt; 1 s2ram cycle
From: Soeren Sonnenburg <kernel@nn7.de>
To: "Rafael J\. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <200812081940.53840.rjw@sisk.pl>
References: <49ZBswjGjrL.A.ECE.BGyNJB@chimera>
	 <200812072116.08218.rjw@sisk.pl> <1228753843.3935.10.camel@localhost>
	 <200812081940.53840.rjw@sisk.pl>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 09 Dec 2008 07:55:04 +0100
Message-Id: <1228805704.3918.23.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-08 at 19:40 +0100, Rafael J. Wysocki wrote:
> On Monday, 8 of December 2008, Soeren Sonnenburg wrote:
> > On Sun, 2008-12-07 at 21:16 +0100, Rafael J. Wysocki wrote:
> > > On Thursday, 4 of December 2008, Soeren Sonnenburg wrote:
> > > > On Wed, 2008-12-03 at 23:40 +0100, Rafael J. Wysocki wrote:
> > > > > This message has been generated automatically as a part of a report
> > > > > of regressions introduced between 2.6.26 and 2.6.27.
> > > > > 
> > > > > The following bug entry is on the current list of known regressions
> > > > > introduced between 2.6.26 and 2.6.27.  Please verify if it still should
> > > > > be listed and let me know (either way).
> > > > > 
> > > > > 
> > > > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11698
> > > > > Subject		: 2.6.27-rc7, freezes with &gt; 1 s2ram cycle
> > > > > Submitter	: Soeren Sonnenburg <kernel@nn7.de>
> > > > > Date		: 2008-09-29 11:29 (66 days old)
> > > > > References	: http://marc.info/?l=linux-kernel&m=122268780926859&w=4
> > > > > Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>
> > > > 
> > > > well it freezes at any s2ram resume attempt, even without X just from
> > > > console.
> > > 
> > > There are quite some things you can try.
> > > 
> > > First, it would be helpful to verify if it also fails in the minimal
> > > configuration, ie. when booted with init=/bin/bash, as described
> > > in Documentation/power/basic-pm-debugging.txt under
> > > "Testing minimal configuration".
> > 
> > OK, I've found the problem:
> > 
> > 1. it does work with init=/bin/bash
> > 2. it did not work after doing a binary search in the modules, even
> > removing all modules did not help
> > 3. I figured out that it only happens when I update the CPU's microcode,
> > (booting with init=/bin/bash and /etc/init.d/microcode.ctl start
> > triggers it)
> > 
> > Even better: s2ram always gave me my display back when s2ram under
> > console.
> > 
> > Now I wonder if this is Bug #12100 ?
> 
> Well, that's quite likely.
> 
> > Unfortunately I need the microcode update, as I am suffering from
> > a) PAT WC disabled due to known CPU erratum.
> > b) coretemp coretemp.0: Errata AE18 not fixed, update BIOS or microcode of the CPU!
> > 
> > Anyway I now have a chance to test whether #11698 still occurs.
> 
> Hm, #11698 is the $subject bug.  Did you mean some other bug?

No, I meant this one (but it says freezes with > 1 s2ram cycle, which
was supposed to say: when working for days or hours but having s2ram'd
at least once the machine might freeze at some point)

Soeren
