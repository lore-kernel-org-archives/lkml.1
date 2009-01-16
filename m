Return-Path: <linux-kernel-owner+w=401wt.eu-S1759623AbZAPD2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759623AbZAPD2Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 22:28:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753892AbZAPD2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 22:28:01 -0500
Received: from ti-out-0910.google.com ([209.85.142.191]:25913 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862AbZAPD17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 22:27:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=R4DD4KohIwEBTTO2zsrECPIfxS80Z6SYD7sUy7AAokXW66sEPtaT2EUWlCkB4K2Lgr
         4CZD8MwDzaczFCnwbEdzdhiUPCYNzBmXVIhhAhHPTD0c9DcYnqP8nMU1mXVcy7rJeDVj
         PaYg8+lcGJrDalfMMp6bllTE+pnm4q+a/7aF8=
Message-ID: <df9815e70901151927i29b0da1fh168c80cd80b754ae@mail.gmail.com>
Date: Fri, 16 Jan 2009 11:27:57 +0800
From: "Jike Song" <albcamus@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [patch 81/85] x86: fix RIP printout in early_idt_handler
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       "Justin Forbes" <jmforbes@linuxtx.org>,
       "Zwane Mwaikambo" <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, "Randy Dunlap" <rdunlap@xenotime.net>,
       "Dave Jones" <davej@redhat.com>,
       "Chuck Wolber" <chuckw@quantumlinux.com>,
       "Chris Wedgwood" <reviews@ml.cw.f00f.org>,
       "Michael Krufky" <mkrufky@linuxtv.org>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Domenico Andreoli" <cavokz@gmail.com>, "Willy Tarreau" <w@1wt.eu>,
       "Rodrigo Rubira Branco" <rbranco@la.checkpoint.com>,
       "Jake Edge" <jake@lwn.net>, "Eugene Teo" <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Jiri Slaby" <jirislaby@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <20090115220204.GD17227@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090115215237.906089480@mini.kroah.org>
	 <20090115215812.GA17227@kroah.com> <20090115220204.GD17227@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2009 at 6:02 AM, Greg KH <gregkh@suse.de> wrote:
> 2.6.27-stable review patch.  If anyone has any objections, please let us know.
>
> ------------------
>
> From: Jiri Slaby <jirislaby@gmail.com>
>
> commit 7aed55d1085f71241284a30af0300feea48c36db upstream.
>
> Impact: fix debug/crash printout
>
> Since errorcode is popped out, RIP is on the top of the stack.
> Use real RIP value instead of wrong CS.
>
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>
> ---
>  arch/x86/kernel/head_64.S |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/arch/x86/kernel/head_64.S
> +++ b/arch/x86/kernel/head_64.S
> @@ -305,7 +305,7 @@ ENTRY(early_idt_handler)
>        call dump_stack
>  #ifdef CONFIG_KALLSYMS
>        leaq early_idt_ripmsg(%rip),%rdi
> -       movq 8(%rsp),%rsi       # get rip again
> +       movq 0(%rsp),%rsi       # get rip again
>        call __print_symbol
>  #endif
>  #endif /* EARLY_PRINTK */

why not:

    movq (%rsp), %rsi

instead? Yes, it's all the same but 0 is just unnecessary.

-- 
Thanks,
Jike
