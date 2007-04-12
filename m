Return-Path: <linux-kernel-owner+w=401wt.eu-S1753754AbXDLVGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754AbXDLVGx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 17:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753756AbXDLVGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 17:06:53 -0400
Received: from mta16.adelphia.net ([68.168.78.211]:55905 "EHLO
	mta16.adelphia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753753AbXDLVGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 17:06:52 -0400
Message-ID: <461E9F69.6020808@acm.org>
Date: Thu, 12 Apr 2007 16:06:49 -0500
From: Corey Minyard <minyard@acm.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Jiri Kosina <jikos@jikos.cz>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Helge Hafting <helgehaf@aitel.hist.no>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net, Greg KH <greg@kroah.com>,
       Mike Galbraith <efault@gmx.de>, Adrian Bunk <bunk@stusta.de>
Subject: Re: 2.6.21-rc6-mm1 USB related boot hang
References: <20070408143559.f5014629.akpm@linux-foundation.org> <20070411194227.GA31286@aitel.hist.no> <20070411134346.d10765da.akpm@linux-foundation.org> <20070411230700.GA4023@aitel.hist.no> <Pine.LNX.4.64.0704120947230.12991@twin.jikos.cz> <Pine.LNX.4.64.0704121001400.12991@twin.jikos.cz> <Pine.LNX.4.64.0704121642110.12991@twin.jikos.cz> <20070412095531.d792f671.akpm@linux-foundation.org> <Pine.LNX.4.64.0704121937310.12991@twin.jikos.cz> <Pine.LNX.4.64.0704121955190.12991@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0704121955190.12991@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Thu, 12 Apr 2007, Jiri Kosina wrote:
>
>   
>> CONFIG_IPMI_SI=y
>> hangs upon boot on the already mentioned printk from ipmi_si. With
>> CONFIG_IPMI_SI=m
>> the boot succeeds. When manually trying to modprobe ipmi_si after that, 
>> the modprobe itself hangs, but the machine remains usable otherwise.
>>     
>
> Actually, after approximately 6 minutes 30 seconds, the modprobe finishes 
> with -ENODEV and the following is spitted into dmesg:
>
> ipmi_si: There appears to be no BMC at this location
> ACPI: PCI interrupt for device 0000:02:00.4 disabled
> ipmi_si: Unable to find any System Interface(s)
>
> Anyway I just checked that I get precisely the same behavior with plain 
> 2.6.21-rc6, so we can rule out -mm with this issue.
>
> It's possible that this system has some broken KCS. I will try to narrow 
> this down.
>   
My guess is that this system spaces out its KCS registers, but there 
appears to be no way to specify register spacing or offsets with PCI.  
That would mean that the configuration register appears operational to 
the driver, but the data register is returning bogus data.  Thus it 
appears "sort of" working to the driver, and it takes a long time to 
time out.

I'm pretty sure it's possible to test to figure out where the registers 
are really located.  However, I have no way to test this change.  All 
the other configuration methods have a way to discover this information.

Jiri, we should probably take this offline if you want to continue to 
work on it.

Thanks,

-corey
