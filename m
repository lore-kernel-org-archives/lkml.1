Return-Path: <linux-kernel-owner+w=401wt.eu-S932197AbZAOVyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197AbZAOVyV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 16:54:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753984AbZAOVyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 16:54:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:33559 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753706AbZAOVyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 16:54:09 -0500
Message-ID: <496FB05F.4020101@kernel.org>
Date: Fri, 16 Jan 2009 06:53:35 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Brian Gerst <brgerst@gmail.com>,
       ebiederm@xmission.com, cl@linux-foundation.org, rusty@rustcorp.com.au,
       travis@sgi.com, linux-kernel@vger.kernel.org, steiner@sgi.com,
       hugh@veritas.com
Subject: Re: [PATCH] percpu: add optimized generic percpu accessors
References: <496F0F50.6070200@kernel.org> <20090115113045.GG22850@elte.hu> <496F2032.5080502@kernel.org> <20090115122611.GJ22850@elte.hu> <496F346B.6020804@kernel.org> <20090115130740.GE21839@elte.hu> <496F38C7.5000403@kernel.org> <20090115093007.4215b4b4.akpm@linux-foundation.org> <20090115180259.GJ22472@elte.hu> <20090115103406.a85968f0.akpm@linux-foundation.org> <20090115183942.GA6325@elte.hu>
In-Reply-To: <20090115183942.GA6325@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 15 Jan 2009 21:53:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>>> and "this is preempt safe" semantics.
>> Of course.  But do any architectures actually _need_ that for a single 
>> read?
> 
> not for a read i guess - but for the other ops like add/and/or/xor.

FWIW, it prevents cross-cpu cacheline contamination.  :-)

>> Maybe.  And if so, they can interpose their arch-specific 
>> implementation.  But if the generic version is optimal for them, they 
>> wouldn't need to..
> 
> we cannot turn the generic ops into a single instruction so arch methods 
> are preferable no matter how thick or thin the generic version is. But i 
> agree that the optimization you suggest could be done.

I think the preemption protection is good to have there for, if
nothing else, documentation.

Thanks.

-- 
tejun
