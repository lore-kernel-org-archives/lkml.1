Return-Path: <linux-kernel-owner+w=401wt.eu-S1754219Ab0AUDAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab0AUDAL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 22:00:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754067Ab0AUDAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 22:00:06 -0500
Received: from mga05.intel.com ([192.55.52.89]:32924 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753499Ab0AUDAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 22:00:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,314,1262592000"; 
   d="scan'208";a="533109488"
Message-ID: <4B57C330.7020505@linux.intel.com>
Date: Thu, 21 Jan 2010 11:00:00 +0800
From: Haicheng Li <haicheng.li@linux.intel.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: set hotpluggable nodes in nodes_possible_map
References: <4B501C4D.4080907@linux.intel.com> <alpine.DEB.2.00.1001171338170.16238@chino.kir.corp.google.com> <86802c441001172230y137b4916h7d744a96ab75873d@mail.gmail.com> <alpine.DEB.2.00.1001180231430.20677@chino.kir.corp.google.com> <4B5592B1.9030800@linux.intel.com> <alpine.DEB.2.00.1001191513010.24223@chino.kir.corp.google.com> <4B5731E2.4040207@linux.intel.com> <alpine.DEB.2.00.1001201152040.30528@chino.kir.corp.google.com> <4B578797.3040908@kernel.org>
In-Reply-To: <4B578797.3040908@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> 
>         if (ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE) {
>                 update_nodes_add(node, start, end);
>                 /* restore nodes[node] */
>                 *nd = oldnode;
>                 if ((nd->start | nd->end) == 0)
>                         node_clear(node, nodes_parsed);
>         }
> 
> removing clearing with nodes_parsed is not working?
> 
> YH

Yinghai,

Theoretically removing clearing with nodes_parsed can work fine except that it requires more 
consideration, since some functions already based on nodes_parsed, like acpi_get_nodes(), is 
supposing nodes_parsed just represents for nodes with memory on.

See my another email to David, I think we'd better keep hotpluggable node info separately since it 
is straightforward as well as would be useful for future hotplug related usage. How do you think 
about it? thanks.

-haicheng
