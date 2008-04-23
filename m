Return-Path: <linux-kernel-owner+w=401wt.eu-S1755407AbYDWNWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbYDWNWs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 09:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbYDWNWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 09:22:37 -0400
Received: from gate.crashing.org ([63.228.1.57]:60449 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752520AbYDWNWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 09:22:36 -0400
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Message-Id: <17BE975E-6A02-4267-AB8F-5C3B39F485A8@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Wim Van Sebroeck <wim@iguana.be>
In-Reply-To: <20071025193702.GA6455@infomag.infomag.iguana.be>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: handling watchdog in SMP
Date: Wed, 23 Apr 2008 08:22:24 -0500
References: <EA6D7331-2E0E-44D5-A286-EFD3505139BB@kernel.crashing.org> <20071025193702.GA6455@infomag.infomag.iguana.be>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 25, 2007, at 2:37 PM, Wim Van Sebroeck wrote:
> Hi Kumar,
>
>> I was hoping to get some ideas on how to handle the watchdog timers
>> we have on some embedded PPC (booke_wdt.c) cores when we are in a SMP
>> system.
>>
>> The problem is since the watchdog is part of the processor core
>> depending on which processor a given system call is executed at we
>> might get different behavior.  It seems like we would want to mirror
>> the actions to both cores (via smp_call_function).
>>
>> Looking at the file ops we currently support in booke_wdt.c it seems
>> like we could mirror the actions for booke_wdt_write()/booke_wdt_ping
>> () to both cores and ensure when we set something like
>> WDIOC_SETTIMEOUT we set the registers in both processors.
>>
>> I was wondering if anyone had any other ideas or if this model seems
>> to work.
>
> I see 2 ways to go:
> 1) short term: make sure that your actions are duplicated to both  
> cores
> (like you said). At least then you are protected if your complete  
> system
> crashes.
> 2) I'm working on the uniform/generic watchdog device driver. Phase  
> 1 is
> the "new" api and the /dev/watchdog handling. Phase 2 is a sysfs  
> interface.
> Phase 3 is to allow multiple devices (and there I'm still thinking  
> about
> how the /dev/watchdog interface should work).
> But the general idea is to allow at least the control of each watchdog
> device by the sysfs interface.

I haven't been following watchdog subsystem development and was  
wondering if any progress has been made on #2?

- k
