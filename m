Return-Path: <linux-kernel-owner+w=401wt.eu-S1757174AbZJ1GsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174AbZJ1GsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 02:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756863AbZJ1GsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 02:48:17 -0400
Received: from mga07.intel.com ([143.182.124.22]:39790 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756597AbZJ1GsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 02:48:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,638,1249282800"; 
   d="scan'208";a="204562168"
Message-ID: <4AE7E931.6040703@linux.intel.com>
Date: Wed, 28 Oct 2009 07:48:17 +0100
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: Mike Travis <travis@sgi.com>, Roland Dreier <rdreier@cisco.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org
Subject: Re: [PATCH] x86, mce: disable MCE if cpu has no MCE banks
References: <adaeip473qt.fsf@cisco.com> <4AE74D25.8090901@sgi.com> <4AE75DB9.3040702@sgi.com> <4AE7C396.7040109@jp.fujitsu.com> <4AE7D59D.9070307@linux.intel.com> <4AE7E40F.20602@jp.fujitsu.com>
In-Reply-To: <4AE7E40F.20602@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hidetoshi Seto wrote:

> 
> Without disabling, what can we do on MCE with no bank?

Nothing, but is it really worth adding a special case?

> I found that do_machine_check() does nothing if banks==0 ... it is better
> to let system to panic with "Machine check from unknown source"?

IMHO yes. In this case the system must be very confused and panic is the
best you can do. Otherwise it won't do anything interesting anyways.

> 
>>> Hum, I suppose the line for CPU 0 was slightly different from others,
>>> because SHD means "this bank is shared bank and controlled by other".
>>> Maybe:
>>>  CPU 0 MCA banks CMCI:0 CMCI:1 CMCI:2 CMCI:3 CMCI:5 ... CMCI:21
>>>
>>> But I agree that we could some work for this messages...
>>> Is it better to change the message level to debug from info?
>> Can be made INFO yes, but I would prefer not removing them
>> from the dmesg for now.
>>
>> Perhaps they could be also compressed a bit like SRAT.
> 
> Like SRAT?  I could not catch the meaning ... For example?

See the recent patches from David Rientjes in the same original thread.

-Andi

