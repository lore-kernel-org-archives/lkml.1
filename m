Return-Path: <linux-kernel-owner+w=401wt.eu-S1753664AbZA0Wr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664AbZA0Wr6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 17:47:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbZA0Wrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 17:47:45 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:29064 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbZA0Wro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 17:47:44 -0500
Message-ID: <497F8F02.9000603@hp.com>
Date: Tue, 27 Jan 2009 14:47:30 -0800
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; HP-UX 9000/785; en-US; rv:1.7.13) Gecko/20060601
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: cl@linux-foundation.org, tj@kernel.org, rusty@rustcorp.com.au,
       mingo@elte.hu, herbert@gondor.apana.org.au, akpm@linux-foundation.org,
       hpa@zytor.com, brgerst@gmail.com, ebiederm@xmission.com, travis@sgi.com,
       linux-kernel@vger.kernel.org, steiner@sgi.com, hugh@veritas.com,
       netdev@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
Subject: Re: [PATCH] percpu: add optimized generic percpu accessors
References: <200901271213.18605.rusty@rustcorp.com.au>	<497E705B.5000302@kernel.org>	<alpine.DEB.1.10.0901271506580.3114@qirst.com> <20090127.134747.153565246.davem@davemloft.net>
In-Reply-To: <20090127.134747.153565246.davem@davemloft.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Christoph Lameter <cl@linux-foundation.org>
> Date: Tue, 27 Jan 2009 15:08:57 -0500 (EST)
> 
> 
>>On Tue, 27 Jan 2009, Tejun Heo wrote:
>>
>>
>>>>later). That's because they use TLB tricks for a static 64k per-cpu
>>>>area, but this doesn't scale.  That might not be vital: abandoning
>>>>that trick will mean they can't optimise read_percpu/read_percpu_var
>>>>etc as much.
>>
>>Why wont it scale? this is a separate TLB entry for each processor.
> 
> 
> The IA64 per-cpu TLB entry only covers 64k which makes use of it for
> dynamic per-cpu stuff out of the question.  That's why it "doesn't
> scale"

I was asking around, and was told that on IA64 *harware* at least, in addition to 
supporting multiple page sizes (up to a GB IIRC), one can pin up to 8 or perhaps 
1/2 the TLB entries.

So, in theory if one were so inclined the special pinned per-CPU entry could 
either be more than one 64K entry, or a single, rather larger entry.

As a sanity check, I've cc'd linux-ia64.

rick jones
