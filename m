Return-Path: <linux-kernel-owner+w=401wt.eu-S932597AbYDOVL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932597AbYDOVL0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 17:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758629AbYDOVLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 17:11:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:26687 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758505AbYDOVLI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 17:11:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,661,1199692800"; 
   d="scan'208";a="317380092"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [Bug #10117] 2.6.25-current-git sometimes hangs on boot - dual-core Sony Vaio
Date: Tue, 15 Apr 2008 14:09:27 -0700
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEEE17FD4@orsmsx423.amr.corp.intel.com>
In-Reply-To: <200804152303.45320.rjw@sisk.pl>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Bug #10117] 2.6.25-current-git sometimes hangs on boot - dual-core Sony Vaio
Thread-Index: AcifPCt55uTIvClcTCCW2+L4YnYEMAAAG9QQ
References: <RR4Oy_oXY2J.A.b0H.A3lAIB@albercik> <200804152233.39079.rjw@sisk.pl> <20080415204500.GD1677@cs181133002.pp.htv.fi> <200804152303.45320.rjw@sisk.pl>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, "Adrian Bunk" <bunk@kernel.org>
Cc: "Carlos R. Mafra" <crmafra2@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Soeren Sonnenburg" <kernel@nn7.de>
X-OriginalArrivalTime: 15 Apr 2008 21:07:08.0649 (UTC) FILETIME=[AA71AD90:01C89F3C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Rafael J. Wysocki [mailto:rjw@sisk.pl] 
>Sent: Tuesday, April 15, 2008 2:04 PM
>To: Adrian Bunk
>Cc: Carlos R. Mafra; Linux Kernel Mailing List; Soeren 
>Sonnenburg; Pallipadi, Venkatesh
>Subject: Re: [Bug #10117] 2.6.25-current-git sometimes hangs 
>on boot - dual-core Sony Vaio
>
>On Tuesday, 15 of April 2008, Adrian Bunk wrote:
>> On Tue, Apr 15, 2008 at 10:33:38PM +0200, Rafael J. Wysocki wrote:
>> > On Tuesday, 15 of April 2008, Carlos R. Mafra wrote:
>> > > On Sun 13.Apr'08 at 17:25:45 -0300, Carlos R. Mafra wrote:
>> > > > On Sun 13.Apr'08 at 20:56:41 +0200, Rafael J. Wysocki wrote:
>> > > > > This message has been generated automatically as a 
>part of a report
>> > > > > of recent regressions.
>> > > > > 
>> > > > > The following bug entry is on the current list of 
>known regressions
>> > > > > from 2.6.24.  Please verify if it still should be listed.
>> > > > > 
>> > > > > 
>> > > > > Bug-Entry	: 
>http://bugzilla.kernel.org/show_bug.cgi?id=10117
>> > > > > Subject		: 2.6.25-current-git sometimes 
>hangs on boot - dual-core Sony Vaio
>> > > > > Submitter	: Soeren Sonnenburg <kernel@nn7.de>
>> > > > > Date		: 2008-02-23 18:55 (51 days old)
>> > > > > References	: http://lkml.org/lkml/2008/2/23/263
>> > > > > 		  http://lkml.org/lkml/2008/4/4/41
>> > > > > 		  http://lkml.org/lkml/2008/4/9/69
>> > > > 
>> > > > Soeren said it no longer happens to him in 
>http://lkml.org/lkml/2008/4/9/53
>> > > > but unfortunately it still happens with me using -rc9. 
>So I kidnapped his 
>> > > > bugzilla report :-)
>> > > > 
>> > > > In the bugzilla entry I said earlier today that 
>"hpet=disable" apparently
>> > > > makes the problem go away (42 boots OK so far, whereas 
>without this
>> > > > boot option it hangs ~90% using vga=6 and ~10% using 
>vga=0x0364)
>> > > > 
>> > > > I tried to bisect it, but sometimes in pre 2.6.25-rc1 
>kernels it takes
>> > > > 30 boots before the first hang to occur. So bisection 
>is not reliable...
>> > > > 
>> > > > If someone proposes a patch I will be glad to test it!
>> > > > 
>> > > > PS: The similar bug in buzilla 10377 also appears to be "fixed"
>> > > > by using hpet=disable, see comment #17 in that bug.
>> > > 
>> > > 
>> > > From what Mark Lord said in his comments #33 to #35 in 
>> > > http://bugzilla.kernel.org/show_bug.cgi?id=10117
>> > > it appears that this is a much older regression, from april 2007.
>> > > 
>> > > So this is a regression, but not from 2.6.24 (although somehow
>> > > it never hit me before). I don't know about the policy of closing
>> > > regressions that come from way before the previous 
>kernel version, 
>> > > if there is any. Then I will let you manage the bugzilla #10117
>> > > as you see fit (but I will be "there" to hopefuly test any 
>> > > proposed patches).
>> > 
>> > I dropped the bug from the list of recent regressions, so 
>it doesn't block
>> > bug #9832 any more.  However, this still is a bug and 
>regression, so the
>> > bugzilla entry remains open.
>> 
>> Soerens original report was a 2.6.25 regression.
>> 
>> And #10377 that was closed as a duplicate of #10117 was also 
>reported as 
>> a 2.6.25 regression.
>> 
>> #10117 seems to suffer from the common disease of people 
>hijacking an 
>> existing bug, but Soeren's issue that was what was 
>originally tracked in 
>> #10117 is (or was) a 2.6.25 regression.
>
>Well, I'm really not 100% sure it was a regression from 2.6.24 
>and I'm not
>sure bug #10377 should have been marked as a duplicate.
>
>I made bug #10117 block bug #9832 again, but it would be nice 
>to sort this out.
>
>Why do we think that the cause of bugs #10117 and #10377 is the same?
>
>Rafael
>

Both of them probabilistically hang early in the boot.
On both !CPUIDLE and hpet=disable seems to be working around the
problem.
Both are Core 2 Duo based with 64 bit kernel.

One difference I saw was that #10377 fails on battery. That may be
because when on battery CPUs may be running at lower freq during boot
and that is probably helping this problem in terms of timing.

Thanks,
Venki
