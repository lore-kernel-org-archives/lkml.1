Return-Path: <linux-kernel-owner+w=401wt.eu-S1763568AbXKQS1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763568AbXKQS1v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 13:27:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757606AbXKQS1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 13:27:44 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39337 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755727AbXKQS1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 13:27:43 -0500
Date: Sat, 17 Nov 2007 10:27:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@tglx.de
Subject: Re: [patch] Printk kernel version in WARN_ON
Message-Id: <20071117102720.251107d7.akpm@linux-foundation.org>
In-Reply-To: <20071117101552.2a7f34cb@laptopd505.fenrus.org>
References: <20071117101552.2a7f34cb@laptopd505.fenrus.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Nov 2007 10:15:52 -0800 Arjan van de Ven <arjan@infradead.org> wrote:

> @@ -35,8 +36,8 @@ struct bug_entry {
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

that made our 1100-odd WARN_ON sites fatter.

I suppose sometime we should optimise WARN_ON like we did BUG_ON.
