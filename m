Return-Path: <linux-kernel-owner+w=401wt.eu-S940374AbYCSWSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940374AbYCSWSb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762290AbYCSUuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:50:09 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:36160 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756399AbYCSUuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:50:05 -0400
Message-ID: <47E00E8E.2000401@suse.de>
Date: Tue, 18 Mar 2008 21:48:46 +0300
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Shaohua Li <shaohua.li@intel.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Len Brown <len.brown@intel.com>
Subject: Re: suspend slow in 2.6.25-rc6 (was Re: Suspend and hibernation	patchset
 against -rc6)
References: <200803120129.25585.rjw@sisk.pl> <200803172317.33745.rjw@sisk.pl> <20080318130642.GA1609@elf.ucw.cz> <20080318130710.GB1609@elf.ucw.cz> <20080318170706.GA1580@elf.ucw.cz>
In-Reply-To: <20080318170706.GA1580@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Tue 2008-03-18 14:07:10, Pavel Machek wrote:
>> On Tue 2008-03-18 14:06:42, Pavel Machek wrote:
>>> Confirmed, suspend slowness is in 2.6.25-rc6, too. It takes 15 seconds
>>> to suspend/resume, while 2.6.24 takes 9. Thinkpad x60.
>> IIRC 2.6.25-rc5 was "fast".
> 
> rc6:
> 
> CPU0 attaching sched-domain:
>  domain 0: span 3
>   groups: 1 2
> CPU1 attaching sched-domain:
>  domain 0: span 3
>   groups: 2 1
> CPU1 is up
> ACPI: EC: missing OBF confirmation, don't expect it any longer.
This means that either ACPI interrupt or EC GPE is already disabled,
but readings from EC continue. 
> 
> 
> (there's ~.5 sec delay here)
> 
> ACPI: EC: missing write data confirmation, don't expect it any longer.
> 
> (and > 3 sec delay here)
> 
> PM: Writing back config space on device 0000:00:02.0 at offset 1 (was
> 900003, writing 900007)
> PCI: Setting latency timer of device 0000:00:02.0 to 64
> PM: Writing back config space on device 0000:00:02.1 at offset 1 (was
> 900000, writing 900003)
> PM: Writing back config space on device 0000:00:1b.0 at offset 1 (was
> 100106, writing 100102)
> PCI: Setting latency timer of device 0000:00:1b.0 to 64
> PCI: Setting latency timer of device 0000:00:1c.0 to 64
> PCI: Setting latency timer of device 0000:00:1c.1 to 64
> 
> 

