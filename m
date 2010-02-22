Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab0BVVP5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 16:15:57 -0500
Received: from smtp-out.google.com ([216.239.33.17]:11408 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934Ab0BVVP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 16:15:56 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=oT2zggy/yd+BWLduAEWa/MNA/apcanEaBMKCGCbUdPa59HCtzQI6WqNvjU5x80Ss1
	H263gI961fKhhNK6+83Uw==
Date: Mon, 22 Feb 2010 13:15:49 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vivek Goyal <vgoyal@redhat.com>
cc: Andrea Righi <arighi@develer.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Suleiman Souhlal <suleiman@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH 0/2] memcg: per cgroup dirty limit
In-Reply-To: <20100222182934.GD3096@redhat.com>
Message-ID: <alpine.DEB.2.00.1002221307180.14426@chino.kir.corp.google.com>
References: <1266765525-30890-1-git-send-email-arighi@develer.com> <20100222142744.GB13823@redhat.com> <20100222181226.GC4052@linux> <20100222182934.GD3096@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Feb 2010, Vivek Goyal wrote:

> dirty_ratio is easy to configure. One system wide default value works for
> all the newly created cgroups. For dirty_bytes, you shall have to
> configure each and individual cgroup with a specific value depneding on
> what is the upper limit of memory for that cgroup.
> 

Agreed, it makes sense for each memcg to have a dirty_ratio that defaults 
to whatever vm_dirty_ratio does, and export that constant via 
linux/writeback.h.  dirty_bytes would then use the same semantics as 
globally so that if it is set to 0, the finer-granuality is disabled by 
default and we use memcg->dirty_ratio instead.

> Secondly, memory cgroup kind of partitions global memory resource per
> cgroup. So if as long as we have global dirty ratio knobs, it makes sense
> to have per cgroup dirty ratio knob also. 
> 

It has a good default, too: whatever ratio of memory that was allowed to 
be dirty before the memcg limit was set is still allowed by default.
