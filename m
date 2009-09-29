Return-Path: <linux-kernel-owner+w=401wt.eu-S1753735AbZI2APY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbZI2APY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 20:15:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753702AbZI2APP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 20:15:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:47594 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753575AbZI2APN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 20:15:13 -0400
Message-ID: <4AC15182.4020603@kernel.org>
Date: Tue, 29 Sep 2009 09:14:58 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, mingo@elte.hu, hpa@zytor.com
Subject: Re: [PATCH 2/3] sparc64: implement page mapping percpu first chunk
 allocator
References: <4ABB6C3A.8070109@kernel.org>	<4ABB6C80.20109@kernel.org> <20090928.143656.208349447.davem@davemloft.net>
In-Reply-To: <20090928.143656.208349447.davem@davemloft.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 29 Sep 2009 00:15:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, David.

David Miller wrote:
> From: Tejun Heo <tj@kernel.org>
> Date: Thu, 24 Sep 2009 21:56:32 +0900
> 
>> Implement page mapping percpu first chunk allocator as a fallback to
>> the embedding allocator.  The next patch will make the embedding
>> allocator check distances between units to determine whether it fits
>> within the vmalloc area so that this fallback can be used on such
>> cases.
>>
>> sparc64 currently has relatively small vmalloc area which makes it
>> impossible to create any dynamic chunks on certain configurations
>> leading to percpu allocation failures.  This and the next patch should
>> allow those configurations to keep working until proper solution is
>> found.
>>
>> Signed-off-by: Tejun Heo <tj@kernel.org>
>> ---
>> David, can you please ack this after reviewing?
> 
> Tejun I am testing out the following patch which will make these
> patches of your's basically unnecessary:

Ah... great but unless you object, I think it would be better to push
it out anyway just to make things a bit more robust and ease tracking
and debugging when something goes wrong.  The added code is small and
ditched once boot is complete.  What do you think?

Thanks.

-- 
tejun
