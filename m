Return-Path: <linux-kernel-owner+w=401wt.eu-S1758667AbZFBSH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667AbZFBSH2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 14:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757405AbZFBSHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 14:07:20 -0400
Received: from ns3.baby-dragons.com ([204.91.156.41]:36086 "EHLO
	ns3.baby-dragons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516AbZFBSHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 14:07:19 -0400
X-Greylist: delayed 1133 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Jun 2009 14:07:19 EDT
Date: Tue, 2 Jun 2009 09:47:36 -0800 (AKDT)
From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
To: Ray Lee <madrabbit@gmail.com>
cc: John Stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       mingo@redhat.com, hpa@zytor.com, riel@redhat.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org,
       Miroslav Lichvar <mlichvar@redhat.com>
Subject: Re: [tip:timers/ntp] ntp: adjust SHIFT_PLL to improve NTP
 convergence
In-Reply-To: <2c0942db0906012039ha1046abqe32951b57f40c0f4@mail.gmail.com>
Message-ID: <alpine.LNX.2.01.0906020943400.23203@filesrv1.baby-dragons.com>
References: <200905051956.n45JuVo9025575@imap1.linux-foundation.org>  <tip-22cfbbfd9f67b67fe073010f51cb71d3632387d5@git.kernel.org>  <1243542817.29511.523.camel@jstultz-laptop> <20090601232223.GH749@elte.hu>  <1243900716.11263.42.camel@jstultz-laptop>
 <2c0942db0906012039ha1046abqe32951b57f40c0f4@mail.gmail.com>
User-Agent: Alpine 2.01 (LNX 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="566704117-1538247727-1243964859=:23203"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.1.8 (ns3.baby-dragons.com [204.91.156.41]); Tue, 02 Jun 2009 17:47:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--566704117-1538247727-1243964859=:23203
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

 	Hello All ,

On Mon, 1 Jun 2009, Ray Lee wrote:
> On Mon, Jun 1, 2009 at 4:58 PM, John Stultz <johnstul@us.ibm.com> wrote:
>> On Tue, 2009-06-02 at 01:22 +0200, Ingo Molnar wrote:
>>> * John Stultz <johnstul@us.ibm.com> wrote:
>>>> On Wed, 2009-05-06 at 09:46 +0000, tip-bot for john stultz wrote:
>>>>> ntp: adjust SHIFT_PLL to improve NTP convergence
>>>>>
>>>>> The conversion to the ntpv4 reference model
>>>>> f19923937321244e7dc334767eb4b67e0e3d5c74 ("ntp: convert to the NTP4
>>>>> reference model") in 2.6.19 added nanosecond resolution the adjtimex
>>>>> interface, but also changed the "stiffness" of the frequency adjustments,
>>>>> causing NTP convergence time to greatly increase.
>>>>>
>>>>> SHIFT_PLL, which reduces the stiffness of the freq adjustments, was
>>>>> designed to be inversely linked to HZ, and the reference value of 4 was
>>>>> designed for Unix systems using HZ=100.  However Linux's clock steering
>>>>> code mostly independent of HZ.
>>>>>
>>>>> So this patch reduces the SHIFT_PLL value from 4 to 2, which causes NTPd
>>>>> behavior to match kernels prior to 2.6.19, greatly reducing convergence
>>>>> times, and improving close synchronization through environmental thermal
>>>>> changes.
>>>>>
>>>>>
>>>>> [ Impact: tweak NTP algorithm for faster convergence ]
>>>>
>>>>     So I've been speaking with Miroslav (cc'ed) who maintains
>>>> the RH ntpd packages, and he's concerned that this patch takes us
>>>> out of NTP's expected behavior, which may cause problems when
>>>> dealing with non-linux systems using NTP.
>>>
>>> I might be missing something here - but Linux converging faster
>>> seems like a genuinely good thing. What non-Linux problem could
>>> there be? Linux's convergence is really Linux's private issue.
>>
>> Yea. It does seem that way. Miroslav can likely expand on the issue to
>> help clarify, but as I understand it, the example is if you have a
>> number of systems that are peers in an NTP network. All of them are
>> using the same userland NTP daemon. However, if the rate of change that
>> corrections are applied is different in half of them, you will have
>> problems getting all the systems to converge together.
>
> Your point is clear, however -- reasonably speaking --  how many
> instances will there be out there of networks of peers partially
> upgraded versus lone systems slowly or never converging off of
> masters?
 	A site with three or four differant system types ,  ie: sparc running 
sloaris ,  pc running openbsd ,  Dec(hp) running VMS ,  Dec(hp) Alpha running 
Linux , ...
 	This moving the Hardware Arch & OS differencews is sometimes done to 
limit hacks & software glicthes by NOT using the same hardware arch or OS .

> By my naive understanding, the latter would strongly outnumber the former.
 	You'd be VERY unhappily suprised .

 		Hth ,  JimL
-- 
+------------------------------------------------------------------+
| James   W.   Laferriere | System    Techniques | Give me VMS     |
| Network&System Engineer | 2133    McCullam Ave |  Give me Linux  |
| babydr@baby-dragons.com | Fairbanks, AK. 99701 |   only  on  AXP |
+------------------------------------------------------------------+
--566704117-1538247727-1243964859=:23203--
