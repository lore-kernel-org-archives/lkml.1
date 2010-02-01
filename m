Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922Ab0BADhO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 22:37:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57558 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640Ab0BADhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 22:37:12 -0500
Message-ID: <4B664AE5.2020306@zytor.com>
Date: Sun, 31 Jan 2010 19:30:45 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, axboe@kernel.dk, rusty@rustcorp.com.au,
       akpm@linux-foundation.org, ebiederm@xmission.com, tytso@mit.edu,
       Trond.Myklebust@netapp.com, aelder@sgi.com, hch@infradead.org,
       viro@zeniv.linux.org.uk, davem@davemloft.net, netdev@vger.kernel.org,
       x86@kernel.org, mingo@redhat.com, fweisbec@gmail.com,
       dan.j.williams@intel.com, borislav.petkov@amd.com, ying.huang@intel.com,
       lenb@kernel.org, neilb@suse.de, cl@linux-foundation.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 5/8] percpu: add __percpu sparse annotations to x86
References: <1264432935-10453-1-git-send-email-tj@kernel.org> <1264432935-10453-6-git-send-email-tj@kernel.org> <4B5E401C.1050605@zytor.com> <4B5E50D0.8050705@kernel.org>
In-Reply-To: <4B5E50D0.8050705@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2010 06:17 PM, Tejun Heo wrote:
> On 01/26/2010 10:06 AM, H. Peter Anvin wrote:
>> On 01/25/2010 07:22 AM, Tejun Heo wrote:
>>>
>>> In arch/x86/kernel/cpu/common.c, per_cpu(exception_stacks, cpu) is
>>> replaced with &per_cpu(exception_stacks[0], cpu) which is equivalent
>>> except that it allows per_cpu() macro to correctly drop percpu
>>> designation during sparse pass.
>>>
>>
>> Same comment as Frederic's about this... this kind of uglification
>> really is unacceptable and needs to be addressed.
> 
> Hmm... I don't think it's too bad but if you don't like it that much,
> probably the right thing to do is just leave it there and let sparse
> whine about it.  There are only three in-kernel instances at this
> point, so it's not that big a deal.
> 

That would probably be my preference until it can be fixed in a better
way.  If we paper it over now, it will be forgotten -- and then someone
will come along and cargo cult it for no good reason.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

