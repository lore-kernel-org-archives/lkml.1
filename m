Return-Path: <linux-kernel-owner+w=401wt.eu-S1753374AbZDOSL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbZDOSL1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 14:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752404AbZDOSLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 14:11:17 -0400
Received: from mga14.intel.com ([143.182.124.37]:53561 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752366AbZDOSLQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 14:11:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,193,1239001200"; 
   d="scan'208";a="131834249"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Date: Wed, 15 Apr 2009 11:12:50 -0700
Subject: RE: 2.6.29 git master and PAT problems
Thread-Topic: 2.6.29 git master and PAT problems
Thread-Index: Acm98hmojeTGRYMBQBmfX7jDFAYDTgAAzBrQ
Message-ID: <7E82351C108FA840AB1866AC776AEC46587162E6@orsmsx505.amr.corp.intel.com>
References: <200903302317.04515.a.miskiewicz@gmail.com>
 <20090408081711.GA4938@elte.hu>
 <20090408223716.GC3493@linux-os.sc.intel.com>
 <200904151945.56411.a.miskiewicz@gmail.com>
In-Reply-To: <200904151945.56411.a.miskiewicz@gmail.com>
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

 

>-----Original Message-----
>From: Arkadiusz Miskiewicz [mailto:a.miskiewicz@gmail.com] 
>Sent: Wednesday, April 15, 2009 10:46 AM
>To: Pallipadi, Venkatesh
>Cc: Ingo Molnar; Thomas Gleixner; H. Peter Anvin; Siddha, 
>Suresh B; linux-kernel@vger.kernel.org; Jesse Barnes
>Subject: Re: 2.6.29 git master and PAT problems
>
>On Thursday 09 of April 2009, Pallipadi, Venkatesh wrote:
>> On Wed, Apr 08, 2009 at 01:17:11AM -0700, Ingo Molnar wrote:
>> > * Arkadiusz Miskiewicz <a.miskiewicz@gmail.com> wrote:
>> > > On Wednesday 08 of April 2009, Pallipadi, Venkatesh wrote:
>> > > > On Tue, Apr 07, 2009 at 02:12:28AM -0700, Arkadiusz 
>Miskiewicz wrote:
>> > > > > On Tuesday 07 of April 2009, Pallipadi, Venkatesh wrote:
>> > > > > > On Thu, 2009-04-02 at 00:12 -0700, Arkadiusz 
>Miskiewicz wrote:
>> > > > > >
>> > > > > > I was finally able to reproduce the problem of 
>"freeing invalid
>> > > > > > memtype" with upstream git kernel (commit 
>0221c81b1b) + latest
>> > > > > > xf86 intel driver. But, with upstream + the patch 
>I had sent you
>> > > > > > earlier in this thread
>> > > > > > 
>(http://marc.info/?l=linux-kernel&m=123863345520617&w=2) I don't
>> > > > > > see those freeing invalid memtype errors anymore.
>> > > > > >
>> > > > > > Can you please double check with current git and 
>that patch and
>> > > > > > let me know if you are still seeing the problem.
>> > > > >
>> > > > > Latest linus tree + that patch (it's really applied 
>here), xserver
>> > > > > 1.6, libdrm from git master, intel driver from git master,
>> > > > > previously mesa 7.4 (and 7.5 snap currently), 
>tremolous.net 1.1.0
>> > > > > game (tremolous-smp binary), GM45 gpu.
>> > > > >
>> > > > > To reproduce I just need to run tremolous-smp and 
>connect to some
>> > > > > map. When map finishes loading I instantly get:
>> > >
>> > > [...]
>> > >
>> > > > OK. One more test patch below, applies over linus's 
>git and you can
>> > > > ignore the earlier patch. The patch below should get rid of the
>> > > > problem and as it removes the track/untrack of vm_insert_pfn
>> > > > completely. This will also eliminate the overhead of 
>hundreds or
>> > > > thousands of entries in pat_memtype_list. Can you 
>please test it.
>> > >
>> > > With this patch I'm no longer able to reproduce problem. Thanks!
>> >
>> > Great, thanks!
>> >
>> > Venki, mind sending a patch with a proper changelog, Reported-by,
>> > Tested-by tags, with Nick and Andrew Cc:-ed for the memory.c bits,
>> > etc.?
>>
>> Ingo,
>>
>> Below is the cleaner version of the patch. It does not have 
>any changes in
>> mm as we are only removing the tracking inside the PAT code. 
>I have left
>> the generic mm interface as is, until we fully resolve the 
>issue in future.
>>
>> Thanks,
>> Venki
>>
>> Subject: [PATCH] x86, PAT: Remove page granularity tracking for
>> vm_insert_pfn maps
>
>I wonder what's with these patches that they missed rc2 ?
>
>This one and Subject: [PATCH] x86, PAT: Remove duplicate 
>memtype reserve in 
>pci mmap
>

I do see the above patch in rc2. Here
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=5a3ae276057840f0e60664c12fc3ef80aa59d1d4

But, the patch below has not yet made it.
http://marc.info/?l=linux-kernel&m=123923026401648&w=2

Ingo: Can you push this along?

Thanks,
Venki