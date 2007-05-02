Return-Path: <linux-kernel-owner+w=401wt.eu-S1754883AbXEBGww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbXEBGww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 02:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754886AbXEBGwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 02:52:51 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36219 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754883AbXEBGwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 02:52:50 -0400
Date: Tue, 1 May 2007 23:52:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [patch 01/10] compiler: define __attribute_unused__
Message-Id: <20070501235237.ba43586a.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0705012336430.22339@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0705012118130.19277@chino.kir.corp.google.com>
	<1178084403.28659.222.camel@localhost.localdomain>
	<Pine.LNX.4.64.0705012254160.21685@chino.kir.corp.google.com>
	<1178087393.28659.238.camel@localhost.localdomain>
	<Pine.LNX.4.64.0705012336430.22339@chino.kir.corp.google.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2007 23:41:34 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:

> compiler: define __maybe_unused
> 
> Define __maybe_unused to apply to both functions or variables as
> __attribute__((unused)).  This will not emit a compile-time warning when
> a function or variable is declared but unreferenced.
> 
> We eventually want to change the name of __attribute_used__ to __used.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  include/linux/compiler-gcc.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
> --- a/include/linux/compiler-gcc.h
> +++ b/include/linux/compiler-gcc.h
> @@ -37,3 +37,4 @@
>  #define  noinline			__attribute__((noinline))
>  #define __attribute_pure__		__attribute__((pure))
>  #define __attribute_const__		__attribute__((__const__))
> +#define __maybe_unused			__attribute__((unused))

Seems sane to me.  We'd need a definition in compiler-intel.h too.  I don't
know if ICC implements __attribute__((unused)) - probably it does.

I guess we can get by without any commentary describing __maybe_unused, but
I think __used would need one - it's pretty obscure.


+@cindex @code{used} attribute.
+@item used
+This attribute, attached to a function, means that code must be emitted
+for the function even if it appears that the function is not referenced.
+This is useful, for example, when the function is referenced only in
+inline assembly.

