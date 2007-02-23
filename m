Return-Path: <linux-kernel-owner+w=401wt.eu-S933196AbXBWTXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933196AbXBWTXY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 14:23:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933191AbXBWTXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 14:23:16 -0500
Received: from mga02.intel.com ([134.134.136.20]:7467 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933190AbXBWTXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 14:23:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,212,1170662400"; 
   d="scan'208"; a="200620088:sNHT20697446"
Message-ID: <45DF3F20.6060002@intel.com>
Date: Fri, 23 Feb 2007 11:23:12 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Mail/News 1.5.0.9 (X11/20061228)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@linux-foundation.org>
CC: Sreenivasa Honnur <Sreenivasa.Honnur@neterion.com>,
       David Miller <davem@davemloft.net>, "Garzik, Jeff" <jgarzik@pobox.com>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Peter Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       "Kok, Auke" <auke@foo-projects.org>,
       "Ronciak, John" <john.ronciak@intel.com>
Subject: Re: [PATCH 1/2] NET: Multiple queue network device support
References: <78C9135A3D2ECE4B8162EBDCE82CAD77013F383F@nekter> <20070223111911.75602c0f@freekitty>
In-Reply-To: <20070223111911.75602c0f@freekitty>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Feb 2007 19:23:13.0168 (UTC) FILETIME=[0F8D0900:01C75780]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger wrote:
> On Fri, 23 Feb 2007 04:00:55 -0500
> "Sreenivasa Honnur" <Sreenivasa.Honnur@neterion.com> wrote:
> 
>> Fucntion "map_queue" returns queue index as '0'. There is no support to
>> return different queue indexes.
>>
>> -----Original Message-----
>> From: netdev-owner@vger.kernel.org [mailto:netdev-owner@vger.kernel.org]
>> On Behalf Of Kok, Auke
>> Sent: Friday, February 09, 2007 5:40 AM
>> To: David Miller; Garzik, Jeff; netdev@vger.kernel.org;
>> linux-kernel@vger.kernel.org
>> Cc: Kok, Auke; Peter Waskiewicz Jr; Brandeburg, Jesse; Kok, Auke;
>> Ronciak, John
>> Subject: [PATCH 1/2] NET: Multiple queue network device support
>>
>>
>> From: Peter Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
>>
>> Added an API and associated supporting routines for multiqueue network
>> devices.  This allows network devices supporting multiple TX queues to
>> configure each queue within the netdevice and manage each queue
>> independantly.  Changes to the PRIO Qdisc also allow a user to map
>> multiple flows to individual TX queues, taking advantage of each queue
>> on the device.
>>
>> Signed-off-by: Peter Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
>> Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
>> ---
> 
>>  
>> +config NET_MULTI_QUEUE_DEVICE
>> +	bool "Multiple queue network device support (EXPERIMENTAL)"
>> +	depends on NET_SCHED && EXPERIMENTAL
>> +	help
>> +	  Saying Y here will add support for network devices that have
>> more than
>> +	  one physical TX queue and/or RX queue.
>> +
>> +	  Multiple queue devices will require qdiscs that understand how
>> to
>> +	  queue to multiple targets.  The default packet scheduler will
>> default
>> +	  to the first queue in a device.  In other words, if you need
>> the
>> +	  ability to spread traffic across queues, your queueing
>> discipline
>> +	  needs to know how to do that.
>> +
>> +	  Note that saying Y here will give preferential treatment to
>> multiple
>> +	  queue devices in the network stack.  A slight drop in
>> single-queue
>> +	  device performance may be seen.
>> +
>> +	  Say N here unless you know your network device supports
>> multiple
>> +	  TX and/or RX queues.
>> +
> 
> This should not be a user visible configuration option.
> It should either: always be part of the kernel API
> or be selected by drivers that need/want it.

perhaps when it's stable, yes, but right now it's definately experimental and 
may result in a slight overhead for single-queue devices as the text reads.


Cheers,

Auke
