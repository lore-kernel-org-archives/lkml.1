Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958Ab0BWN6G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 08:58:06 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:7980 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873Ab0BWN6D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 08:58:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ozSFo8uO8pFbojIEh/A65++wa4QOxb1CqLrCAE35gIbOVqW6FVXIigGphBq6drkvZj
         AqpDiVqbH0ssKQdUyF5pGOpCSS1+u4kAO8LK7WOwNKkWT5PnXnWR3i6V4efNKCNU+Idz
         BZxxVBVUWXW7KtLKsbgNKku8Qog50CEkebbOc=
MIME-Version: 1.0
In-Reply-To: <1266931960-9779-1-git-send-email-dmonakhov@openvz.org>
References: <1266931960-9779-1-git-send-email-dmonakhov@openvz.org>
Date: Tue, 23 Feb 2010 22:58:02 +0900
Message-ID: <961aa3351002230558r6cc5846aq40d6ed21b7686ae7@mail.gmail.com>
Subject: Re: [PATCH] failslab: add abitily to filter slab caches
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/2/23 Dmitry Monakhov <dmonakhov@openvz.org>:
> Example:
> echo 1 > /sys/kernel/slab/skbuff_head_cache/failslab
> echo 1 > /sys/kernel/debug/failslab/cache-filter

Looks good.

.Should we also support clearing the flag by
"echo 0 > /sys/kernel/slab/skbuff_head_cache/failslab" ?

> +static ssize_t failslab_store(struct kmem_cache *s, const char *buf,
> +                                                       size_t length)
> +{
> +       s->flags &= ~SLAB_FAILSLAB;
> +       if (buf[0] == '1')
> +               s->flags |= SLAB_FAILSLAB;
> +       return length;
> +}
> +SLAB_ATTR(failslab);
