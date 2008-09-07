Return-Path: <linux-kernel-owner+w=401wt.eu-S1755049AbYIGHza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049AbYIGHza (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 03:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752197AbYIGHzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 03:55:20 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:25542 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbYIGHzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 03:55:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=nIIADRx5NUu4wPKCeDvysS1rFIpUMXSnrKgD+DJdqS03NwjaFM+Y+Xu/41Uhz0QSvv
         ifo0WbiGckMlOo0iLdC1EkkBjvxs40XF8XiDIDPtTxpIfFRN+VS7v8ZuthFGPeQ/gS8Z
         8A80YBir9G5s+b7UAiRAkZ6SzfRklj5NPZcZA=
Message-ID: <36ca99e90809070055u3b3b8415i2a5dbfb6bf617d35@mail.gmail.com>
Date: Sun, 7 Sep 2008 09:55:17 +0200
From: "Bert Wesarg" <bert.wesarg@googlemail.com>
To: "Mike Travis" <travis@sgi.com>
Subject: Re: [RFC 11/13] genapic: reduce stack pressuge in io_apic.c step 3 target_cpus
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       davej@codemonkey.org.uk, "David Miller" <davem@davemloft.net>,
       "Eric Dumazet" <dada1@cosmosbay.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Jack Steiner" <steiner@sgi.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>, "Jes Sorensen" <jes@sgi.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20080906235038.421559000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080906235036.891970000@polaris-admin.engr.sgi.com>
	 <20080906235038.421559000@polaris-admin.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 7, 2008 at 01:50, Mike Travis <travis@sgi.com> wrote:
>  * Step 3 "target_cpus" of cleaning up io_apic.c modifies the TARGET_CPUS
>    interface to pass a pointer to the returned mask for arch X86_64,
>    removing yet another "cpumask_t variable on the stack".
>
>        target_cpus = TARGET_CPUS;
>
>    becomes:
>
>        TARGET_CPUS(target_cpus);
>
>    For x86_32 this is expanded to:
>
>        target_cpus = (genapic->target_cpus());
>
>    For x86_64 this is expanded to:
>
>        target_cpus = (genapic->target_cpus)(&(target_cpus));
But its expended to:
         (genapic->target_cpus)(&(target_cpus));

> -#define TARGET_CPUS      (genapic->target_cpus())
> +#define TARGET_CPUS(retval) (genapic->target_cpus)(&(retval))


> +#ifdef CONFIG_X86_64
> +#define TARGET_CPUS(retval)      (genapic->target_cpus)(&(retval))
> +#else
> +#define TARGET_CPUS(retval)      retval = (genapic->target_cpus())
> +#endif

Bert
