Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384Ab0CKWbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 17:31:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:56835 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279Ab0CKWbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 17:31:15 -0500
Message-ID: <4B996FAE.3030102@kernel.org>
Date: Fri, 12 Mar 2010 07:33:18 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-3.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [RFC] remove implicit slab.h inclusion from percpu.h
References: <4B990496.4020002@kernel.org> <20100311174821.GA5123@x200>
In-Reply-To: <20100311174821.GA5123@x200>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Mar 2010 22:30:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 03/12/2010 02:48 AM, Alexey Dobriyan wrote:
>> So, what do you guys think?  Probably-the-right-thing-to-do >544 file
>> patch or somewhat-ugly-but-let's-worry-about-it-tommorrow two file
>> patch?
> 
> You can include slab.h only for UP case.
> 
> Since everyone tests on allmodconfig which has SMP=y, configuration
> will be more strict wrt headers, and compile breakages amount
> negligible.

But that wouldn't change anything about having to do an oneshot huge
change, right?  And, if we're gonna do that anyway, I think it would
be better to remove the implicit dependency for UP case too so that
for example slab.h in this case doesn't have to do ifdef on CONFIG_SMP
before using percpu accessors.

Thanks.

-- 
tejun
