Return-Path: <linux-kernel-owner+w=401wt.eu-S1752559Ab0ABGSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab0ABGSz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 01:18:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752458Ab0ABGSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 01:18:54 -0500
Received: from smtpauth.net4india.com ([202.71.129.41]:46205 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab0ABGSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 01:18:54 -0500
Message-ID: <4B3EE51C.6000802@xenontk.org>
Date: Sat, 02 Jan 2010 11:48:04 +0530
From: David John <davidjon@xenontk.org>
Reply-To: davidjon@xenontk.org
User-Agent: Mozilla/5.0 (X11; X; Linux x86_64; rv:1.9.1.5) Gecko/20091209 Thunderbird/3.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Rusty Russell <rusty@rustcorp.com.au>, andreas.herrmann3@amd.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Regression] 2.6.33-rc2 - pci: Commit e0cd516 causes OOPS
References: <4B3E51FC.9000502@xenontk.org> <86802c441001011422n435545cy1b69ff155b05a1a6@mail.gmail.com>
In-Reply-To: <86802c441001011422n435545cy1b69ff155b05a1a6@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2010 03:52 AM, Yinghai Lu wrote:
> On Fri, Jan 1, 2010 at 11:50 AM, David John <davidjon@xenontk.org> wrote:
>> Hi All,
>>
>> Commit e0cd516 causes an null pointer dereference when reading from the
>> sysfs attributes local_cpu* on Intel machines with no ACPI NUMA
>> proximity info, since dev->numa_node gets set to -1 for all PCI devices,
>> which then gets passed to cpumask_of_node.
>>
>> The patch following this mail fixes the problem for x86. Perhaps a more
>> thorough solution would be to fix the PCI layer to set the node
>> information for devices to zero rather than -1 (Since if CONFIG_NUMA=y
>> we have node 0)? I don't know whether it is safe / correct to do this.
> 
> no.
> 
> 1. -1, mean calling code will use node that code is running on.
> 2. the system that have two or more nodes, and more peer root buses.
> if the first node doesn't have RAM installed, no node0 then.
> 
> YH
> 

Oh I see. Thanks.

Regards,
David.
