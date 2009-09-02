Return-Path: <linux-kernel-owner+w=401wt.eu-S1751422AbZIBUJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422AbZIBUJH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 16:09:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750943AbZIBUJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 16:09:07 -0400
Received: from smtp-out.google.com ([216.239.45.13]:11404 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbZIBUJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 16:09:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:content-id:x-system-of-record;
	b=F6+3v3DTdYldQfJaLtAKsbeuZpme2TDvDbyz5QP3Ls1WCLddkQdibJAwAqaj3y00C
	iLquRlItFy9KgDyEYIGdA==
Date: Wed, 2 Sep 2009 13:09:01 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Balbir Singh <balbir@linux.vnet.ibm.com>
cc: Ankita Garg <ankita@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] Fix fake numa on ppc
In-Reply-To: <661de9470909021256i569261bxbe1523d8e37b5b14@mail.gmail.com>
Message-ID: <alpine.DEB.1.00.0909021304210.13939@chino.kir.corp.google.com>
References: <20090902060911.GA5728@in.ibm.com> <alpine.DEB.1.00.0909012326290.31814@chino.kir.corp.google.com> <20090902080346.GB3806@in.ibm.com> <alpine.DEB.1.00.0909021226160.10279@chino.kir.corp.google.com>
 <661de9470909021256i569261bxbe1523d8e37b5b14@mail.gmail.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531381004-1054151817-1251921958=:13939"
Content-ID: <alpine.DEB.1.00.0909021306360.13939@chino.kir.corp.google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531381004-1054151817-1251921958=:13939
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.1.00.0909021306361.13939@chino.kir.corp.google.com>

On Thu, 3 Sep 2009, Balbir Singh wrote:

> > Right, I'm proposing an alternate mapping scheme (which we've used for
> > years) for both platforms such that a cpu is bound (and is set in
> > cpumask_of_node()) to each fake node with which it has physical affinity.
> > That is the only way for zonelist ordering in node order, task migration
> > from offlined cpus, correct sched domains, etc.  I can propose a patchset
> > for x86_64 to do exactly this if there aren't any objections and I hope
> > you'll help do ppc.
> 
> Sounds interesting, I'd definitely be interested in seeing your
> proposal, but I would think of that as additional development on top
> of this patch
> 

Absolutely.  I'm not familiar with numa=fake on ppc, but if cpus are being 
bound to nodes with which they don't have affinity, it definitely warrants 
a fix such as this (although the initial value for fake_enabled looks 
wrong and fake_numa_node_mapping[] can be __cpuinitdata).  I'll cc you, 
Ben, and Ankita on the x86_64 patches.  Thanks.
--531381004-1054151817-1251921958=:13939--
