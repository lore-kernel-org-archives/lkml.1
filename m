Return-Path: <linux-kernel-owner+w=401wt.eu-S1755164AbYDUIEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164AbYDUIEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 04:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753316AbYDUIEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 04:04:09 -0400
Received: from rs35.luxsci.com ([66.216.127.90]:44392 "EHLO rs35.luxsci.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172AbYDUIEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 04:04:08 -0400
Message-ID: <480C4A35.7000109@firmworks.com>
Date: Sun, 20 Apr 2008 22:03:01 -1000
From: Mitch Bradley <wmb@firmworks.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Andres Salomon <dilinger@queued.net>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Joseph Fannin <jfannin@gmail.com>, linux-kernel@vger.kernel.org,
       jordan.crouse@amd.com
Subject: Re: [PATCH 1/2] OLPC: Add support for calling into Open Firmware
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org>	 <20080419031024.GC3503@nineveh.local>	 <20080418202925.b18452c5.akpm@linux-foundation.org>	 <20080419092544.378664a8@ephemeral>	 <20080419133909.5aa6b63e@ephemeral>	 <86802c440804200334t5cdcd100rfc41e9b1bf379109@mail.gmail.com>	 <480C0582.9010509@firmworks.com>	 <86802c440804202015h2605eff7vc733874dd1f22261@mail.gmail.com>	 <480C1286.3040307@firmworks.com> <86802c440804202150l535519c9mcb635c7ca55216ed@mail.gmail.com>
In-Reply-To: <86802c440804202150l535519c9mcb635c7ca55216ed@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Yinghai Lu wrote:
>> ...
>
> geode is using SMI to simulate the pci conf space, wonder that could be problem.
>   

On the current OLPC system, we don't use the SMI-based PCI config space 
simulator.  The code for that "VSA" module is only partially open 
sourced (some of it is open, and some of it is just not available).  The 
parts of it for which we do have source can only be compiled with an old 
proprietary toolchain that is no longer available.

Instead of using the SMI-based simulation, we have added a PCI 
configuration access method in the kernel that supplies the necessary 
information from a table.  The code for that hardware-specific access 
method is roughly 40 lines of code plus a few data tables.

In the past few weeks, I have developed a rather complete Open 
Firmware-based reimplementation of the SMI PCI config hardware 
emulator.   All-told, it requires over 1000 lines.  It remains to be 
seen whether the complicated version will ultimately be deployed.  
Personally, I find it distasteful to use a lot of code to make the 
hardware pretend that it is something other than what it really is, when 
a much smaller driver works just as well.  The SMI-based emulator is 
quite difficult to understand and maintain, because the Geode SMI 
handling mechanism is complex, incompletely documented, and suffers from 
many of the multiple-mode-switches problems as real-mode to 
protected-mode gateway code.

> later you have 64 runtime service for 64 platform like UEFI?
>   

Possibly.   64-bit systems are not a problem per se - there have been 
64-bit OFW implementations for 64-bit architectures like SPARC and Alpha 
dating back to a long time ago.  The main issue from my point of view is 
whether or not there is a customer to motivate the work.
> YH
>
>   
