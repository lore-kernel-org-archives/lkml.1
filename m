Return-Path: <linux-kernel-owner+w=401wt.eu-S1761442AbXEUL0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761442AbXEUL0R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 07:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755065AbXEUL0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 07:26:05 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:51875 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012AbXEUL0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 07:26:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=s5BYCMCSc7lHXMf/cZTHgm1JpU3VECnmrsXAvh48F6u3/afHwBezhfw2HToniew2sIzpdYVrw6+0WO03nWZjFAKzeFKLDEbUJDyIN0hwTNb8jZxD3AG02uqjaddSihGTEUKtcCIzHPRQpQ9FF1h7YSoVz7nz/EJAAH+s7wS6pms=
Message-ID: <84144f020705210426w1704e133k2559f8ceffe9268c@mail.gmail.com>
Date: Mon, 21 May 2007 14:26:01 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Bryan Wu" <bryan.wu@analog.com>
Subject: Re: [PATCH 20/32] Blackfin arch: dma_memcpy borken for > 64K
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Aubrey Li" <aubrey.li@analog.com>
In-Reply-To: <11797421863363-git-send-email-bryan.wu@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1179742180228-git-send-email-bryan.wu@analog.com>
	 <11797421863363-git-send-email-bryan.wu@analog.com>
X-Google-Sender-Auth: ba4a97ee15c14a75
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan,

On 5/21/07, Bryan Wu <bryan.wu@analog.com> wrote:
> -void *dma_memcpy(void *dest, const void *src, size_t size)
> +void *_dma_memcpy(void *dest, const void *src, size_t size)

Minor nitpick: the established naming convention is two underscores, not one.

> +void *dma_memcpy(void *dest, const void *src, size_t size)
> +{
> +       size_t bulk;
> +       size_t rest;
> +       void * addr;
> +
> +       bulk = (size >> 16) << 16;

I assume this is significantly faster on your architecture than:

   bulk = size & ~0xFFFFUL;

which is more readable?

> +       rest = size - bulk;
> +       if (bulk)
> +               _dma_memcpy(dest, src, bulk);
> +       addr = _dma_memcpy(dest+bulk, src+bulk, rest);
> +       return addr;

Does this work for 128K and up? Why?
