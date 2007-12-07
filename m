Return-Path: <linux-kernel-owner+w=401wt.eu-S1757856AbXLGW0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757856AbXLGW0u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 17:26:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754433AbXLGW0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 17:26:42 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:45790 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753490AbXLGW0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 17:26:41 -0500
Message-ID: <4759C89B.9000709@linux.vnet.ibm.com>
Date: Sat, 08 Dec 2007 03:56:35 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Nathan Lynch <ntl@pobox.com>
CC: linuxppc-dev@ozlabs.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fake NUMA emulation for PowerPC
References: <20071207211425.10223.91240.sendpatchset@balbir-laptop> <20071207221106.GH16824@localdomain>
In-Reply-To: <20071207221106.GH16824@localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nathan Lynch wrote:
> Hi Balbir-
> 
> Balbir Singh wrote:
>>
>> Here's a dumb simple implementation of fake NUMA nodes for PowerPC. Fake
>> NUMA nodes can be specified using the following command line option
>>
>> numa=fake=<node range>
>>
>> node range is of the format <range1>,<range2>,...<rangeN>
>>
>> Each of the rangeX parameters is passed using memparse(). I find the patch
>> useful for fake NUMA emulation on my simple PowerPC machine. I've tested it
>> on a non-numa box with the following arguments
>>
>> numa=fake=1G
>> numa=fake=1G,2G
>> name=fake=1G,512M,2G
>> numa=fake=1500M,2800M mem=3500M
>> numa=fake=1G mem=512M
>> numa=fake=1G mem=1G
> 
> So this doesn't appear to allow one to assign cpus to fake nodes?  Do
> all cpus just get assigned to node 0 with numa=fake?
> 

Yes, they all appear on node 0. We could have tweaks to distribute CPU's
as well.

> A different approach that occurs to me is to use kexec with a doctored
> device tree (i.e. with the ibm,associativity properties modified to
> reflect your desired topology).  Perhaps a little bit obscure, but it
> seems more flexible.
> 

That would be interesting, but it always means that we need to run
kexec, which might involve two boots.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
