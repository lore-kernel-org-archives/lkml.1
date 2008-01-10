Return-Path: <linux-kernel-owner+w=401wt.eu-S1759576AbYAJTC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759576AbYAJTC3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 14:02:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755853AbYAJTCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 14:02:18 -0500
Received: from mga02.intel.com ([134.134.136.20]:7760 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754671AbYAJTCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 14:02:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,267,1196668800"; 
   d="scan'208";a="251984863"
Message-ID: <47866B8A.3040607@intel.com>
Date: Thu, 10 Jan 2008 11:01:30 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: Rick Jones <rick.jones2@hp.com>
CC: Chris Friesen <cfriesen@nortel.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: questions on NAPI processing latency and dropped network packets
References: <478654C3.60806@nortel.com> <478666F4.50405@hp.com>
In-Reply-To: <478666F4.50405@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Jan 2008 19:02:16.0918 (UTC) FILETIME=[515E3F60:01C853BB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rick Jones wrote:
>> 1) Interrupts are being processed on both cpus:
>>
>> root@base0-0-0-13-0-11-1:/root> cat /proc/interrupts
>>            CPU0       CPU1
>>  30:    1703756    4530785  U3-MPIC Level     eth0
> 
> IIRC none of the e1000 driven cards are multi-queue

the pci-express variants are, but the functionality is almost always disabled (and
relatively new anyway).

even with multiqueue, you can still have only a single irq line (which defeats the
purpose of course mostly).

>, so while the above 
> shows that interrupts from eth0 have been processed on both CPUs at
> various points in the past, it doesn't necessarily mean that they are
> being processed on both CPUs at the same time right?

never will, an irq can only be processed on one cpu at a time anyway, obviously
the irq here has been migrated ONCE from one of the cpu's to the other.
unfortunately you can't see from /proc/interrupts whether this happens frequently
or not, or how many times it happened before.

Auke
