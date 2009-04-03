Return-Path: <linux-kernel-owner+w=401wt.eu-S1762181AbZDCWQD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762181AbZDCWQD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 18:16:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757324AbZDCWPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 18:15:51 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:9285 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756886AbZDCWPv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 18:15:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nlIWJBlqM+zHuvy7FQtoERKbuNhr7BdXd2/Pl/QVpn3U1c2kC5ItwuFQ/Y5mWeExn7
         inFBPRzRMsO5rZLGB/2wjxfDIGDRa/kD7Vb+PFht7CxRyzwJArzRVYCMNwTZk3lLR8oa
         Q3bI9slTcNj0UsBCX4Kc5Zs+p/Zn/eKXUI2Ag=
MIME-Version: 1.0
In-Reply-To: <87r609jtc2.fsf@basil.nowhere.org>
References: <f3177b9e0904031302p8aef826u1874a8b9d9af0840@mail.gmail.com>
	 <87vdpljuqi.fsf@basil.nowhere.org>
	 <alpine.DEB.2.00.0904031438540.3646@chino.kir.corp.google.com>
	 <86802c440904031448yc6d499ckd9cb969ce136f477@mail.gmail.com>
	 <87r609jtc2.fsf@basil.nowhere.org>
Date: Fri, 3 Apr 2009 15:15:48 -0700
Message-ID: <86802c440904031515u22bd2362n884337729282c6c1@mail.gmail.com>
Subject: Re: Off topic: Numactl "distance" wrong
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: David Rientjes <rientjes@google.com>, Chris Worley <worleys@gmail.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 3, 2009 at 2:55 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Yinghai Lu <yhlu.kernel@gmail.com> writes:
>
>> On Fri, Apr 3, 2009 at 2:43 PM, David Rientjes <rientjes@google.com> wrote:
>>>
>>> Yinghai, can you elaborate on exactly what type of interface you can
>>> imagine for modifying the distance for nodes through sysfs?  It seems like
>>> you'd have to report the entire physical topology in one write, for which
>>> we currently don't have an interface for beyond pxms, instead of per-node
>>> distances to remote nodes.
>>
>> acpi_numa_slit_init() in srat_64.c will have one copy (called
>> acpi_slit) of SLIT, if there is SLIT from ACPI.
>>
>> so if numa is enabled, could expose that acpi_slit via sysfs for the
>> user to update it.
>
> That's not enough. You would need to redo all the zone fallback tables
> in the VM that are initialized based on topology, do new scheduler
> topologies and all kind of other stuff.
>
> Besides I don't know any user space software which actually does anything
> with the distances. The kernel does, but for it it doesn't make much difference
> on smaller systems.

how the cpu and memory hotplug works when it could change kind of topology?
sched: wonder if arch_reinit_sched_domains() is used to
rebuild_sched_domains() it will call node_distance()

or ACPI asl code could update SLIT table , and let os use slit table.

YH
