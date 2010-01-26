Return-Path: <linux-kernel-owner+w=401wt.eu-S1753536Ab0AZCMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536Ab0AZCMV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 21:12:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892Ab0AZCMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 21:12:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:53648 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325Ab0AZCMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 21:12:17 -0500
Message-ID: <4B5E50D0.8050705@kernel.org>
Date: Tue, 26 Jan 2010 11:17:52 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org, axboe@kernel.dk, rusty@rustcorp.com.au,
       akpm@linux-foundation.org, ebiederm@xmission.com, tytso@mit.edu,
       Trond.Myklebust@netapp.com, aelder@sgi.com, hch@infradead.org,
       viro@zeniv.linux.org.uk, davem@davemloft.net, netdev@vger.kernel.org,
       x86@kernel.org, mingo@redhat.com, fweisbec@gmail.com,
       dan.j.williams@intel.com, borislav.petkov@amd.com, ying.huang@intel.com,
       lenb@kernel.org, neilb@suse.de, cl@linux-foundation.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 5/8] percpu: add __percpu sparse annotations to x86
References: <1264432935-10453-1-git-send-email-tj@kernel.org> <1264432935-10453-6-git-send-email-tj@kernel.org> <4B5E401C.1050605@zytor.com>
In-Reply-To: <4B5E401C.1050605@zytor.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 26 Jan 2010 02:11:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2010 10:06 AM, H. Peter Anvin wrote:
> On 01/25/2010 07:22 AM, Tejun Heo wrote:
>>
>> In arch/x86/kernel/cpu/common.c, per_cpu(exception_stacks, cpu) is
>> replaced with &per_cpu(exception_stacks[0], cpu) which is equivalent
>> except that it allows per_cpu() macro to correctly drop percpu
>> designation during sparse pass.
>>
> 
> Same comment as Frederic's about this... this kind of uglification
> really is unacceptable and needs to be addressed.

Hmm... I don't think it's too bad but if you don't like it that much,
probably the right thing to do is just leave it there and let sparse
whine about it.  There are only three in-kernel instances at this
point, so it's not that big a deal.

Thanks.

-- 
tejun
