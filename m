Return-Path: <linux-kernel-owner+w=401wt.eu-S1752588AbXJWNb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbXJWNb7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 09:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbXJWNbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 09:31:52 -0400
Received: from mga07.intel.com ([143.182.124.22]:63664 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751781AbXJWNbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 09:31:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,317,1188802800"; 
   d="scan'208";a="303954861"
Message-ID: <471DF79B.20801@linux.intel.com>
Date: Tue, 23 Oct 2007 09:31:07 -0400
From: Anas Nashif <nashif@linux.intel.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Marek Dabek <marek.dabek@intel.com>
Subject: Re: [PATCH] Intel Manageability Engine Interface driver
References: <471CDC5E.4010300@linux.intel.com> <20071022114001.40470c15.akpm@linux-foundation.org>
In-Reply-To: <20071022114001.40470c15.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

Thanks for the feedback.

Andrew Morton wrote:
> On Mon, 22 Oct 2007 13:22:38 -0400 Anas Nashif <nashif@linux.intel.com> wrote:
>>
>> The patch is large so I'm placing the diff on the web for download
>> rather than attaching it here.  Download:
>>
>> http://download.openamt.org/intel-MEI.diff
> 
> Please get the patches mailed out somehow.  Consider splitting the patch
> up.  I think you could send it as-is (200k will fit, I believe) but it's
> rather too large to review effectively.
> 
> The code looks good from a quick scan.  Immediate impressions from a
> quick scan, mainly trivia:
> 

We will fix the issues below and send the revised patch to the list.

>
> 
> - Why does a new driver have "additional char device for legacy mode"?
> 

It is not quite new. What is currently considered legacy was supported 
on Linux with a driver that was never submitted upstream (although it is 
open-source and available from e1000.sf.net).
Some applications still use the legacy interface (KCS style) and have to 
be supported with the new driver as well.

(...)

> - The changelog could do with some expansion.  What is "Intel(R)
>   Manageability Engine (ME) firmware"?  Why do we want to include this code
>   in Linux?  What value has it to our users, etc?  Bascially: tell us more
>   stuff.

The core hardware architecture of Intel Active Management Technology 
(Intel AMT) is resident in firmware. The micro-controller within the 
chipset's graphics and memory controller (MCH) hub houses the Management 
Engine (ME) firmware, which implements various services on behalf of 
management applications. Additionally, flash memory houses system BIOS, 
code used by the management engine, and a third-party data store (3PDS) 
that enables applications to store information as needed in non-volatile 
memory.

Communication between the host OS and the ME is accomplished by means of 
the Intel Management Engine Interface (aka HECI: Host Embedded 
Controller Interface ). MEI is bi-directional, and either the host or 
Intel AMT firmware can initiate transactions.

Some of the ME subsystems that can be access via MEI driver:

- Intel(R) Quiet System Technology (QST) is implemented as a firmware 
subsystem  that  runs in the ME.  Programs that wish to expose the 
health monitoring and fan speed control capabilities of Intel(R) QST 
will need to use the MEI driver to communicate with the ME sub-system.
- ASF is the "Alert Standard Format" which is an DMTF manageability 
standard. It is implemented in the PC's hardware and firmware, and is 
managed from a remote console.

Most recent Intel desktop chipsets have one or more of the above ME 
services. The MEI driver will make it possible to support the above 
features on Linux and provides applications access to the ME and it's 
features. The MEI drivers will also help bridge a current gap related to 
lm_sensors support on recent desktop chipsets.


Anas


