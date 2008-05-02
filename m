Return-Path: <linux-kernel-owner+w=401wt.eu-S1757895AbYEBFDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895AbYEBFDe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 01:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750984AbYEBFDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 01:03:24 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:5170 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbYEBFDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 01:03:23 -0400
Date: Thu, 01 May 2008 23:03:17 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Why such a big difference in init-time PCI resource call-paths
 (x86 vs x86_64) ?
In-reply-to: <fa.sQSbKD/rf/mnDK28NkngvUl4UA8@ifi.uio.no>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, TJ <linux@tjworld.net>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Message-id: <481AA095.3010201@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.GFIas4KVpQq9pUpviRWeT8L+oBs@ifi.uio.no>
 <fa.hdrruKIvW+GZA0AESo+nBXNURSA@ifi.uio.no>
 <fa.9Qhgua9PuRzPYMHNs+ZG5Q7/Hbg@ifi.uio.no>
 <fa.sQSbKD/rf/mnDK28NkngvUl4UA8@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Andi Kleen wrote:
>> On Thu, May 01, 2008 at 11:16:31AM -0700, Jesse Barnes wrote:
>>> On Wednesday, April 30, 2008 9:07 am TJ wrote:
>>>> In preparation for writing a Windows-style PCI resource allocation
>>>> strategy
>>>>
>>>>  - use all e820 gaps for IOMEM resources; top-down allocation -
>>>>
>>>> and thus giving devices with large IOMEM requirements more chance of
>>>> allocation in the 32-bit address space below 4GB (see bugzilla #10461),
>>
>> I tried that some time ago and it turned out that some systems have
>> mappings in holes and don't boot anymore when you fill the holes too 
>> much. But that was only considering e820. if you do this it might work 
>> if you do it really like windows and consider all resources, including 
>> ACPI.
> 
> Yes, considering all possible reservation schemes is really critical 
> here (including the magic knowledge of the legacy region).

FYI, from what I've read, Windows ignores e820 for detecting resource 
reservations and looks at ACPI reservations only (at least if it's 
running in ACPI mode which these days is almost universal). It seems 
Windows really only uses e820 for locating RAM areas..
