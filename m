Return-Path: <linux-kernel-owner+w=401wt.eu-S1753448AbZDGIJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbZDGIJg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 04:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbZDGIJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 04:09:18 -0400
Received: from smtp-out.google.com ([216.239.45.13]:13489 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbZDGIJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 04:09:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=Kp4eL1CGbV+CZyBpkWngpdvbRzyr7Mp2Gd9z9FnzuAvgqeytLH7y6kYmHiHarFDTj
	A8TKMawSOPMdqWNL6N25g==
Date: Tue, 7 Apr 2009 01:08:59 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andi Kleen <andi@firstfloor.org>
cc: Brice Goglin <Brice.Goglin@inria.fr>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Chris Worley <worleys@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Off topic: Numactl "distance" wrong
In-Reply-To: <20090407075908.GL17934@one.firstfloor.org>
Message-ID: <alpine.DEB.2.00.0904070058070.20262@chino.kir.corp.google.com>
References: <86802c440904031448yc6d499ckd9cb969ce136f477@mail.gmail.com> <87r609jtc2.fsf@basil.nowhere.org> <20090407111539.F0F5.A69D9226@jp.fujitsu.com> <49DAF003.1070605@inria.fr> <20090407070530.GJ17934@one.firstfloor.org>
 <alpine.DEB.2.00.0904070035570.20262@chino.kir.corp.google.com> <20090407075908.GL17934@one.firstfloor.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Apr 2009, Andi Kleen wrote:

> > It would also be possible to verify that the distance between two 
> > localities is described consistently in the table (like in the following 
> > patch).
> 
> Do you have an real-world example where this is wrong? 
> 

Um, this is a SLIT validation method, so the change is only necessary to 
ensure that the table is actually valid unless affinity is not symmetric 
in both directions between localities.

Do you have a real-world example of the firmware handing off a locality 
that less than LOCAL_DISTANCE?

If so, that would violate the specification since values 0-9 are reserved.  
But the validation method still checks and you're not arguing against it, 
right?  

slit_valid() is intended to prevent invalid tables from being used because 
they are incorrect and, thus, can't possibly be used the describe the 
physical topology.

> In general this thread seems to contain much more speculation than
> facts.
> 

The fact, which you seem to be ignoring, is node hotplug would require 
this table to change anyway.  It's quite possible using an _SLI method to 
dynamically reconfigure the localities, including those that were 
statically described by the BIOS at boot.  So while you may be satisfied 
with the ACPI 2.0 way of thinking, machines have actually changed in the 
last five years.
