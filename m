Return-Path: <linux-kernel-owner+w=401wt.eu-S1756141AbYDDHjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbYDDHjQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 03:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbYDDHi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 03:38:58 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:57755 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433AbYDDHi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 03:38:57 -0400
Message-ID: <47F5DB08.2070405@garzik.org>
Date: Fri, 04 Apr 2008 03:38:48 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Kuan Luo <kluo@nvidia.com>
CC: Robert Hancock <hancockr@shaw.ca>, Tejun Heo <htejun@gmail.com>,
       Zoltan Boszormenyi <zboszor@dunaweb.hu>, akpm@linux-foundation.org,
       linux-ide@vger.kernel.org, Peer Chen <pchen@nvidia.com>,
       Allen Martin <AMartin@nvidia.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 3/3] ata: SWNCQ should be enabled by default
References: <200803282133.m2SLXlWk011463@imap1.linux-foundation.org> <47EE465E.80401@gmail.com> <47EE88C9.3020805@dunaweb.hu> <47EEDACA.4060400@gmail.com> <15F501D1A78BD343BE8F4D8DB854566B1BFE2AF1@hkemmail01.nvidia.com> <47F069D7.3010702@gmail.com> <47F1A888.3020706@shaw.ca> <47F1AADC.1080104@shaw.ca> <15F501D1A78BD343BE8F4D8DB854566B1BFE2AF4@hkemmail01.nvidia.com>
In-Reply-To: <15F501D1A78BD343BE8F4D8DB854566B1BFE2AF4@hkemmail01.nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kuan Luo wrote:
> Robert wrote:
>> -Hotplug/hot-unplug fails to work properly, hotplug interrupts not 
>> raised (seemingly only on certain boards/configurations as I can't 
>> duplicate this problem). 
>> http://bugzilla.kernel.org/show_bug.cgi?id=8421
>>
> I occasionly encountered this problem in one port under certain system,
> but didn't see this issue under other systems in the same mainboard.
> After adding the operation of manually clearing the added/removed
> interrupt bit in NV_INT_STATUS_CK804 register 
> in nv_adma_interrupt function,  i saw some improvement.  
> 
> The key problem is that no one who knows this controller comes to help
> to solve these issue.
> Given this disadvantage, i think disabling it maybe is a good choice.
> I don't know whether we need to continue to provide patch for adma after
> disabling adma function.

Based on all these discussions and experiences, I just checked in the 
following commit, setting adma_enabled to zero:


     [libata] sata_nv: disable ADMA by default

     Continues to have open issues, and engineering support is extremely
	 difficult to come by, according to fellow NVIDIA engineers.

     Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

