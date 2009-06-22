Return-Path: <linux-kernel-owner+w=401wt.eu-S1757591AbZFVRX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591AbZFVRX2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 13:23:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbZFVRXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 13:23:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:50569 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891AbZFVRXT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 13:23:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,269,1243839600"; 
   d="scan'208";a="468527960"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: "mingo@elte.hu" <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lenb@kernel.org" <lenb@kernel.org>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>
Date: Mon, 22 Jun 2009 10:25:43 -0700
Subject: RE: [patch 1/2] x86: Add pm_play_dead funcptr to power-efficiently
 offline CPUs
Thread-Topic: [patch 1/2] x86: Add pm_play_dead funcptr to power-efficiently
 offline CPUs
Thread-Index: Acnbk4iUaqxMINc7TgqQ5iHNaS93SAAIkIEABeoQUiA=
Message-ID: <7E82351C108FA840AB1866AC776AEC46695A3789@orsmsx505.amr.corp.intel.com>
References: <20090522231940.553094000@intel.com>
	 <20090522232230.020301000@intel.com> <1243075498.6582.1049.camel@laptop> 
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

 

>From: Pallipadi, Venkatesh 
>>From: Peter Zijlstra [mailto:a.p.zijlstra@chello.nl] 
>>On Fri, 2009-05-22 at 16:19 -0700, 
>venkatesh.pallipadi@intel.com wrote:
>>> plain text document attachment
>>> (0001-x86-Add-pm_play_dead-funcptr-to-power-efficiently-o.patch)
>>> Add a funcptr pm_play_dead (similar to pm_idle) that can take
>>> the offline CPUs to the most power efficient idle state.
>>> 
>>> This patch just adds the func pointer. The pointer will get 
>>initialized
>>> by patch that follows.
>>
>>Since the pm_idle function pointer has given us so much grief, I don't
>>think its wise to repeat that particular disaster.
>>
>>I'd much rather see a framework where idle functions can be 
>registered,
>>and selected from based on criteria such as wakeup latency as provided
>>by the pm_qos stuff, and power saving.
>>
>>This framework should be shared between hotplug-idle and the regular
>>idle routines. Hotplug would of course not care about things 
>>like wakeup
>>latency and might therefore pick another idle routine.
>>
>
>Yes. Thought about that approach. There are issues with that 
>approach however.
>- It would be ugly as we have to add logic in various low 
>level idle handlers we have today mwait_idle, default_idle, 
>acpi_mwait_idle, acpi_ioport_idle to make them aware of 
>offline idle case and disable interrupt and not enable 
>interrupt while going idle and not to wake up on interrupt.
>- There are limitations on what we can and cannot do when 
>offline. We have had issues with calling acpi methods and/or 
>IO port accesses, during suspend before, so CPU going on 
>suspend only uses C1. Specifically, with the above approach we 
>will have:
>1) CPU 1 going offline and starts using regular ACPI IO port C-states.
>2) CPU 0 starts suspend and after some points it is unsafe to 
>access ACPI io port accesses, which can potentially result in 
>crash/hangs.
>
>So, I would like to keep ACPI out of play_dead. And keeping 
>idle and play_dead separate seemed to be cleaner way to do it.
>

Peter,

Any more comments on this approach? As I mentioned above, from my POV,
it is simpler and cleaner to keep ACPI out of the CPU offline path.
Do you agree?

Thanks,
Venki