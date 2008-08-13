Return-Path: <linux-kernel-owner+w=401wt.eu-S1753888AbYHMSPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888AbYHMSPl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 14:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750995AbYHMSPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 14:15:33 -0400
Received: from mga03.intel.com ([143.182.124.21]:7475 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbYHMSPd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 14:15:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,202,1217833200"; 
   d="scan'208";a="33350815"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Milan Plzik <milan.plzik@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 13 Aug 2008 11:14:48 -0700
Subject: RE: Possible CPU_IDLE bug [WAS: Re: Timer unstability on when using
 C2	and deeper sleep states (Dell Latitude XT)]
Thread-Topic: Possible CPU_IDLE bug [WAS: Re: Timer unstability on when
 using C2	and deeper sleep states (Dell Latitude XT)]
Thread-Index: Acj9UFI9JYmaMwI6QA2568XAQ1EeMAAHqSsg
Message-ID: <7E82351C108FA840AB1866AC776AEC460945BB44@orsmsx505.amr.corp.intel.com>
References: <1218566008.13866.41.camel@localhost>
	 <1218625125.4304.7.camel@localhost> <1218636980.5250.12.camel@localhost>
In-Reply-To: <1218636980.5250.12.camel@localhost>
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
>From: linux-kernel-owner@vger.kernel.org
>[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Milan Plzik
>Sent: Wednesday, August 13, 2008 7:16 AM
>To: linux-kernel@vger.kernel.org
>Subject: Possible CPU_IDLE bug [WAS: Re: Timer unstability on
>when using C2 and deeper sleep states (Dell Latitude XT)]
>
>  Hello again,
>
>On St, 2008-08-13 at 12:58 +0200, Milan Plzik wrote:
>> I apologize for replying on my own mail (and also for
>top-posting, but
>> this information is global update, not exactly fitting any of topics
>> mentioned below).
>>
>>   After playing for a longer while I found out that the system ends
>> sometimes in state where, in order to do anything useful, I need to
>> press keys on keyboard. Otherwise, the system just stalls and does
>> nothing. I have no idea why does this happen (especially when I know
>> that OHCI or wireless network adapter produce fair amount of
>> interrupts). My /proc/interrupts is below. Just for the record,
>> chipset
>> on board is ATI RS600 with (apparently from lspci) ATI SB600
>> southbridge.
>
>  it looks like this problem disappears if CONFIG_CPU_IDLE option is
>disabled, system seems to be stable for more than one hour. This
>suggests that something may be wrong with the CPU_IDLE code. I can not
>spend much more time by debugging the kernel, but if anyone has an
>suggestion about what to fix, I will gladly test it.
>
>  Best regards,
>        Milan Plzik

It may not be a problem with cpuidle code per se. We have had issues earlier like this one

http://bugzilla.kernel.org/show_bug.cgi?id=10011

Cpuidle tries to go to C3 state aggressively and thus may be indirectly causing the problem with graphics hardware or something like that.

>From Dave's comment in the above bugzilla:
can you try with Option "DRI" "Off" in your xorg.conf

Does that change anything?

Thanks,
Venki
