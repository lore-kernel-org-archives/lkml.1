Return-Path: <linux-kernel-owner+w=401wt.eu-S1759266AbYEBFRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759266AbYEBFRi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 01:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752345AbYEBFR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 01:17:26 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:44393 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330AbYEBFRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 01:17:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:x-x-sender:to:cc:subject:in-reply-to:message-id:references:user-agent:mime-version:content-type:from;
        b=D9Zcoi3gxOGoKqPkWFhz9NIsKO+1sPSqOUXTJokjrZimjbm4BAydAvTyq1quXGglq0aRTneomOi9K8XNEL4rsoxBf9+MSXsnHiTfETFGaH7rYUXdEYv7NqGrW6U0GF9sZcyEH8mU0tF4Um9QxpppU2wFL5WmYZMWVZFtIY+yPEQ=
Date: Fri, 2 May 2008 13:21:24 +0800 (CST)
X-X-Sender: wangcong@localhost.localdomain
To: Herbert Xu <herbert@gondor.apana.org.au>
cc: WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
       davem@davemloft.net, akpm@osdl.org, netdev@vger.kernel.org
Subject: Re: [Patch]net/xfrm/xfrm_policy.c: replace timer with delayed_work
In-Reply-To: <20080501011123.GA4060@gondor.apana.org.au>
Message-ID: <alpine.LFD.1.10.0805021319200.3349@localhost.localdomain>
References: <20080216.235534.237382205.xiyou.wangcong@gmail.com> <20080427011809.GA662@gondor.apana.org.au> <20080428.225312.58450957.xiyou.wangcong@gmail.com> <20080428151342.GA12007@gondor.apana.org.au> <alpine.LFD.1.10.0804302355120.2940@localhost.localdomain>
 <20080501011123.GA4060@gondor.apana.org.au>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
From: WANG Cong <xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2008, Herbert Xu wrote:

> On Thu, May 01, 2008 at 12:06:55AM +0800, WANG Cong wrote:
>> 
>> Hi, Herbert.
>> 
>> I referenced the book Linux Device Drivers, it is said that
>> the work function in workqueue can sleep, that is to say, it only
>> works in process context, so we don't need the disable the lock
>> in softirq, which is interrupt context, right?
>
> Because it can sleep, you must disable BH for locks that can
> be taken on the softirq path as otherwise a softirq can come
> in, try to take the lock again and dead-lock.

Yes, I was an idiot.

I will resend the revised patches right now.
