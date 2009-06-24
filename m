Return-Path: <linux-kernel-owner+w=401wt.eu-S1758252AbZFXJgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758252AbZFXJgQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 05:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758185AbZFXJf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 05:35:59 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:50359 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758161AbZFXJf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 05:35:57 -0400
Subject: Re: kmemleak: Early log buffer exceeded
From: Catalin Marinas <catalin.marinas@arm.com>
To: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <20090623212648.GA9502@localdomain.by>
References: <20090623212648.GA9502@localdomain.by>
Content-Type: text/plain
Organization: ARM Ltd
Date: Wed, 24 Jun 2009 10:35:05 +0100
Message-Id: <1245836105.16283.13.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jun 2009 09:35:06.0835 (UTC) FILETIME=[0F34EA30:01C9F4AF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-23 at 22:26 +0100, Sergey Senozhatsky wrote:
> I can see on my both machines
> 
> [    0.000135] kmemleak: Early log buffer exceeded
[...]
> mm/kmemleak.c
> static struct early_log early_log[200];
> 
> static void log_early(int op_type, const void *ptr, size_t size,
>                       int min_count, unsigned long offset, size_t length)
> {
> ...
>         if (crt_early_log >= ARRAY_SIZE(early_log)) {
>                 print  Early log buffer exceeded;
>                 call dump_stack, etc.
> 
> So, my questions are:
> 1. Is 200 really enough? Why 200 not 512, 1024 (for example)?

It seems that in your case it isn't. It is fine on the machines I tested
it on but choosing this figure wasn't too scientific.

I initially had it bigger and marked with the __init attribute to free
it after initialisation but this was causing (harmless) section mismatch
warnings.

What kind of hardware do you have?

> 2. When (crt_early_log >= ARRAY_SIZE(early_log)) == 1 we just can see stack.
> Since we have "full" early_log maybe it'll be helpfull to see it?

I recall allocating this dynamically didn't work properly but I'll give
it another try. Otherwise, I can make it configurable and print a better
message (probably without the stack dump).

-- 
Catalin

