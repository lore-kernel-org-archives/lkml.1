Return-Path: <linux-kernel-owner+w=401wt.eu-S1756216AbZAMAeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216AbZAMAeQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 19:34:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbZAMAeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 19:34:00 -0500
Received: from hera.kernel.org ([140.211.167.34]:46627 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189AbZAMAd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 19:33:59 -0500
Message-ID: <496BE157.2000009@kernel.org>
Date: Tue, 13 Jan 2009 09:33:27 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Christoph Lameter <cl@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       travis@sgi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, steiner@sgi.com,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: regarding the x86_64 zero-based percpu patches
References: <49649814.4040005@kernel.org> <20090107120225.GA30651@elte.hu>	<49649C65.6000706@kernel.org>	<200901101716.04220.rusty@rustcorp.com.au>	<Pine.LNX.4.64.0901121120280.30369@quilx.com> <m1mydwxvtx.fsf@frodo.ebiederm.org>
In-Reply-To: <m1mydwxvtx.fsf@frodo.ebiederm.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 13 Jan 2009 00:33:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Eric.

Eric W. Biederman wrote:
>> There are 2M TLB entries on x86_64. If we really get into a high usage
>> scenario then the 2M entry makes sense. Average server memory sizes likely
>> already are way beyond 10G per box. The higher that goes the more
>> reasonable the 2M TLB entry will be.
> 
> 2M of per cpu data doesn't make sense, and likely indicates a design
> flaw somewhere.  It just doesn't make sense to have large amounts of
> data allocated per cpu.

Why?  On almost all large machines I've seen or heard of, memory size
scales way better than the number of cpus.  Whether certain usage
makes sense or not surely is debatable but I can't imagine all use
cases where 2MB percpu TLB entry could be useful would be senseless.

> The most common user of per cpu data I am aware of is allocating one
> word per cpu for counters.
> 
> What would be better is simply to: 
> - Require a lock to access another cpus per cpu data.
> - Do large page allocations for the per cpu data.
> 
> At which point we could grow the per cpu data by simply reallocating it on
> each cpu and updating the register that holds the base pointer.

I don't think moving live objects is such a good idea for the
following reasons.

1. Programming convenience is usually much more important than people
   think it is.  Even in the kernel.  I think it's very likely that
   we'll have unending stream of small feature requirements which
   would step just outside the supported bounds and ever smart
   workaround until the restriction is finally removed years later.

2. Moving live objects is inherently dangerous + it won't happen
   often.  Thinking about possible subtle bugs is scary.

Thanks.

-- 
tejun
