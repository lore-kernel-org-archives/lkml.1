Return-Path: <linux-kernel-owner+w=401wt.eu-S1754764AbZDGIaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbZDGIaa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 04:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751582AbZDGIaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 04:30:21 -0400
Received: from smtp-out.google.com ([216.239.33.17]:15641 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbZDGIaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 04:30:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=A/w08WhlHJGfVzGyO1xdq+nhsrrGhwBORqIPvDA7FHyEuc1EmNSnKpWGbxkZnFG3R
	nu135R24SIYazbORWemhg==
Date: Tue, 7 Apr 2009 01:30:03 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andi Kleen <andi@firstfloor.org>
cc: Brice Goglin <Brice.Goglin@inria.fr>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Chris Worley <worleys@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Off topic: Numactl "distance" wrong
In-Reply-To: <20090407082342.GM17934@one.firstfloor.org>
Message-ID: <alpine.DEB.2.00.0904070123100.24412@chino.kir.corp.google.com>
References: <86802c440904031448yc6d499ckd9cb969ce136f477@mail.gmail.com> <87r609jtc2.fsf@basil.nowhere.org> <20090407111539.F0F5.A69D9226@jp.fujitsu.com> <49DAF003.1070605@inria.fr> <20090407070530.GJ17934@one.firstfloor.org>
 <alpine.DEB.2.00.0904070035570.20262@chino.kir.corp.google.com> <20090407075908.GL17934@one.firstfloor.org> <alpine.DEB.2.00.0904070058070.20262@chino.kir.corp.google.com> <20090407082342.GM17934@one.firstfloor.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Apr 2009, Andi Kleen wrote:

> No actually it was intended to prevent tables that confuse the scheduler/VM
> from being used. At least that is what I wrote it for. The only check
> that is really needed is that remote != local, the rest is fluff
> admittedly and could be all dropped.
> 

I think users, current and future, of node_distance(a, b) would assume it 
would be equal to node_distance(b, a).  Admittedly, later revisions of the 
SLIT specification allow this to not necessarily be true.

I agreed with you early on that we shouldn't add an interface to 
dynamically change the localities in the SLIT, not only because of the 
dependencies that the VM and scheduler have which you mentioned, but also 
because there is no current interface for changing it and its much more 
reasonable to simply fix the BIOS instead of tuning this (which is even 
more argument for making slit_valid() as sane as possible).

I do think that it would be helpful to add a parameter to disable parsing 
the SLIT, however, when it is known to be incorrect.  I haven't heard your 
objection to that yet.
