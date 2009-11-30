Return-Path: <linux-kernel-owner+w=401wt.eu-S1752477AbZK3Usi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbZK3Usi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 15:48:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbZK3Ush
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 15:48:37 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:57590 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbZK3Ush (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 15:48:37 -0500
Message-ID: <4B142F94.7010602@austin.ibm.com>
Date: Mon, 30 Nov 2009 14:48:20 -0600
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Ben Herrenschmidt <benh@kernel.crashing.org>,
       paul Mackerras <paulus@samba.org>, gregkh@suse.de
Subject: Re: [PATCH v2 0/3] Kernel handling of Dynamic Logical Partitioning
References: <4B0CD70F.6090600@austin.ibm.com> <m13a3ztwtw.fsf@fess.ebiederm.org>
In-Reply-To: <m13a3ztwtw.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Nathan Fontenot <nfont@austin.ibm.com> writes:
> 
>> version 2 of the patch set with updates from comments.
>>
>> The Dynamic Logical Partitioning (DLPAR) capabilities of the powerpc pseries
>> platform allows for the addition and removal of resources (i.e. cpus,
>> memory, pci devices) from a partition. The removal of a resource involves
>> removing the resource's node from the device tree and then returning the
>> resource to firmware via the rtas set-indicator call.  To add a resource, it
>> is first obtained from firmware via the rtas set-indicator call and then a
>> new device tree node is created using the ibm,configure-coinnector rtas call
>> and added to the device tree.
>>
>> The following set of patches implements the needed infrastructure to have the
>> kernel handle the DLPAR addition and removal of cpus (other DLPAR'able items to
>> follow in future patches).  The framework for this is to create a set of
>> probe/release sysfs files that will facilitate arch-specific call-outs to handle
>> addition and removal of cpus to the system.
> 
> How does this differ from /sys/devices/system/cpu/cpuX/online ?
> 
> From the descriptions it appears that we already have what you are trying to
> add and you just need to tie it into DLPAR on ppc.
> 

The DLPAR and hotplug operations need to be kept separate for ppc.  One big reason
for this is that DLPAR operations on ppc are driven from the Hardware Management
Console (HMC).  It is (almost always) not possible to DLPAR add a resource (i.e.
cpu, memory,pcie device) from the OS.  There are HMC <=> firmware interactions
that must occur to make the resource available to the partition.

Second is that there are times when one would want to hotplug add/remove
a cpu but not dlpar add/remove it.

When a resource is DLPAR removed, the OS has no knowledge that the resource exists. 
Likewise, this allows the addition of resources from the HMC after the system is booted.
This is a feature of ppc partitions that allows for the dynamic movement of resources
between partitions.

-Nathan Fontenot
