Return-Path: <linux-kernel-owner+w=401wt.eu-S966045AbXCSR2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966045AbXCSR2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 13:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966043AbXCSR2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 13:28:45 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:21484 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966040AbXCSR2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 13:28:44 -0400
Message-ID: <45FEC36D.4060106@oracle.com>
Date: Mon, 19 Mar 2007 10:07:57 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       lenb@kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [2/6] 2.6.21-rc4: known regressions
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <20070318184915.GV752@stusta.de> <20070319090657.3142b8a8.randy.dunlap@oracle.com> <20070319161504.GU752@stusta.de>
In-Reply-To: <20070319161504.GU752@stusta.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Mon, Mar 19, 2007 at 09:06:57AM -0700, Randy Dunlap wrote:
>> On Sun, 18 Mar 2007 19:49:15 +0100 Adrian Bunk wrote:
>>
>>> This email lists some known regressions in Linus' tree compared to 2.6.20.
>>>
>>> If you find your name in the Cc header, you are either submitter of one
>>> of the bugs, maintainer of an affectected subsystem or driver, a patch
>>> of you caused a breakage or I'm considering you in any other way
>>> possibly involved with one or more of these issues.
>>>
>>> Due to the huge amount of recipients, please trim the Cc when answering.
>>>
>>>
>>> Subject    : x86_64: boot hangs unless CONFIG_PCIEPORTBUS=n and acpi=off
>>> References : http://bugzilla.kernel.org/show_bug.cgi?id=8162
>>> Submitter  : Randy Dunlap <randy.dunlap@oracle.com>
>>> Status     : unknown
>> Bug is rejected due to user error.
>> This seems to be a netconsole hang, not ACPI.
> 
> Thanks for this information.
> 
> Is the netconsole hang a regression?

I have to do more debugging to find out what is going on.  It may be
PCIEPORTBUS-related, but 2.6.20 or later now boot for me without
netconsole and hang when using netconsole.  The ending lines in the console
log are:

[   17.946918] PCI: Setting latency timer of device 0000:00:02.0 to 64
[   17.953211] assign_interrupt_mode Found MSI capability
[   17.958388] Allocate Port Service[0000:00:02.0:pcie00]
[   17.963565] Allocate Port Service[0000:00:02.0:pcie01]
[   17.968736] Allocate Port Service[0000:00:02.0:pcie02]
[   17.973903] Allocate Port Service[0000:00:02.0:pcie03]
[   17.979134] PCI: Setting latency timer of device 0000:00:03.0 to 64
[   17.985430] assign_interrupt_mode Found MSI capability
[   17.990565] Losing some ticks... checking if CPU frequency changed.
[   17.996857] Allocate Port Service[0000:00:03.0:pcie00]
[   18.002013] Allocate Port Service[0000:00:03.0:pcie01]
[   18.007175] Allocate Port Service[0000:00:03.0:pcie02]
[   18.012336] Allocate Port Service[0000:00:03.0:pcie03]
[   18.017552] PCI: Setting latency timer of device 0000:00:03.1 to 64
[   18.023848] assign_interrupt_mode Found MSI capability
[   18.029012] Allocate Port Service[0000:00:03.1:pcie00]


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
