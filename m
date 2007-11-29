Return-Path: <linux-kernel-owner+w=401wt.eu-S1760811AbXK2EGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760811AbXK2EGe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 23:06:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756478AbXK2EGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 23:06:25 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:7438 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbXK2EGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 23:06:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=hfF3/Ddjv3vf9TArS7C3eKU0SYYQpVQLFK33sVVCK5TGOSSgRN+S7rMNdQ+jBdM0JA6vo5B8q4xquH3e1nolX6cshnmV7j4n3lrnAfaqtIs17biAIrE2EsFiA+LaerI2wHs1Sn5sk5K8Y54Nkdid+IgRWM2CEDIZcmBtQ4toP/Y=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH -mm] printk trivial optimizations fix
Date: Wed, 28 Nov 2007 20:06:18 -0800
User-Agent: KMail/1.9.1
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0711281900010.25292@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0711281900010.25292@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711282006.18527.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 November 2007 11:02, Hugh Dickins wrote:
> mm's printk has been showing "%p" in abominable upper case recently:
> its trivial optimizations have changed the default from lower to upper,
> so the 'p' case needs to enforce lower explicitly.
>
> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> ---
>
>  lib/vsprintf.c |    1 +
>  1 file changed, 1 insertion(+)
>
> --- 2.6.24-rc3-mm2/lib/vsprintf.c	2007-11-28 12:42:26.000000000 +0000
> +++ linux/lib/vsprintf.c	2007-11-28 17:01:20.000000000 +0000
> @@ -525,6 +525,7 @@ int vsnprintf(char *buf, size_t size, co
>  				continue;
>
>  			case 'p':
> +				flags |= SMALL;
>  				if (field_width == -1) {
>  					field_width = 2*sizeof(void *);
>  					flags |= ZEROPAD;

Thanks Hugh for catching this. My fault :(
--
vda
