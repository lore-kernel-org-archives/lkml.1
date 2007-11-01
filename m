Return-Path: <linux-kernel-owner+w=401wt.eu-S1758628AbXKARjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628AbXKARjd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 13:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756774AbXKARjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 13:39:08 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:32918 "EHLO
	outbound1-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756445AbXKARjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 13:39:06 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: DF9F24A0-1A5C-40A5-8B0A-DEB676E72ECF
Date: Thu, 1 Nov 2007 18:35:43 +0100
From: "Andreas Herrmann3" <andreas.herrmann3@amd.com>
To: "Glauber de Oliveira Costa" <gcosta@redhat.com>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       akpm@linux-foundation.org, travis@sgi.com
Subject: Re: [PATCH] x86: show cpuinfo only for online CPUs
Message-ID: <20071101173543.GB5568@alberich.amd.com>
References: <20071101170206.GA7820@alberich.amd.com>
 <472A08F9.8060605@redhat.com>
MIME-Version: 1.0
In-Reply-To: <472A08F9.8060605@redhat.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 01 Nov 2007 17:35:43.0701 (UTC)
 FILETIME=[A10DB850:01C81CAD]
X-WSS-ID: 6B34D1F807S1105732-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2007 at 03:12:25PM -0200, Glauber de Oliveira Costa wrote:
> did you test it in a kernel without SMP compiled in ?
> 
> I'm a little afraid about what can happen here:

No I didn't, but should have done so - cpu_index exists only
in the SMP case ...

I'll come up with a corrected fix (adding some ifdefs).

> The attribuition of cpu_index only happens in a code that seems to be
> called for all cpus but the boot one.

Yes, just in identify_cpu and not in its "early_" variant.

> So it could even work, but as accident. Unless I'm wrong about it, I'd
> prefer to see an explicit attribution of cpu_index = 0 somewhere for the
> boot cpu.

Hmm, will look at this as well.

> Other than that, good catch! I didn't notice it, because all my present
> cpus were online in my box

You might be able to trigger it by using additional_cpus=<n> in your kernel
command line.
A second test is offlining a CPU: Then cpuinfo was still shown for the
offlined CPU.


Regards,

Andreas

-- 
Operating | AMD Saxony Limited Liability Company & Co. KG,
  System  | Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 Research | Register Court Dresden: HRA 4896, General Partner authorized
  Center  | to represent: AMD Saxony LLC (Wilmington, Delaware, US)
  (OSRC)  | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy



