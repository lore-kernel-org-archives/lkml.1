Return-Path: <linux-kernel-owner+w=401wt.eu-S1754580Ab0AMCPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab0AMCPO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 21:15:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753891Ab0AMCPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 21:15:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:33911 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753578Ab0AMCPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 21:15:11 -0500
Message-ID: <4B4D2C44.2060709@kernel.org>
Date: Tue, 12 Jan 2010 18:13:24 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       "ananth@in.ibm.com" <ananth@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v2 5/5] x86: use dmi check to treat disabled cpus as
 hotplug cpus.
References: <1263338274-6485-1-git-send-email-yinghai@kernel.org>	 <1263338274-6485-5-git-send-email-yinghai@kernel.org>	 <1263340563.2854.1011.camel@sbs-t61.sc.intel.com>	 <4B4D0E39.10200@kernel.org>	 <1263347315.2854.1296.camel@sbs-t61.sc.intel.com>	 <4B4D2811.7000001@kernel.org> <1263348363.2854.1360.camel@sbs-t61.sc.intel.com>
In-Reply-To: <1263348363.2854.1360.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2010 06:06 PM, Suresh Siddha wrote:
> On Tue, 2010-01-12 at 17:55 -0800, Yinghai Lu wrote:
>> you mean this blacklist could be too long?
> 
> yes.
> 
>>
>> switch to whitelist for the box can treat disabled cpus as hotplug
>> cpus?
> 
> Do we really need all this? Systems which support physical hotplug
> typically have lot's of cpu's (mostly will have atleast > 8). Even if we
> really need to identify, then perhaps we can check if ACPI has any hints
> regarding the physical hotplug support at boot time (we should check
> with Andi Kleen or Len Brown on this).
> 
> For now, I think we can keep it simple by using the detected enabled
> cpu's.

sth like this ?

---
 arch/x86/kernel/smpboot.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6/arch/x86/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6/arch/x86/kernel/smpboot.c
@@ -1190,7 +1190,6 @@ early_param("possible_cpus", _setup_poss
  * - Ashok Raj
  *
  * Three ways to find out the number of additional hotplug CPUs:
- * - If the BIOS specified disabled CPUs in ACPI/mptables use that.
  * - The user can overwrite it with possible_cpus=NUM
  * - Otherwise don't reserve additional CPUs.
  * We do this because additional CPUs waste a lot of memory.
@@ -1205,7 +1204,7 @@ __init void prefill_possible_map(void)
 		num_processors = 1;
 
 	if (setup_possible_cpus == -1)
-		possible = num_processors + disabled_cpus;
+		possible = num_processors;
 	else
 		possible = setup_possible_cpus;
 
