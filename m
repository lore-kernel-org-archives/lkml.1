Return-Path: <linux-kernel-owner+w=401wt.eu-S1758215AbXK0J2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758215AbXK0J2m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 04:28:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754258AbXK0J2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 04:28:33 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48119 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753834AbXK0J2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 04:28:32 -0500
Date: Tue, 27 Nov 2007 01:26:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "rae l" <crquan@gmail.com>
Cc: "Richard Knutsson" <ricknu-0@student.ltu.se>,
       "Herbert Xu" <herbert@gondor.apana.org.au>,
       linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
       dengxw@163.com, "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Joe Perches" <joe@perches.com>
Subject: Re: [PATCH] [RESEND] crypto test: use print_hex_dump from kernel.h
 instead
Message-Id: <20071127012622.3e3a6bd1.akpm@linux-foundation.org>
In-Reply-To: <91b13c310711262103w781b3047k6338acda56837c0@mail.gmail.com>
References: <20071126143939.GB28022@gondor.apana.org.au>
	<1196098095-8995-1-git-send-email-crquan@gmail.com>
	<1196100104.31590.11.camel@localhost>
	<20071127013540.GA793@gondor.apana.org.au>
	<1196131632-7285-1-git-send-email-crquan@gmail.com>
	<474B87F1.2060109@student.ltu.se>
	<91b13c310711262103w781b3047k6338acda56837c0@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Nov 2007 13:03:29 +0800 "rae l" <crquan@gmail.com> wrote:

> -static void hexdump(unsigned char *buf, unsigned int len)
> +static inline void hexdump(unsigned char *buf, unsigned int len)
>  {
> -	while (len--)
> -		printk("%02x", *buf++);
> -
> -	printk("\n");
> +	print_hex_dump(KERN_CONT, "", DUMP_PREFIX_OFFSET,
> +			16, 1,
> +			buf, len, false);
>  }

uninlining this function shrinks crypto/tcrypt.o's .text from 20,009 bytes
down to 19,701.

inlining is almost always wrong.
