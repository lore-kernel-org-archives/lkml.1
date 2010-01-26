Return-Path: <linux-kernel-owner+w=401wt.eu-S1752555Ab0AZBO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab0AZBO5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 20:14:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066Ab0AZBOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 20:14:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:57367 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039Ab0AZBOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 20:14:50 -0500
Message-ID: <4B5E4308.8020105@kernel.org>
Date: Tue, 26 Jan 2010 10:19:04 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: linux-kernel@vger.kernel.org, axboe@kernel.dk, rusty@rustcorp.com.au,
       akpm@linux-foundation.org, ebiederm@xmission.com, tytso@mit.edu,
       Trond.Myklebust@netapp.com, aelder@sgi.com, hch@infradead.org,
       viro@zeniv.linux.org.uk, davem@davemloft.net, netdev@vger.kernel.org,
       x86@kernel.org, mingo@redhat.com, dan.j.williams@intel.com,
       borislav.petkov@amd.com, ying.huang@intel.com, lenb@kernel.org,
       neilb@suse.de, cl@linux-foundation.org
Subject: Re: [PATCH 7/8] percpu: add __percpu sparse annotations to	hw_breakpoint
References: <1264432935-10453-1-git-send-email-tj@kernel.org> <1264432935-10453-8-git-send-email-tj@kernel.org> <20100126001901.GI5087@nowhere> <4B5E3BED.6030705@kernel.org> <20100126010239.GK5087@nowhere>
In-Reply-To: <20100126010239.GK5087@nowhere>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 26 Jan 2010 01:12:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 01/26/2010 10:02 AM, Frederic Weisbecker wrote:
> Well, sorry I must be missing something obvious, but is it impossible
> to make per_cpu(var, cpu) returning something cast in:
> 
> 	(typeof(var) __force)
> 
> Or I guess you did that already and it is not working with static
> arrays, or?

Yeap, the definition looks like

 #define SHIFT_PERCPU_PTR(__p, __offset)	({			\
	__verify_pcpu_ptr((__p));					\
	RELOC_HIDE((typeof(*(__p)) __kernel __force *)(__p), (__offset)); \
 })

 #define per_cpu(var, cpu) \
	(*SHIFT_PERCPU_PTR(&(var), per_cpu_offset(cpu)))

but it just ends up putting the __force at the wrong layer.  It seems
that (typeof(var) __kernel __force) tell sparse var is in the kernel
address space but not its members.

> Is there a patch that shows per_cpu() macro changes in the batch?

Sorry I forgot to write about this.  It's in the percpu tree.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-next

The related commits are 545695fb41da117928ab946067a42d9e15fd009d and
e0fdb0e050eae331046385643618f12452aa7e73.

Thanks.

-- 
tejun
