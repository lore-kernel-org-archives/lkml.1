Return-Path: <linux-kernel-owner+w=401wt.eu-S1756112AbXLHEqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112AbXLHEqF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 23:46:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbXLHEpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 23:45:54 -0500
Received: from smtp-out.google.com ([216.239.33.17]:61843 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345AbXLHEpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 23:45:53 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=yq0/rS5016/gf05sUGQE2e2HJkv/dYIha69CILnS/yPg3azBssPIp3tvks8KBzldO
	Jt3yB6DyDedURtWxvyVeQ==
Date: Fri, 7 Dec 2007 20:45:21 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Balbir Singh <balbir@linux.vnet.ibm.com>
cc: linuxppc-dev@ozlabs.org, Nathan Lynch <ntl@pobox.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fake NUMA emulation for PowerPC
In-Reply-To: <475A1E6E.3010303@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.0.9999.0712072040300.26622@chino.kir.corp.google.com>
References: <20071207211425.10223.91240.sendpatchset@balbir-laptop> <20071207221106.GH16824@localdomain> <4759C89B.9000709@linux.vnet.ibm.com> <alpine.DEB.0.9999.0712071510370.27689@chino.kir.corp.google.com> <475A1E6E.3010303@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Dec 2007, Balbir Singh wrote:

> > You're going to want to distribute the cpu's based on how they match up 
> > physically with the actual platform that you're running on.  x86_64 does 
> 
> Could you explain this better, how does it match up CPU's with fake NUMA
> memory? Is there some smartness there? I'll try and look at the code and
> also see what I can do for PowerPC
> 

numa_cpumask_lookup_table[] would return the correct cpumask for the fake 
node index.  Then all the code that uses node_to_cpumask() in generic 
kernel code like the scheduler and VM still preserve their true NUMA 
affinity that matches the underlying hardware.  I tried to make x86_64 
fake NUMA as close to the real thing as possible.

You also probably want to make all you changes dependent on 
CONFIG_NUMA_EMU like the x86_64 case.  That'll probably be helpful as you 
extend this tool more and more.

		David
