Return-Path: <linux-kernel-owner+w=401wt.eu-S932590AbZHNPVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932590AbZHNPVc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 11:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932581AbZHNPVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 11:21:32 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1642 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932579AbZHNPVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 11:21:31 -0400
Subject: Re: [PATCH 4/6] new kfifo API v0.3 - add DEFINE_KFIFO and friends,
 add very tiny functions
From: Joe Perches <joe@perches.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>
In-Reply-To: <1250250262.19690.95.camel@wall-e>
References: <1250250262.19690.95.camel@wall-e>
Content-Type: text/plain
Date: Fri, 14 Aug 2009 08:20:54 -0700
Message-Id: <1250263254.15269.456.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-14 at 13:44 +0200, Stefani Seibold wrote:

Couple of trivial comments

> This is patch 4/6 of the new kfifo API:
>  Add KFIFO_INIT - macro to generate a kfifo initializer

Is it really necessary to use KFIFO_INIT and INIT_KFIFO?
I think it'll cause confusion and misuse.

> Add INIT_KFIFO - macro to initialize a with DECLARE_KFIFO declared kfifo 

What does the description mean?

> Add DEFINE_KFIFO - macro to define and initialize a kfifo as a global or local object

What does this mean?  Is scope relevant to the macro?

I think you should mention somewhere that these macros
actually define 2 objects.  "name##_buffer" might have
unexpected clashes and be prefixed with kfifo.
maybe something like "kfifo_##name##_buffer"?

> + * KFIFO_INIT - macro to generate a kfifo initializer
> + * @s: size of the fifo buffer
> + * @b: address of the fifo buffer
> + */
> +#define KFIFO_INIT(s, b) \
> +	(struct kfifo) { \
> +		.size	= s, \
> +		.in	= 0, \
> +		.out	= 0, \
> +		.buffer = b \
> +	}

> +/**
> + * INIT_KFIFO - macro to initialize a with DECLARE_KFIFO declared kfifo
> + * @name: name of the declared kfifo datatype
> + * @size: size of the fifo buffer
> + */
> +#define INIT_KFIFO(name) \
> +	name = KFIFO_INIT(sizeof(name##_buffer) - sizeof(struct kfifo), \
> +				name##_buffer)

Perhaps

#define __kfifo_initializer ?


