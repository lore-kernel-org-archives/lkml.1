Return-Path: <linux-kernel-owner+w=401wt.eu-S1756951AbZAOFYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951AbZAOFYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 00:24:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753771AbZAOFYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 00:24:34 -0500
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:6044 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752621AbZAOFYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 00:24:33 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AicFACNVbkk7p+/x/2dsb2JhbACBa7dGlVmFboQ2
X-IronPort-AV: E=Sophos;i="4.37,267,1231075800"; 
   d="scan'208";a="266703403"
Message-ID: <496EC614.4040307@call-direct.com.au>
Date: Thu, 15 Jan 2009 16:13:56 +1100
From: Iwo Mergler <iwo@call-direct.com.au>
User-Agent: Thunderbird 2.0.0.12 (X11/20080302)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: A really interesting mass-storage BUG introduced after 2.6.18
References: <Pine.LNX.4.44L0.0901141041070.2192-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0901141041070.2192-100000@iolanthe.rowland.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Tue, 13 Jan 2009, [UTF-8] Ozan Ã‡aÄŸlayan wrote:
> 
>> Here's the usbmon log:
> ...
> 
> Here's the interesting part, right at the end of the log:
> 
>> ee5f0e80 2495844993 S Bo:1:011:1 -115 31 = 55534243 02000000 00000000 00000600 00000000 00000000 00000000 000000
>> ee5f0e80 2495845078 C Bo:1:011:1 0 31 >
>> ee5f0e80 2495845112 S Bi:1:011:2 -115 13 <
>> ee5f0e80 2495845327 C Bi:1:011:2 0 13 = 55534253 02000000 00000000 01
>> ee5f0e80 2495845338 S Bo:1:011:1 -115 31 = 55534243 03000000 12000000 80000603 00000012 00000000 00000000 000000
>> ee5f0e80 2495845579 C Bo:1:011:1 0 31 >
>> ee4d7280 2495845595 S Bi:1:011:2 -115 18 <
>> ee4d7280 2495845829 C Bi:1:011:2 0 18 = 70000600 0000000a 00000000 3a000000 0000
>> ee5f0e80 2495845850 S Bi:1:011:2 -115 13 <
>> ee5f0e80 2495845955 C Bi:1:011:2 0 13 = 55534253 03000000 00000000 00
> 
> This shows the computer sending a TEST UNIT READY command to the drive, 
> and the drive reporting Unit Attention: Media not present.  So of 
> course Linux believes there is no media loaded in the drive and doesn't 
> try to read the partition table or anything else.
> 
> Presumably if the drive is plugged in during bootup then the BIOS does 
> something to make this error status go away.  It's hard to guess what 
> that would be, however.
> 

It could be a matter of timing. Some badly designed USB devices have a
dead time between power-up and being ready, but show up on the bus as
if they where. The "Media not present" thing could be a symptom of this.

To verify it, try inserting the device slowly. The power contacts in
the USB connector are longer than the data contacts and the device gets
more time to boot.

Regards,

Iwo


