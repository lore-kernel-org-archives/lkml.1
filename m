Return-Path: <linux-kernel-owner+w=401wt.eu-S1753349AbZIBTgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349AbZIBTgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 15:36:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752963AbZIBTgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 15:36:13 -0400
Received: from smtp-out.google.com ([216.239.33.17]:39634 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbZIBTgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 15:36:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=Z+ctDFpe7CM+SWkEBzZGYh0DRdyLhwjAqSW1nbJrKngoGxFU9y4edetA15pBd+yFw
	EN9UJdzD89un9OL1CX1ww==
Date: Wed, 2 Sep 2009 12:36:04 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ankita Garg <ankita@in.ibm.com>
cc: LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Balbir Singh <balbir@in.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] Fix fake numa on ppc
In-Reply-To: <20090902080346.GB3806@in.ibm.com>
Message-ID: <alpine.DEB.1.00.0909021226160.10279@chino.kir.corp.google.com>
References: <20090902060911.GA5728@in.ibm.com> <alpine.DEB.1.00.0909012326290.31814@chino.kir.corp.google.com> <20090902080346.GB3806@in.ibm.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Sep 2009, Ankita Garg wrote:

> Currently, the behavior of fake numa is not so on x86 as well? Below is
> a sample output from a single node x86 system booted with numa=fake=8:
> 
> # cat node0/cpulist
> 
> # cat node1/cpulist
> 
> ...
> # cat node6/cpulist
> 
> # cat node7/cpulist
> 0-7
> 
> Presently, just fixing the cpu association issue with ppc, as explained
> in my previous mail.
> 

Right, I'm proposing an alternate mapping scheme (which we've used for 
years) for both platforms such that a cpu is bound (and is set in 
cpumask_of_node()) to each fake node with which it has physical affinity.  
That is the only way for zonelist ordering in node order, task migration 
from offlined cpus, correct sched domains, etc.  I can propose a patchset 
for x86_64 to do exactly this if there aren't any objections and I hope 
you'll help do ppc.
