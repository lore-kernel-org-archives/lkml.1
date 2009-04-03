Return-Path: <linux-kernel-owner+w=401wt.eu-S936215AbZDCVwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936215AbZDCVwl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 17:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761410AbZDCVwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 17:52:32 -0400
Received: from smtp-out.google.com ([216.239.45.13]:56685 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760146AbZDCVwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 17:52:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=lXpCk44QPMd9YclBKeIULqPiS0L4093A681Cz5z4R20DuI7GFYezWzGrpK4gICoEc
	ap0MYw5VDKRRa0gOqd1tQ==
Date: Fri, 3 Apr 2009 14:52:21 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: Andi Kleen <andi@firstfloor.org>, Chris Worley <worleys@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Off topic: Numactl "distance" wrong
In-Reply-To: <86802c440904031448yc6d499ckd9cb969ce136f477@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0904031448510.4329@chino.kir.corp.google.com>
References: <f3177b9e0904031302p8aef826u1874a8b9d9af0840@mail.gmail.com>  <87vdpljuqi.fsf@basil.nowhere.org>  <alpine.DEB.2.00.0904031438540.3646@chino.kir.corp.google.com> <86802c440904031448yc6d499ckd9cb969ce136f477@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Apr 2009, Yinghai Lu wrote:

> acpi_numa_slit_init() in srat_64.c will have one copy (called
> acpi_slit) of SLIT, if there is SLIT from ACPI.
> 
> so if numa is enabled, could expose that acpi_slit via sysfs for the
> user to update it.
> 

Yeah, but in what format do you expect the user to update it?  There is no 
ACPI requirement that all nodes that have a remote distance of 20 to node 
0, for instance, are local to themselves.

So you'll have to report the entire physical topology in one write to a 
sysfs interface.  We don't currently have such a format unless we are to 
allow updating of the pxms.
