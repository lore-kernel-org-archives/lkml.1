Return-Path: <linux-kernel-owner+w=401wt.eu-S1758458AbYAQXjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758458AbYAQXjJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 18:39:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765AbYAQXi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 18:38:56 -0500
Received: from slowhand.arndnet.de ([88.198.19.76]:33892 "EHLO mail.unitix.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753410AbYAQXi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 18:38:56 -0500
Message-ID: <478FE733.2030806@i4.informatik.rwth-aachen.de>
Date: Fri, 18 Jan 2008 00:39:31 +0100
From: Arnd Hannemann <hannemann@i4.informatik.rwth-aachen.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Jordan Crouse <jordan.crouse@amd.com>
CC: Andres Salomon <dilinger@queued.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-rc8 hangs at mfgpt-timer
References: <478E4267.7020509@i4.informatik.rwth-aachen.de> <20080116161912.7b449466@ephemeral> <20080116165606.3ebc06a4@ephemeral> <478F25D6.3060503@i4.informatik.rwth-aachen.de> <20080117134032.4cc1a1cf@ephemeral> <478FB255.5040001@i4.informatik.rwth-aachen.de> <20080117211917.GF8244@cosmic.amd.com> <478FCDB6.4010708@i4.informatik.rwth-aachen.de> <20080117223644.GK8244@cosmic.amd.com> <478FDC12.6020505@i4.informatik.rwth-aachen.de> <20080117225744.GL8244@cosmic.amd.com>
In-Reply-To: <20080117225744.GL8244@cosmic.amd.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jordan Crouse schrieb:
> On 17/01/08 23:52 +0100, Arnd Hannemann wrote:
> 
> <snip>
> 
>>> Hmmm - not sure whats happening here.  I wonder if we're stuck in an
>>> interrupt storm of some sort as soon as you register the interrupt handler.
>>> But I would think that whatever was causing the interrupt storm would be
>>> running well before we hit setup_irq(), and you would be recording "nobody
>>> cared" interrupts left and right.
>> Interesting thing is that it hangs not in setup_irq() but later, right
>> after printing the newline of the printk.
> 
> THat makes me think interrupt storm even more.
> 
>>> The thing that scares me is that the TinyBIOS seems to know that we want
>>> to use the MFGPT timers, and I wonder if they did anything behind the scenes
>>> to "help us out" even though we didn't ask for it.
>>>
>>> I don't know how easy it would be for you - but can you try reading 
>>> MSRs 0x51400020 - 0x51400023?   If you need a command line app to do it,
>>> you can use rdmsr from here:
>>>
>>> http://wiki.laptop.org/go/Flashing_LinuxBIOS_on_A-Test_Boards
>> MSR register 0x51400020 => b7:ef:5f:f4:bf:d1:95:68
>> MSR register 0x51400021 => b7:fd:1f:f4:bf:cf:5a:d8
>> MSR register 0x51400022 => b7:f3:bf:f4:bf:f5:fb:a8
>> MSR register 0x51400023 => b7:fb:9f:f4:bf:fd:d9:f8
> 
> Hmmm - those look wrong.  Is /dev/cpu/0/msr there?  The applet on the
> wiki has a bug that doesn't check for it.
I'm sorry, I should have checked: I didn't execute rdmsr as root.
The correct ones:

MSR register 0x51400020 => 00:00:00:00:00:00:0f:00
MSR register 0x51400021 => 00:00:00:00:04:00:00:00
MSR register 0x51400022 => 00:00:00:00:00:00:00:00
MSR register 0x51400023 => 00:00:00:00:00:0c:ba:90

Arnd
