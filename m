Return-Path: <linux-kernel-owner+w=401wt.eu-S1754656AbXHSHiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbXHSHiK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 03:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751361AbXHSHh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 03:37:59 -0400
Received: from il.qumranet.com ([82.166.9.18]:41834 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbXHSHh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 03:37:58 -0400
Message-ID: <46C7F362.80106@qumranet.com>
Date: Sun, 19 Aug 2007 10:38:10 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Laurent Vivier <Laurent.Vivier@bull.net>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [kvm-devel] [PATCH/RFC 3/4]Introduce "account modifiers" mechanism
References: <46C4719A.2060308@bull.net> <46C4720F.7030304@bull.net>		<46C4725A.4070607@bull.net> <46C4740F.2050701@bull.net>		<1187303955.6449.7.camel@localhost.localdomain>	<46C54FB8.7050504@bull.net>	<1187339450.6449.115.camel@localhost.localdomain> <46C56774.2030009@bull.net> <46C59AB1.6070505@qumranet.com> <46C5ACE8.2050004@bull.net>
In-Reply-To: <46C5ACE8.2050004@bull.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Vivier wrote:
> Avi Kivity wrote:
> [...]
>   
>> The normal user/system accounting has the same issue, no?  Whereever we
>> happen to land (kernel or user) gets the whole tick.
>>
>> So I think it is okay to have the same limitation for guest time.
>>
>>     
>
> So this is how it looks like.
> PATCH 1 and 2 are always a prerequisite.
>
>   

> +	tmp = cputime_to_cputime64(cputime);
> +	if (p->flags & PF_VCPU) {
> +		p->utime = cputime_add(p->utime, cputime);
> +		p->gtime = cputime_add(p->gtime, cputime);
> +
> +		cpustat->guest = cputime64_add(cpustat->guest, tmp);
> +		cpustat->user = cputime64_add(cpustat->user, tmp);
> +
> +		p->flags &= ~PF_VCPU;
> +
> +		return;
> +	}
> +

Where did CONFIG_GUEST_ACCOUNTING go?


-- 
error compiling committee.c: too many arguments to function

