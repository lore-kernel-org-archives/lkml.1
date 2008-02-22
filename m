Return-Path: <linux-kernel-owner+w=401wt.eu-S1760946AbYBVQdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760946AbYBVQdk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 11:33:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760003AbYBVQcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 11:32:31 -0500
Received: from will39.synserver.de ([212.40.172.10]:49236 "EHLO
	will39.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756450AbYBVQc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 11:32:26 -0500
X-Greylist: delayed 2069 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Feb 2008 11:32:26 EST
Message-ID: <47BEF0A6.9000405@willies.info>
Date: Fri, 22 Feb 2008 16:56:22 +0100
From: Jan Willies <jan@willies.info>
User-Agent: Thunderbird 2.0.0.9 (X11/20071212)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-acpi@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: 100% C0 with 2.6.25-rc
References: <47BD600F.9090502@willies.info> <200802211733.54759.rjw@sisk.pl>
In-Reply-To: <200802211733.54759.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Thursday, 21 of February 2008, Jan Willies wrote:
>> Since 2.6.25-rc1 I have a lot of wakeups/s (≈134191,4) and spend 100% in C0.
>> It worked fine with 2.6.24 and commandline nolapic. Without nolapic I had 80k
>> wakeups/s after some time, but not right from the start like now.  
> 
> We have a regression from 2.6.24, apparently interrupts-related.

After a lot of bisecting I've found the bad commit: 

9b12e18cdc1553de62d931e73443c806347cd974 is first bad commit
commit 9b12e18cdc1553de62d931e73443c806347cd974
Author: venkatesh.pallipadi@intel.com <venkatesh.pallipadi@intel.com>
Date:   Thu Jan 31 17:35:05 2008 -0800

    ACPI: cpuidle: Support C1 idle time accounting
    
    Show C1 idle time in /sysfs cpuidle interface. C1 idle time may not
    be entirely accurate in all cases. It includes the time spent
    in the interrupt handler after wakeup with "hlt" based C1. But, it will
    be accurate with "mwait" based C1.


Reverting the commit brings my laptop back to C2.


HTH

- Jan
