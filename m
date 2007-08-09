Return-Path: <linux-kernel-owner+w=401wt.eu-S935895AbXHIBOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935895AbXHIBOB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 21:14:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756197AbXHIBNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 21:13:50 -0400
Received: from mailhub2.otago.ac.nz ([139.80.64.247]:59245 "EHLO
	mailhub2.otago.ac.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbXHIBNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 21:13:49 -0400
X-Greylist: delayed 922 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Aug 2007 21:13:49 EDT
Message-ID: <46BA6667.1070205@maths.otago.ac.nz>
Date: Thu, 09 Aug 2007 12:57:11 +1200
From: Greg Trounson <gregt@maths.otago.ac.nz>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
References: <20070804103347.GA1956@elte.hu> <alpine.LFD.0.999.0708040915360.5037@woody.linux-foundation.org> <20070804163733.GA31001@elte.hu> <alpine.LFD.0.999.0708041030040.5037@woody.linux-foundation.org> <46B4C0A8.1000902@garzik.org> <20070804191205.GA24723@lazybastard.org> <20070804192130.GA25346@elte.hu> <20070804211156.5f600d80@the-village.bc.nu> <20070804202830.GA4538@elte.hu> <20070804224834.5187f9b7@the-village.bc.nu> <20070805071320.GC515@elte.hu>
In-Reply-To: <20070805071320.GC515@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
>>>> People just need to know about the performance differences - very 
>>>> few realise its more than a fraction of a percent. I'm sure Gentoo 
>>>> will use relatime the moment anyone knows its > 5% 8)
>>> noatime,nodiratime gave 50% of wall-clock kernel rpm build 
>>> performance improvement for Dave Jones, on a beefy box. Unless i 
>>> misunderstood what you meant under 'fraction of a percent' your 
>>> numbers are _WAY_ off.
>> What numbers - I didn't quote any performance numbers ?
> 
> ok, i misunderstood your "very few realise its more than a fraction of a 
> percent" sentence, i thought you were saying it's a fraction of a 
> percent.
> 
> Measurements show that noatime helps 20-30% on regular desktop 
> workloads, easily 50% for kernel builds and much more than that (in 
> excess of 100%) for file-read-intense workloads. We cannot just walk 
> past such a _huge_ performance impact so easily without even reacting to 
> the performance arguments, and i'm happy Ubuntu picked up 
> noatime,nodiratime and is whipping up the floor with Fedora on the 
> desktop.
> 

Sorry I'm just not seeing those gains here.  With my filesystems mounted with atime 
defaults the Quake sources build in 1m28.856s.  A test with ls -ltu verifies that atime is 
working as expected.  When I remount my filesystems with:
mount [fs] -o remount,noatime,nodiratime
I get a compile time of 1m23.368s, a mere 6% improvement.

This is on a dual-core Athlon 4200+ box running 2.6.21, so I would have thought this to be 
close to a best-case file I/O test.

Greg
