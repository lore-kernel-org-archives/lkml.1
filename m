Return-Path: <linux-kernel-owner+w=401wt.eu-S1757718AbXFSLHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757718AbXFSLHE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 07:07:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754895AbXFSLGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 07:06:55 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:47881 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbXFSLGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 07:06:54 -0400
Message-ID: <4677B8C5.4020100@s5r6.in-berlin.de>
Date: Tue, 19 Jun 2007 13:06:45 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Natalie Protasevich <protasnb@gmail.com>
CC: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@ec.gc.ca>,
       Martin Bligh <mbligh@mbligh.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Adrian Bunk <bunk@stusta.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Oleg Verych <olecom@flower.upol.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: How to improve the quality of the kernel?
References: <alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org>	 <20070617115258.1f55b29d.akpm@linux-foundation.org>	 <200706172349.08813.bzolnier@gmail.com>	 <4675C083.6080409@s5r6.in-berlin.de>	 <20070617220927.99ebc1ee.akpm@linux-foundation.org>	 <F1D642E5A91BC94D9504EC83AE19E6B0128A0D@ecqcmtlmail3.quebec.int.ec.gc.ca>	 <32209efe0706181531x5322533dr31dc90e6dd8c7973@mail.gmail.com>	 <46770A22.4020007@mbligh.org>	 <32209efe0706181556l2ed378f4sf520c3852f398fa4@mail.gmail.com>	 <F1D642E5A91BC94D9504EC83AE19E6B0128A11@ecqcmtlmail3.quebec.int.ec.gc.ca> <32209efe0706181927w1f346dd3x33641c054f8100cf@mail.gmail.com>
In-Reply-To: <32209efe0706181927w1f346dd3x33641c054f8100cf@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Natalie Protasevich wrote:
> On 6/18/07, Fortier,Vincent [Montreal] <Vincent.Fortier1@ec.gc.ca> wrote:
[...]
>> In the end plenty of statistics and hardware compatibility list
>> could be made.  For example, that would make my life easier knowing
>> what level of compatibility Linux can offer for old HP9000 K-boxes
>> that we still have running at the office and presumably get people
>> to contact to get help?
> 
> This is definitely something that can be done (and should) - well,
> especially having ability search by certain criteria - then all sorts
> of statistics and databases can be created.

Hardware Compatibility Lists/ Databases already exist, for driver
subsystems, for distributions...

Some issues with those databases are:

  - Users typically can only test one specific combination of a
    hardware collection and software collection, at one or a few points
    in time.

  - Users have difficulties or don't have the means to identify chip
    revisions, used protocols etc.

  - The databases are typically not conceived to serve additional
    purposes like bidirectional contact between developer and user.

These issues notwithstanding, these databases are already highly useful
both for endusers and for developers.  That's why they exist.

> Everything that helps  to find a way to work on a patch and to test
> easier should be done to make bug fixing easier and even possible.
> Often times the most knowledgeable people are not able to make quick
> fix just because there is no way to reproduce the case or get access
> to HW.

As has been mentioned elsewhere in the thread,

  - bug---hardware associations are sometimes difficult or impossible
    to make.  For example, the x86-64 platform maintainers are bothered
    with "x86-64 bugs" which turn out to be driver bugs on all
    platforms.

    (We want details descriptions of the hardware environment in a bug
    report, but this means we must be able to handle the flood of
    false positives in bug---hardware associations, i.e. successively
    narrow down which parts of the hardware/software combo are actually
    affected, and what other combinations could be affected too.)

  - Patch---hardware associations, especially for preemptive regression
    tests, are virtually impossible to make.  Murphy says that the
    regression will hit hardware which the patch submitter or forwarder
    thought could never be affected by the patch.

Of course, /sensible/ patch---hardware associations are (1) to try out
fixes for known issues with a specific hardware, (2) to test that a
cleanup patch or refactoring patch or API changing patch to a driver of
very specific hardware ( = a single type or few types with little
variance) does not introduce regressions for this hardware.
-- 
Stefan Richter
-=====-=-=== -==- =--==
http://arcgraph.de/sr/
