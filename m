Return-Path: <linux-kernel-owner+w=401wt.eu-S1760072AbXEaE4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760072AbXEaE4a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 00:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757624AbXEaE4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 00:56:23 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:11352 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757576AbXEaE4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 00:56:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LcqpP6zPcpAX+uic+w7opRDX6U1MiNJkTj1o5gWLwJimxEAxwZsnHtARWxJ1V3vpYeynI/X9Lc+DBo3qzt6Qw/ezd6tpSuqPY2Z/2IhZAdn/7lCpPlyXqPfjbemeRxgffUlW1qZioJwDuBFl/V/qS9MbN8kWlYyhVbS6mNOThlk=
Message-ID: <86802c440705302156k37407e2eice027bef9c69bd9d@mail.gmail.com>
Date: Wed, 30 May 2007 21:56:21 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Robert Hancock" <hancockr@shaw.ca>
Subject: Re: Case: 7454422: Re: Kernel 2.6.21.3 does not work with 8GB of RAM on Intel 965WH motherboards. (FULL DMESG)
Cc: "Justin Piszcz" <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
       crmotherboard@mailbox.cps.intel.com
In-Reply-To: <465E08CD.2080302@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.t8TZNHj4vrYcIs37jScT0oZl02s@ifi.uio.no>
	 <fa.nsJ3dX+uNBCD7bTYffkYm0DLnR4@ifi.uio.no>
	 <fa.lfTXDj3RBbaCLDUJJFzLVowMlxc@ifi.uio.no>
	 <fa.lrZMTvBB9xwYW1mcA0nyYFjB9qY@ifi.uio.no>
	 <fa.AIUKY82rbgpQ/AiIxhRL0fahxaQ@ifi.uio.no>
	 <fa.yz+v/A2zkJKIswF0Y4Mo4FxwnCI@ifi.uio.no> <465E08CD.2080302@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/30/07, Robert Hancock <hancockr@shaw.ca> wrote:
> Justin Piszcz wrote:
> > That output looked nasty, attaching entries from syslog.
> >
> > Justin.
>
> Here's your E820 memory map, from dmesg:
>
> BIOS-e820: 0000000000000000 - 000000000008f000 (usable)
> BIOS-e820: 000000000008f000 - 00000000000a0000 (reserved)
> BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
> BIOS-e820: 0000000000100000 - 00000000cf58f000 (usable)
> BIOS-e820: 00000000cf58f000 - 00000000cf59c000 (reserved)
> BIOS-e820: 00000000cf59c000 - 00000000cf653000 (usable)
> BIOS-e820: 00000000cf653000 - 00000000cf6a5000 (ACPI NVS)
> BIOS-e820: 00000000cf6a5000 - 00000000cf6a8000 (ACPI data)
> BIOS-e820: 00000000cf6a8000 - 00000000cf6ef000 (ACPI NVS)
> BIOS-e820: 00000000cf6ef000 - 00000000cf6f1000 (ACPI data)
> BIOS-e820: 00000000cf6f1000 - 00000000cf6f2000 (usable)
> BIOS-e820: 00000000cf6f2000 - 00000000cf6ff000 (ACPI data)
> BIOS-e820: 00000000cf6ff000 - 00000000cf700000 (usable)
> BIOS-e820: 00000000cf700000 - 00000000d0000000 (reserved)
> BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
> BIOS-e820: 0000000100000000 - 000000022c000000 (usable)
>
> so the usable memory ranges are:
>
> 0-572K
> 1MB-3317.55MB
> 3317.60MB-3317.75MB
> 3318.94MB-3318.945MB
> 3318.996MB-3319MB
> 4096MB-8896MB
>
> and the MTRRs (from /proc/mtrr, from private email):
>
> reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
> reg01: base=0x80000000 (2048MB), size=1024MB: write-back, count=1
> reg02: base=0xc0000000 (3072MB), size= 256MB: write-back, count=1
> reg03: base=0xcf800000 (3320MB), size=   8MB: uncachable, count=1
> reg04: base=0xcf700000 (3319MB), size=   1MB: uncachable, count=1
> reg05: base=0x100000000 (4096MB), size=4096MB: write-back, count=1
> reg06: base=0x200000000 (8192MB), size= 512MB: write-back, count=1
> reg07: base=0x220000000 (8704MB), size= 128MB: write-back, count=1
>
> so the ranges mapped as cacheable are:
>
> 0-3319MB
> 4096-8832MB
>
> leaving 64MB of memory at the top of RAM uncached. What do you want to
> bet that something important (kernel code?) is getting loaded there..
>
> So essentially it's a BIOS problem, it's not setting up the MTRRs
> properly in order to map all of RAM as cacheable. As Andi says, complain
> to Intel.

the BIOS used up of VAR MTRR ( = 8).

it supposed change to sth like
> reg00: base=0x00000000 (   0MB), size=4096MB: write-back, count=1
> reg01: base=, size=64MB: uncachable, count=1
> reg02: base=, size=128MB: uncachable, count=1
> reg03: base=, size=512MB: uncachable, count=1
> reg04: base=0x100000000 (4096MB), size=4096MB: write-back, count=1
> reg05: base=0x200000000 (8192MB), size= 512MB: write-back, count=1
> reg06: base=0x220000000 (8704MB), size= 128MB: write-back, count=1
> reg07: base=(8832MB), size= 64MB: write-back, count=1

or you can set var mtrr and then use kexec to load another kernel.

AMD Rev F later cpu, will assume 4G above is write back, and even
without var mtrr for it.

YH
