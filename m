Return-Path: <linux-kernel-owner+w=401wt.eu-S1754610AbZKJIXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbZKJIXo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 03:23:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754342AbZKJIXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 03:23:44 -0500
Received: from outbound-mail-123.bluehost.com ([67.222.38.23]:42208 "HELO
	outbound-mail-123.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754269AbZKJIXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 03:23:43 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=pgHYYZWJ28pOGdb9tDvoyLImdxy1aVkNarlGl09YBlVJMd0n9qj/XEfDYHA5yzFTOrqx4eEMgJ+MQrteEsDLho/oc5ESfr0Pk1vuHGpl+qvkFKElASf9FjVxX4NWlTVU;
Date: Tue, 10 Nov 2009 08:23:40 +0000
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Matthew Wilcox <matthew@wil.cx>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: pci_find_parent_resource patch
Message-ID: <20091110082340.319f1ad3@jbarnes-x200>
In-Reply-To: <4AF875D0.10602@kernel.org>
References: <4AF875D0.10602@kernel.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 158.43.2.102 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't remember seeing it, is it for 2.6.32?

Jesse

On Mon, 09 Nov 2009 12:04:32 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> it seems this patch from Linus get lost ?
> 
> -----------------------------------------------------
> 
> 
> 
> from Linus
> 
> ---
>  drivers/pci/pci.c |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/drivers/pci/pci.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/pci.c
> +++ linux-2.6/drivers/pci/pci.c
> @@ -382,8 +382,12 @@ pci_find_parent_resource(const struct pc
>  			continue;	/* Wrong type */
>  		if (!((res->flags ^ r->flags) & IORESOURCE_PREFETCH))
>  			return r;	/* Exact match */
> -		if ((res->flags & IORESOURCE_PREFETCH) && !(r->flags
> & IORESOURCE_PREFETCH))
> -			best = r;	/* Approximating
> prefetchable by non-prefetchable */
> +		/* We can't insert a non-prefetch resource inside a
> prefetchable parent .. */
> +		if (r->flags & IORESOURCE_PREFETCH)
> +			continue;
> +		/* .. but we can put a prefetchable resource inside
> a non-prefetchable one */
> +		if (!best)
> +			best = r;
>  	}
>  	return best;
>  }
> 

