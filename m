Return-Path: <linux-kernel-owner+w=401wt.eu-S937128AbZDCVzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937128AbZDCVzo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 17:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936823AbZDCVzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 17:55:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41825 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763806AbZDCVzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 17:55:14 -0400
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: David Rientjes <rientjes@google.com>, Chris Worley <worleys@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Off topic: Numactl "distance" wrong
From: Andi Kleen <andi@firstfloor.org>
References: <f3177b9e0904031302p8aef826u1874a8b9d9af0840@mail.gmail.com>
	<87vdpljuqi.fsf@basil.nowhere.org>
	<alpine.DEB.2.00.0904031438540.3646@chino.kir.corp.google.com>
	<86802c440904031448yc6d499ckd9cb969ce136f477@mail.gmail.com>
Date: Fri, 03 Apr 2009 23:55:09 +0200
In-Reply-To: <86802c440904031448yc6d499ckd9cb969ce136f477@mail.gmail.com> (Yinghai Lu's message of "Fri, 3 Apr 2009 14:48:31 -0700")
Message-ID: <87r609jtc2.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yhlu.kernel@gmail.com> writes:

> On Fri, Apr 3, 2009 at 2:43 PM, David Rientjes <rientjes@google.com> wrote:
>>
>> Yinghai, can you elaborate on exactly what type of interface you can
>> imagine for modifying the distance for nodes through sysfs?  It seems like
>> you'd have to report the entire physical topology in one write, for which
>> we currently don't have an interface for beyond pxms, instead of per-node
>> distances to remote nodes.
>
> acpi_numa_slit_init() in srat_64.c will have one copy (called
> acpi_slit) of SLIT, if there is SLIT from ACPI.
>
> so if numa is enabled, could expose that acpi_slit via sysfs for the
> user to update it.

That's not enough. You would need to redo all the zone fallback tables
in the VM that are initialized based on topology, do new scheduler
topologies and all kind of other stuff.

Besides I don't know any user space software which actually does anything
with the distances. The kernel does, but for it it doesn't make much difference
on smaller systems.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
