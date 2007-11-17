Return-Path: <linux-kernel-owner+w=401wt.eu-S1755642AbXKQXDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642AbXKQXDP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 18:03:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752442AbXKQXDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 18:03:01 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:38331 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbXKQXDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 18:03:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=nCE22Ch0x6tRV0HTzTJvuY5e45lgGrUXaainqk7UX5OQ9SWWmG8I7U6Juy3vmlwqwukptEsBjtt5KvYkJP7r3jjEIAc4jiUG3ERTpp6HvTCqcPjd3i+SIjiGYoD4mDuKLndb8pxhaeEjxgw8D04v2eQV9oeb27LLweK5NunPUUE=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch] Printk kernel version in WARN_ON
Date: Sat, 17 Nov 2007 15:02:36 -0800
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@tglx.de,
       akpm@linux-foundation.org
References: <20071117101552.2a7f34cb@laptopd505.fenrus.org>
In-Reply-To: <20071117101552.2a7f34cb@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711171502.36478.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 November 2007 10:15, Arjan van de Ven wrote:
> Hi,
>
>  #define WARN_ON(condition) ({						\
>  	int __ret_warn_on = !!(condition);				\
>  	if (unlikely(__ret_warn_on)) {					\
> -		printk("WARNING: at %s:%d %s()\n", __FILE__,		\
> -			__LINE__, __FUNCTION__);			\
> +		printk("WARNING: at %s:%d %s()  (%s)\n", __FILE__,	\
> +			__LINE__, __FUNCTION__, UTS_RELEASE);		\
>  		dump_stack();						\
>  	}								\
>  	unlikely(__ret_warn_on);					\

We have ~700 WARN_ONs in the tree. Adding UTS_RELEASE to printk
grows every one of them by at least 5 bytes.

I think it makes sense to move printk out-of-line, to

void print_WARN_ON_warning(const char *file, int line, const char *func);

This will save at least 10 bytes per WARN_ON.
--
vda
