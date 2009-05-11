Return-Path: <linux-kernel-owner+w=401wt.eu-S1759893AbZEKVzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759893AbZEKVzj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 17:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757263AbZEKVz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 17:55:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:37936 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756336AbZEKVz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 17:55:26 -0400
Message-ID: <4A089E53.8010106@kernel.org>
Date: Mon, 11 May 2009 14:53:23 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 2/3] x86: add numa_move_cpus_to_node
References: <4A05269D.8000701@kernel.org> <4A052721.4010201@kernel.org> <alpine.DEB.1.10.0905112126410.28512@qirst.com>
In-Reply-To: <alpine.DEB.1.10.0905112126410.28512@qirst.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Fri, 8 May 2009, Yinghai Lu wrote:
> 
>> when node only have hot add range and don't have other static range.
>> that node will not be onlined, and cpus on that will be linked to nearby
>> node with memory.
>> then when that host add range is added later, we need to linked those cpus
>> back.
> 
> This going to be fun for the allocators that have put their queues on the
> respective nodes. How are the various OS structures that were allocated on
> the node that is downed / upped relocated?

NODE_DATA is new allocated on that node is backed on line for the first time.

per_cpu will still stay with old near node. because per_cpu is somehow preallocated for all possible cpu.

YH
