Return-Path: <linux-kernel-owner+w=401wt.eu-S1755386AbYGKQ4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386AbYGKQ4H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 12:56:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754046AbYGKQzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 12:55:55 -0400
Received: from smtp8.server.rpi.edu ([128.113.2.228]:49983 "EHLO
	smtp8.server.rpi.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895AbYGKQzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 12:55:54 -0400
Message-ID: <4877908C.4060706@rpi.edu>
Date: Fri, 11 Jul 2008 12:55:40 -0400
From: David Brigada <brigad@rpi.edu>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Jordan Crouse <jordan.crouse@amd.com>
CC: jim.cromie@gmail.com, LKML <linux-kernel@vger.kernel.org>,
       linux-geode@lists.infradead.org
Subject: Re: PCI-ISA Bridge not operating
References: <487774F9.6000001@rpi.edu> <20080711164845.GB28720@cosmic.amd.com> (sfid-20080711_174547_429140_033022C1)
In-Reply-To: <20080711164845.GB28720@cosmic.amd.com> (sfid-20080711_174547_429140_033022C1)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-RPI-SA-Score: undef - spam scanning disabled
X-CanItPRO-Stream: default
X-Canit-Stats-ID: Bayes signature not available
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jordan Crouse wrote:
> On 11/07/08 10:58 -0400, David Brigada wrote:
>> Hi,
>>
>> I'm working with the MSM800XEV board from Digital-Logic.  This board 
>> uses a Geode LX800 for a CPU and has the CS5536 companion board also 
>> installed.  The board works with an IT8888G IC that provides a PCI/ISA 
>> bridge to a PC/104 bus that is externally provided.
>>
>> If I boot with FreeDOS, I can twiddle I/O ports, and the proper ISA 
>> signaling comes over the PC/104 bus.  In Linux, the /IOW or /IOR line 
>> goes low as expected, but the address doesn't come over the bus.  The 
>> DOS that I'm running doesn't seem to have any specific drivers for the 
>> chip, I'm guessing that the hardware should "just work" --- the IT8888G 
>> is designed to grab I/O requests in the ISA range off the PCI bus after 
>> a short delay if nothing else grabs them first.
>>
>> I have a feeling that it has something to do with the CS5536 companion 
>> chip, as it seems as though there is a driver for a PCI/ISA bridge on 
>> that chip, though I can't get much detail from AMD's datasheet on that 
>> functionality.  I do know that on the MSM800XEV, any such functionality 
>> is wired to the IT8888G, not the CS5536.
>>
>> There are two kernel config options related to the PCI IDs of the parts 
>> of the device that handle the ISA bus, CONFIG_SCx200_ACB and 
>> CONFIG_CS5535_GPIO.  I've tried disabling both, but it doesn't seem to help.
>>
>> In lspci, the CS5536 PCI/ISA bridge is shown, but not the IT8888G.
>>
>> Any ideas?
> 
> ISA should indeed "just work".  The only thing I'm wondering is if
> the kernel is interfering (it shouldn't).  I assume that since it works
> in FreeDOS that there is no possibility that something on the PCI bus
> is grabbing the cycles instead.

That's what I'm thinking --- that the CS5536 PCI/ISA bridge is claiming 
the cycles.

> How are you trying to access the device in Linux?  Through a kernel module
> or a user application running as root?

I've tried both.  I have a kernel module that I wrote for the hardware. 
  When I couldn't get that working, I tried looping some code that keeps 
touching the same I/O port that I'm using.

> Jordan
> 

Dave
