Return-Path: <linux-kernel-owner+w=401wt.eu-S1757921AbZC3Jbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921AbZC3Jbe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 05:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755163AbZC3JbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 05:31:25 -0400
Received: from mga10.intel.com ([192.55.52.92]:63657 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755455AbZC3JbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 05:31:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,445,1233561600"; 
   d="scan'208";a="677094831"
Message-ID: <49D09188.5060807@linux.intel.com>
Date: Mon, 30 Mar 2009 11:31:52 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -tip 3/3] x86, mce: Add mce=nopoll option to disable timer
 polling
References: <49CB3F4B.8070406@jp.fujitsu.com> <49CB4453.6000407@linux.intel.com> <49CCA122.8070908@jp.fujitsu.com> <49CCBC07.6000004@linux.intel.com> <49D08BC7.6070002@jp.fujitsu.com>
In-Reply-To: <49D08BC7.6070002@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hidetoshi Seto wrote:
> Andi Kleen wrote:
>>>> Also I'm not sure a boot argument is really needed. Isn't it
>>>> good enough to do this early at boot through sysfs?
>>> Maybe it is good for this option, as far as polling never run
>>> so soon.  Because sysfs is available after start of polling
>>> timer, boot argument is required just in theory of logics.
>> I think the best way would be to just not run mcelog if you want
>> the BIOS to log all. The only problem I guess is that users might be confused
>> by the printk. So perhaps just do a patch to shut down the printk?
> 
> How to prevent banks from clearing?

Firmware first typically means the firmware gets it one way or another
using SMI and that tends to work even when the OS clears because
SMI comes first. So stopping the clearing is probably not needed?

>>> One another problem is that there are multiple documentations for
>>> machinecheck parameters, but not linked well:
>>>
>>>  - Documentation/kernel-parameters.txt
>>>     ("See Documentation/x86/x86_64/boot-options.txt" for "mce=")
>>>  - Documentation/x86/x86_64/boot-options.txt
>>>     ("AMD64 specific boot options" is not true now!)
>>>  - Documentation/x86/x86_64/machinecheck
>>>     (which I had not noticed the existence at first, oops!)
>> machinecheck is for the sysfs interface, boot options is for the boot parameters.
>>
>> I guess a reference could be added to machinecheck to point to boot-options.txt
> 
> Vice verse, I suppose.
> boot-options.txt just have "Everything else is in sysfs now." without pointing
> machinecheck that describe the sysfs well.

I added a reference in my pile.

-Andi
