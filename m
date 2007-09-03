Return-Path: <linux-kernel-owner+w=401wt.eu-S1755302AbXICSSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302AbXICSSq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 14:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753106AbXICSSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 14:18:36 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:8124 "EHLO
	outbound9-sin-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751069AbXICSSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 14:18:35 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Date: Mon, 3 Sep 2007 20:18:06 +0200
From: "Robert Richter" <robert.richter@amd.com>
To: "dean gaudet" <dean@arctic.org>
cc: "Andi Kleen" <ak@suse.de>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 5/5] x86: Set PCI config space size to extended for
 AMD Barcelona
Message-ID: <20070903181805.GB4758@erda.amd.com>
References: <20070903081736.288288000@amd.com>
 <20070903081736.805623000@amd.com>
 <Pine.LNX.4.64.0709030930150.3502@twinlark.arctic.org>
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0709030930150.3502@twinlark.arctic.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 03 Sep 2007 18:18:06.0201 (UTC)
 FILETIME=[C6212E90:01C7EE56]
X-WSS-ID: 6AC290670X86435142-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03.09.07 09:48:15, dean gaudet wrote:
> it's so very unfortunate the PCI standard has no feature bit to indicate 
> the presence of ECS.

Right. Not nice.

> FWIW in my testing on a range of machines spanning 7 or 8 years i could 
> read config space reg 256... and get 0xffffffff when the device didn't 
> support ECS, and get valid data when the device did support ECS... granted 
> there may be some system out there which behaves really badly when you do 
> this.
> 
> perhaps someone could write a userspace program and test that concept on a 
> far wider range of machines.

A user space programm could map the config space (if MMCONFIG is usable)
and scan the PCI devices directly using memory access.

This patch sets pcidev->cfg_size to 4096 for certain devices so that
the ECS is also available using proc/sys fs or lspci -xxxx. In this
case the Kernel access functions are used. This works with both
methods, CF8 and MMCONFIG. For CF8, all patches of these series must
be used.

Note also, that ECS access is not only for CPU devices available, but
also of other PCI Express devices on the bus.

-Robert

-- 
AMD Saxony, Dresden, Germany
Operating System Research Center
email: robert.richter@amd.com


