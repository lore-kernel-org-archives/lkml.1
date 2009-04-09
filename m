Return-Path: <linux-kernel-owner+w=401wt.eu-S936989AbZDIWjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936989AbZDIWjw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 18:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936824AbZDIWim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 18:38:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60357 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936887AbZDIWil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 18:38:41 -0400
Date: Thu, 9 Apr 2009 15:37:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: steiner@sgi.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 02/13] GRU - dump chiplet state
Message-Id: <20090409153706.e1c1d3a3.akpm@linux-foundation.org>
In-Reply-To: <20090406161011.421626000@sgi.com>
References: <20090406160809.278924000@sgi.com>
	<20090406161011.421626000@sgi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 Apr 2009 11:08:11 -0500
steiner@sgi.com wrote:

> From: Jack Steiner <steiner@sgi.com>
> 
> Add support for dumpping the state of an entire GRU chiplet.
> 
> ...
>
> +static int gru_user_copy_handle(void __user **dp, void *s)
> +{
> +	if (copy_to_user(*(void __user **)dp, s, GRU_HANDLE_BYTES))

the typecast appears to be unneeded?

> +		return -1;
> +	*dp += GRU_HANDLE_BYTES;
> +	return 0;
> +}
> +
>
> ...
>
> --- linux.orig/drivers/misc/sgi-gru/grutables.h	2009-03-04 10:49:00.000000000 -0600
> +++ linux/drivers/misc/sgi-gru/grutables.h	2009-03-04 10:50:44.000000000 -0600
> @@ -554,6 +554,12 @@ struct gru_blade_state {
>  
>  /* Lock hierarchy checking enabled only in emulator */
>  
> +/* 0 = lock failed, 1 = locked */
> +static inline int __trylock_handle(void *h)
> +{
> +	return !test_and_set_bit(1, h);
> +}

It would be safer were this header to include bitops.h.
