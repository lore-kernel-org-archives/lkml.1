Return-Path: <linux-kernel-owner+w=401wt.eu-S1752712Ab0AZBQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712Ab0AZBQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 20:16:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126Ab0AZBQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 20:16:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35952 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745Ab0AZBQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 20:16:23 -0500
Message-ID: <4B5E3F2C.2010702@zytor.com>
Date: Mon, 25 Jan 2010 17:02:36 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, axboe@kernel.dk,
       rusty@rustcorp.com.au, akpm@linux-foundation.org, ebiederm@xmission.com,
       tytso@mit.edu, Trond.Myklebust@netapp.com, aelder@sgi.com,
       hch@infradead.org, viro@zeniv.linux.org.uk, davem@davemloft.net,
       netdev@vger.kernel.org, x86@kernel.org, mingo@redhat.com,
       dan.j.williams@intel.com, borislav.petkov@amd.com, ying.huang@intel.com,
       lenb@kernel.org, neilb@suse.de, cl@linux-foundation.org
Subject: Re: [PATCH 7/8] percpu: add __percpu sparse annotations to	hw_breakpoint
References: <1264432935-10453-1-git-send-email-tj@kernel.org> <1264432935-10453-8-git-send-email-tj@kernel.org> <20100126001901.GI5087@nowhere>
In-Reply-To: <20100126001901.GI5087@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2010 04:19 PM, Frederic Weisbecker wrote:
> On Tue, Jan 26, 2010 at 12:22:14AM +0900, Tejun Heo wrote:
>> Add __percpu sparse annotations to hw_breakpoint.
>>
>> These annotations are to make sparse consider percpu variables to be
>> in a different address space and warn if accessed without going
>> through percpu accessors.  This patch doesn't affect normal builds.
>>
>> per_cpu(nr_task_bp_pinned, cpu) is replaced with
>> &per_cpu(nr_task_bp_pinned[0], cpu).  This is the same to the compiler
>> but allows per_cpu() macro to correctly drop __percpu designation for
>> the returned pointer.
> 
> Ouch... It's unpleasant to see such workaround that messes up the
> code just to make sparse happy.
> 
> I guess __percpu is an address_space attribute? Is there no
> way to force the address space change directly from the
> per_cpu() macro?
> 

A cast (using __typeof__) combined with an address space override?

	-hpa
