Return-Path: <linux-kernel-owner+w=401wt.eu-S1754626AbZKDITw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbZKDITw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 03:19:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbZKDITw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 03:19:52 -0500
Received: from ozlabs.org ([203.10.76.45]:40820 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818AbZKDITv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 03:19:51 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: [PATCH 05/10] kbuild: sort the list of symbols exported by the kernel (__ksymtab)
Date: Wed, 4 Nov 2009 18:49:42 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: greg@kroah.com, linux-kbuild@vger.kernel.org, carmelo73@gmail.com,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
References: <9b2b86520911020852q49c55695rb05d87090fa9ad33@mail.gmail.com> <1257242782-10496-6-git-send-email-alan-jenkins@tuffmail.co.uk>
In-Reply-To: <1257242782-10496-6-git-send-email-alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200911041849.43311.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Nov 2009 08:36:17 pm Alan Jenkins wrote:
> +/*
> + * We use CPP macros since they are more familiar than assembly macros.
> + * Note that CPP macros eat newlines, so each statement must be terminated
> + * by a semicolon.
> + */
> +
> +#ifdef CONFIG_HAVE_SYMBOL_PREFIX
> +#define __SYM(sym) _##sym
> +#else
> +#define __SYM(sym) sym
> +#endif

Ideally, you would used MODULE_SYMBOL_PREFIX here, but of course it's a
string.  I don't think Kconfig can do arbitrary identifiers, so we can't
make CONFIG_SYMBOL_PREFIX empty or _.

Perhaps clarify it to a bool CONFIG_HAVE_MODULE_UNDERSCORE_PREFIX then,
since that's what you're assuming here?

Thanks,
Rusty.
