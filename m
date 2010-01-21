Return-Path: <linux-kernel-owner+w=401wt.eu-S1753844Ab0AUHvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844Ab0AUHvF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 02:51:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753898Ab0AUHvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 02:51:03 -0500
Received: from smtp-out.google.com ([216.239.44.51]:13645 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab0AUHvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 02:51:00 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=SlaAotBMlxOP57VpNiRBKjiCyjXpahvVnakdsmYV53G7gu1zP+5x8R+HmQfZbHWup
	4eyLUpPgOiHhVsT2FM5tQ==
Date: Wed, 20 Jan 2010 23:50:54 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Haicheng Li <haicheng.li@linux.intel.com>
cc: Ingo Molnar <mingo@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: set hotpluggable nodes in nodes_possible_map
In-Reply-To: <4B5802EF.6040603@linux.intel.com>
Message-ID: <alpine.DEB.2.00.1001202344580.29982@chino.kir.corp.google.com>
References: <4B501C4D.4080907@linux.intel.com> <alpine.DEB.2.00.1001171338170.16238@chino.kir.corp.google.com> <86802c441001172230y137b4916h7d744a96ab75873d@mail.gmail.com> <alpine.DEB.2.00.1001180231430.20677@chino.kir.corp.google.com> <4B5592B1.9030800@linux.intel.com>
 <alpine.DEB.2.00.1001191513010.24223@chino.kir.corp.google.com> <4B5731E2.4040207@linux.intel.com> <alpine.DEB.2.00.1001201152040.30528@chino.kir.corp.google.com> <4B57C2DD.3050402@linux.intel.com> <alpine.DEB.2.00.1001202252320.22343@chino.kir.corp.google.com>
 <4B5802EF.6040603@linux.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jan 2010, Haicheng Li wrote:

> > Nack, we don't need to add yet another nodemask because you're having
> > trouble finding a new name for a cpu_nodes_parsed.  It would be perfectly 
> Hey Dave, why do you think it's just a naming issue?
> 
> What I'm concerning is that your assumption of cpu_nodes_parsed use is wrong,
> cpu_nodes_parsed is needed anyway since its semantics represent the node with
> cpu affinity rather than memless node, that's also why I originally doubted
> cpu_node_parsed cannot handle hotplug node.

Wrong, cpu_nodes_parsed (despite its name) solely represents nodes that do 
not have online address memory ranges.  That's it.  Nothing more, nothing 
less.  That's why I suggest you rename it to no_mem_nodes or something 
similar.  Look at the single time that the nodemask is used: to set 
cleared bits in node_possible_map that were not set in nodes_parsed 
because THEY DO NOT HAVE ASSOCIATED ONLINE MEMORY RANGES, the _only_ time 
a node gets set in nodes_parsed.

Once you rename nodes_parsed to mem_nodes and cpu_nodes_parsed to 
no_mem_nodes, it may become clearer.

> we also need hp_nodes_parsed to represent the node with hotpluggable memory
> region, just like why we need nodes_parsed to repsent node with mem on.
> 

It's pointless to add another nodemask, the semantics of cpu_nodes_parsed 
is perfectly legitimate for hotpluggable nodes as well.  Instead of 
fixating on the name, look at the code that uses it.
