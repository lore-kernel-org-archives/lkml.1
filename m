Return-Path: <linux-kernel-owner+w=401wt.eu-S1760936AbYFPIZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760936AbYFPIZV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 04:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755385AbYFPIZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 04:25:00 -0400
Received: from relay2.sgi.com ([192.48.171.30]:54234 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755092AbYFPIZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 04:25:00 -0400
Date: Mon, 16 Jun 2008 03:24:57 -0500
From: Paul Jackson <pj@sgi.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: mingo@elte.hu, tglx@linutronix.de, yhlu.kernel@gmail.com, steiner@sgi.com,
       travis@sgi.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, akpm@linux-foundation.org
Subject: Re: [PATCH 4/8] x86 boot: allow overlapping ebda and efi memmap
 memory ranges
Message-Id: <20080616032457.718f4d87.pj@sgi.com>
In-Reply-To: <1213600062.11185.13.camel@caritas-dev.intel.com>
References: <20080616062945.14597.78009.sendpatchset@polaris-admin.engr.sgi.com>
	<20080616063001.14597.96170.sendpatchset@polaris-admin.engr.sgi.com>
	<1213600062.11185.13.camel@caritas-dev.intel.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang wrote:
>  I think it is better to change boot loader to avoid memory area of EBDA.

Would this require the bootloader to know the kernels rather arbitrary
heuristics for inventing and placing an EBDA area, in reserve_ebda_region()?

In general, I would think it better not to have to code into the EFI
firmware or bootloader such knowledge.  But perhaps I am wrong here.

If the kernel is going to reserve an EBDA region even if no EBDA is
requested by the BIOS, then I would think that the kernel should be
more tolerant of BIOS's that put something else in that place.

> Or do not reserve EBDA on EFI system.

I suppose.  This would have been a bigger change than I could
suggest.  For all I know, there are existing systems using EBDA
and EFI together.  Would this change break them?

If you have good reason to know that's essentially impossible then
I have no objections, so far as my needs go, to not reserving EBDA
on EFI systems.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
