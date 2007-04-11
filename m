Return-Path: <linux-kernel-owner+w=401wt.eu-S1750948AbXDKHdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750948AbXDKHdX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 03:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750961AbXDKHdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 03:33:22 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:31899 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750948AbXDKHdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 03:33:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=oPfzQs6UpBKrvkfwnDBYkGvNiJ/Vh26RmnFDBEsqXt0Pgz4KjvR7HvCN5GuzBougVtR9jYVpEmxBRVZQCac12n0+N4vJgeOcgc7W88fm0UA7rAVrQ7xMHuIQf/yhmJFiYSIUBdPlDalK14CrVwnFqXxMVYJ8+bhWkMBNkZPyArc=  ;
X-YMail-OSG: XDFisu0VM1lmBMA5bDBtuDnhXRhaC.p46P2vyf.qHbRKWjvEbqYAkkFe8F82BvXNm8Y.86NGhg--
Message-ID: <461C8F3B.1010502@yahoo.com.au>
Date: Wed, 11 Apr 2007 17:33:15 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/13] maps#2: Move the page walker code to lib/
References: <7.469046093@selenic.com>	<461C81C0.9040003@yahoo.com.au> <20070411001717.02ae5640.akpm@linux-foundation.org>
In-Reply-To: <20070411001717.02ae5640.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 11 Apr 2007 16:35:44 +1000 Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
> 
>>Matt Mackall wrote:
>>
>>>Move the page walker code to lib/
>>>
>>>This lets it get shared outside of proc/ and linked in only when
>>>needed.
>>
>>Still should go into mm/
> 
> 
> spose so.
> 
> 
>>If it had, you might have also noticed your pagetable walking code
>>is completely different from how everyone else does it, and fixed
>>that too.
> 
> 
> Different in what way?


The form of the loops. It may not seem like a big deal, but before
Hugh did a big cleanup to make them all the same, we had about a
dozen versions which were all very slightly different ;) It was
painful.

>>BTW. Is it the case that unused and unexported symbols don't get
>>pruned by the linker except inside lib/?
> 
> 
> If they're static and unreferenced then the linker will remove them.  Of
> course, usually humans remove these because they generate warnings, unless
> special-things happen.  We deliberately do special-things with
> register_cpu_notifier() so the notifier-block and the handler go away if
> !CONFIG_HOTPLUG_CPU.
> 
> If the functions are non-static then yes, I expect we end up with them in
> vmlinux.  There are tricks we can play with -ffunction-sections to fix
> that, but we don't.  

They aren't static. But anyway, AFAIKS, all the CONFIG_ stuff is
there anyway, so we can not only avoid the linking but also the
compiling by using them.

-- 
SUSE Labs, Novell Inc.
