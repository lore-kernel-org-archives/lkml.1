Return-Path: <linux-kernel-owner+w=401wt.eu-S1755324AbXD3ONM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbXD3ONM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 10:13:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755325AbXD3ONM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 10:13:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:44741 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755324AbXD3ONL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 10:13:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,471,1170662400"; 
   d="scan'208";a="81293567"
Message-ID: <4635F938.3060706@linux.intel.com>
Date: Mon, 30 Apr 2007 07:12:08 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: vmstat: use our own timer events
References: <Pine.LNX.4.64.0704282206530.29468@schroedinger.engr.sgi.com> <20070429011518.259448ba.akpm@linux-foundation.org> <Pine.LNX.4.64.0704292138480.1737@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0704292138480.1737@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Sun, 29 Apr 2007, Andrew Morton wrote:
> 
>>> on each node at the second and then each of the other processor on a
>>> node on a subsequent tick. That may be useful to keep a large amount
>>> of the second free of timer activity. Maybe the timer folks will have
>>> some feedback on this one?
>> The one-per-second timer interrupt will upset the people who are really
>> aggressive about power consumption (eg, OLPC).  Perhaps there isn't (yet)
>> an intersection between those people and SMP.
> 
> Well the cache_reaper of SLAB hits hard todays anyways. This will help
> if they switch to slub because the counter consolidation is much lighter 
> weight.

it's not about the weight. It's about waking up *at all*. I've been working
really hard to get a system with a reasonable average idle time (600ms+), but
I obviously had to patch the SLAB reaper to be at a different resolution...


> 
> I am fine with delaying this. I just wanted the timer guys to have a 
> chance to shape this a bit. Not sure what they want. What they did to the 
> cache_reaper in 2.6.20/21 is bad.

HUH? The cache_reaper DID NOT CHANGE with the round_jiffies() change.
Before it had a 3 jiffies per cpu offset, after it has a 3 jiffies per cpu offset.
