Return-Path: <linux-kernel-owner+w=401wt.eu-S1752949AbYLWRaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949AbYLWRaV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 12:30:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752147AbYLWRaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 12:30:01 -0500
Received: from smtp-out.google.com ([216.239.45.13]:18059 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbYLWR37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 12:29:59 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=dNyR3gSLCFyn+ICX1Nhd+8Ap6r0g9pOYLIVI8aDR+fu/cknoTUHIptpQwjATLPtfP
	U7KvZDEvLoLK8J3klp+iw==
MIME-Version: 1.0
In-Reply-To: <20081223172610.GA5957@uranus.ravnborg.org>
References: <20081222152247.b934ed5b.sfr@canb.auug.org.au>
	 <20081222070426.GD29160@elte.hu>
	 <20081222181932.5dd9514e.sfr@canb.auug.org.au>
	 <20081222080341.GA18897@elte.hu>
	 <20081222144319.1bfc0061.akpm@linux-foundation.org>
	 <20081222230035.GB4074@uranus.ravnborg.org>
	 <20081222151338.3b6ef997.akpm@linux-foundation.org>
	 <20081223131746.GA7456@uranus.ravnborg.org>
	 <b040c32a0812230905q3a257163r35373b0cb50df35c@mail.gmail.com>
	 <20081223172610.GA5957@uranus.ravnborg.org>
Date: Tue, 23 Dec 2008 09:29:52 -0800
Message-ID: <b040c32a0812230929u282f0f2bn9221bf2e176d82eb@mail.gmail.com>
Subject: Re: [PATCH] sparc64: use unsigned long long for u64
From: Ken Chen <kenchen@google.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       sparclinux <sparclinux@vger.kernel.org>, mingo@elte.hu,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org, paulus@samba.org,
       tglx@linutronix.de, hpa@zytor.com, linux-next@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.24.198.81
X-GMailtapped: kenchen
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2008 at 9:26 AM, Sam Ravnborg <sam@ravnborg.org> wrote:
>> wait, why does this need to be changed?
>
> We have:
>        clocksource_tick.read = tick_ops->get_tick;
>
> And clocksource_tick is of type clocksource:
>
> struct clocksource {
>        ...
>        cycle_t (*read)(void);
>
> And cycle_t is:
> /* clocksource cycle base type */
> typedef u64 cycle_t;
>
> And u64 is now:
> unsigned long long - thus we need to fix prototype
> of get_tick to fix the warnings.
>
> A cast could do it - but fixing the real problem
> is better here.

Sounds good to me.  It was just a question.  Thank you for the explanation.

- Ken
