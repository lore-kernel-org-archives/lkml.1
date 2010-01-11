Return-Path: <linux-kernel-owner+w=401wt.eu-S1753345Ab0AKMMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab0AKMMp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 07:12:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753304Ab0AKMMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 07:12:44 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:52839 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189Ab0AKMMn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 07:12:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Gk80Rxb/YphKJiztyV90pKVYlWIe/p7x9m97eoftan7ZszT6yt70SEfSU2lh6NbTjX
         b5Zw4cHhnTnrEHvy4D9dolXIO0qMkRZAz1qFGCaVbhjcuEGH7ez00+kBNuHcdfsvHwQ5
         36QqwXZOLcli2Qv/sJ13LZeWdGpMCRY1LC2/c=
MIME-Version: 1.0
In-Reply-To: <20100105021526.17EF2B17C2@basil.firstfloor.org>
References: <20100105315.789846878@firstfloor.org>
	 <20100105021526.17EF2B17C2@basil.firstfloor.org>
Date: Mon, 11 Jan 2010 13:12:41 +0100
Message-ID: <36ca99e91001110412k17326723q5e52f6d3cc3f5e6c@mail.gmail.com>
Subject: Re: [PATCH] [1/9] Add rcustring ADT for RCU protected strings v2
From: Bert Wesarg <bert.wesarg@googlemail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: paulmck@linux.vnet.ibm.com, ebiederm@xmission.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 5, 2010 at 03:15, Andi Kleen <andi@firstfloor.org> wrote:
> Index: linux-2.6.33-rc2-ak/lib/rcustring.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6.33-rc2-ak/lib/rcustring.c

[ . . . ]

> +/*
> + * Get a local private copy of a RCU protected string.
> + * Mostly useful to get a string that is stable while sleeping.
> + * Caller must free returned string.
> + */
> +char *access_rcu_string(char **str, int size, gfp_t gfp)
> +{
> +       char *copy = kmalloc(size, gfp);
No check of return value from kmalloc()?

> +       if (!str)
> +               return NULL;
> +       rcu_read_lock();
> +       strlcpy(copy, rcu_dereference(*str), size);
> +       rcu_read_unlock();
> +       return copy;
> +}
> +EXPORT_SYMBOL(access_rcu_string);
