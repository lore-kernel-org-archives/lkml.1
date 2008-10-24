Return-Path: <linux-kernel-owner+w=401wt.eu-S1757215AbYJXQXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215AbYJXQXe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 12:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753611AbYJXQXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 12:23:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:15644 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753008AbYJXQXC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 12:23:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,479,1220252400"; 
   d="scan'208";a="455178395"
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
To: Sanjoy Mahajan <sanjoy@MIT.EDU>
CC: Jesse Brandeburg <jesse.brandeburg@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       NetDEV list <netdev@vger.kernel.org>,
       "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
Date: Fri, 24 Oct 2008 09:22:58 -0700
Subject: RE: e1000e fails after several S3 resumes (2.6.26 Debian, TP T60) 
Thread-Topic: e1000e fails after several S3 resumes (2.6.26 Debian, TP T60) 
Thread-Index: Ack15FQf/7CxBWBVSgScUt4tzEo+uwAD9snw
Message-ID: <F169D4F5E1F1974DBFAFABF47F60C10A069DFFA0@orsmsx507.amr.corp.intel.com>
References: Your message of "Thu, 23 Oct 2008 15:42:55 PDT."
             <F169D4F5E1F1974DBFAFABF47F60C10A069DFD62@orsmsx507.amr.corp.intel.com>
 (sfid-20081023_194301_937814_89312B9F)  <E1KtNaz-0003Xx-0y@approx.mit.edu>
In-Reply-To: <E1KtNaz-0003Xx-0y@approx.mit.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sanjoy Mahajan wrote:
>> hm, does your kernel have CONFIG_PM defined?
> 
> It does have that defined:

ok
 
>> if it happens again please include lspci -vvv before and after
>> ethtool -r (see below)
> 
> I will.  Now I'm running BIOS 2.23, so I'm curious whether that
> 'upgrade' fixes the problem.
> 
> I say 'upgrade' because now S3 sleep and wakeup often take 60 seconds.
> I've also noticed ACPI errors in the 'dmesg'.  Once I have something
> reproducible I'll file a bugzilla report.

ick, it would be nice if the system vendors actually tested their acpi implementations on multiple OSes.
 
>> device was also claiming successfully transmitting, so I don't know
>> why the DHCP packets don't work, can you tcpdump on the network or
>> the dhcp server by chance?
> 
> I'll do that too on the next failure.  Is 'tcpdump host 18.38.0.1'
> sufficient or do I need a few -v switches?

I'm mostly looking for the conversation back and forth, so that should be fine.
Keep in mind that the first dhcp packet is usually a broadcast (not to a 
particular IP)
 
>> can you ifconfig eth0 promisc before doing suspend?  I'd be curious
>> if that fixed it.
> 
> If/when it reproduces, I'll add that line to the pre-suspend code.  (I
> use 's2ram', which I think sleeps with 'echo mem > /sys/power/state'
> and does a vt switch on wakeup).

okay, thanks
 
> Generally: For making debugging go smoothly, is it worth running a
> vanilla kernel rather than the Debian one?  I could try 2.6.26.7 or
> 2.6.27.3.  Is running 2.6.27.y not as useful as running 2.6.26.y, in
> case the bug is merely hidden but not solved in the new kernel?  On
> the other hand, I'm tempted to try 2.6.27.y in case it fixes the slow
> suspend/resume.

I think you should definitely try 2.6.27.y, the e1000e versions in the kernel 
are different than what is in ubuntu at least, so not sure if that applies to 
debian.