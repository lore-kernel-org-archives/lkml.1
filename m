Return-Path: <linux-kernel-owner+w=401wt.eu-S1759264AbYG3J2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759264AbYG3J2s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 05:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753172AbYG3J2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 05:28:38 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:42065 "EHLO
	WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191AbYG3J2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 05:28:37 -0400
X-BigFish: VPS-16(zz1432R98dR936eQ1805M931fihzz10d3izzz32i6bh)
X-WSS-ID: 0K4TBN4-02-UO3-01
Message-ID: <48903431.9060707@amd.com>
Date: Wed, 30 Jul 2008 11:28:17 +0200
From: Peter Oruba <peter.oruba@amd.com>
Organization: AMD (OSRC)
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Max Krasnyansky <maxk@qualcomm.com>
CC: Dmitry Adamushko <dmitry.adamushko@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/4] x86: AMD microcode patch loading v2 fixes
References: <20080729154103.007575982@amd.com> <b647ffbd0807290918kaa0a05es3cebf7a6f15fb790@mail.gmail.com> <488F581B.7060009@qualcomm.com>
In-Reply-To: <488F581B.7060009@qualcomm.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Jul 2008 09:28:17.0728 (UTC) FILETIME=[99746400:01C8F226]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Max Krasnyansky schrieb:
> Dmitry Adamushko wrote:
>> 2008/7/29 Peter Oruba <peter.oruba@amd.com>:
>>> Fixed coding style issues.
>>
>> I have a comment on the abstraction layer (microcode_ops).
>>
>> [ Not that I've looked very carefully at it so far, nor I pretend to
>> be at-ease with this 'microcode' topic to make any design judgements
>> :-) ]
>>
>> but would it be somehow possible to not have set_cpus_allowed_ptr()
>> code in arch-dependent parts? Let's say the mechanism of how to run
>> certain arch-specific code (and synchronization) on a given cpu should
>> be a prerogative of (and placed in) the generic part...
>>
>> Note, this code will likely happily give you an oops if you run
>> cpu_down/up() ;-)
>>
>> I also wondered, is there a requirement that when a new cpu is brought
>> up, microcode updates {should,must} be done as early as possible, say
>> before any tasks have a chance to run on it? Or can the update be a
>> bit delayed? e.g. we don't do it from cpu-hotplug handlers.
> 
> Dmitry looks like you missed my email. I already asked that question and 
> proposed a couple of options (workqueue and ipi).
> Tigran said that he does not know. Maybe Peter does.
> 
> My guess is that it does not have to be done synchronously and can be 
> delayed. There is no guaranty that microcode CPU hotplug handler will 
> run before all the other handlers. Which by definition means that some 
> things will start running on the cpu before the microcode is updated. 
> Hence we might as well do the update outside of the cpu hotplug path.
> 
> Max
> 
> 
> 
> 

Since ucode updates may fix severe issues, it is supposed to happen as early as 
possible. If you re-plug your CPU into your socket, your BIOS also applies a 
ucode patch, but that won't necessarily be the latest and critical one.

Peter

-- 
            |           AMD Saxony Limited Liability Company & Co. KG
  Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
  System    |                  Register Court Dresden: HRA 4896
  Research  |              General Partner authorized to represent:
  Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
            | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

