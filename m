Return-Path: <linux-kernel-owner+w=401wt.eu-S1763938AbXGFRa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763938AbXGFRa1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 13:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760454AbXGFRaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 13:30:16 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:51931 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757852AbXGFRaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 13:30:15 -0400
Subject: Re: [-mm PATCH 2/8] Memory controller containers setup (v2)
From: Dave Hansen <haveblue@us.ibm.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelianov <xemul@openvz.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux MM Mailing List <linux-mm@kvack.org>,
       Eric W Biederman <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>,
       Paul Menage <menage@google.com>
In-Reply-To: <20070706052103.11677.4158.sendpatchset@balbir-laptop>
References: <20070706052029.11677.16964.sendpatchset@balbir-laptop>
	 <20070706052103.11677.4158.sendpatchset@balbir-laptop>
Content-Type: text/plain
Date: Fri, 06 Jul 2007 10:30:09 -0700
Message-Id: <1183743009.10287.157.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-05 at 22:21 -0700, Balbir Singh wrote:
> +struct mem_container {
> +	struct container_subsys_state css;
> +	/*
> +	 * the counter to account for memory usage
> +	 */
> +	struct res_counter res;
> +};

How about we call it "memory_usage"?  That would kill two birds with one
stone: get rid of the comment, and keep people from needing to refer to
the comment to figure out what "res" *IS*. 

> +/*
> + * A meta page is associated with every page descriptor. The meta page
> + * helps us identify information about the container
> + */
> +struct meta_page {
> +	struct list_head list;		/* per container LRU list */
> +	struct page *page;
> +	struct mem_container *mem_container;
> +};

Why not just rename "list" to "lru_list" or "container_lru"?

> +
> +static inline struct mem_container *mem_container_from_cont(struct container
> +								*cnt)

I'd probably break that line up differently:

static inline
struct mem_container *mem_container_from_cont(struct container *cnt)

BTW, do I see "cnt" meaning "container" now instead of "cnt"?  ;)

Is somebody's favorite dog named "cnt" and you're just trying to remind
yourself of them as often as possible?

-- Dave

