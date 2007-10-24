Return-Path: <linux-kernel-owner+w=401wt.eu-S1757592AbXJXRPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592AbXJXRPn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 13:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754661AbXJXRPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 13:15:32 -0400
Received: from hu-out-0506.google.com ([72.14.214.239]:8346 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137AbXJXRPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 13:15:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=QWk2CY7XXEH43U4eio7vC8q1clcdOjPfR1ja0HjTOLq0XOKydrDyMIfZHOE1xfHY1ZO3FC6s5MjieJ/E8NYQy0bbSWGh5kXlMY1a0pExO5rhVsYQZ4uMH9fRI6phGl5BKadk9o0l7w3tT+UiIAyhhwFY0iXd2r2uK0e++UB9cHc=
Message-ID: <471F7DA6.2060907@gmail.com>
Date: Wed, 24 Oct 2007 21:15:18 +0400
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] acpi/ec.c: fix use-after-free
References: <20071024162600.GD30533@stusta.de>
In-Reply-To: <20071024162600.GD30533@stusta.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian,

commit 30c08574da0ead1a47797ce028218ce5b2de61c7 can not introduce use-after-free.

Please check...

Regards,
Alex.
Adrian Bunk wrote:
> This patch fixes a use-after-free introduced by
> commit 30c08574da0ead1a47797ce028218ce5b2de61c7.
> 
> Spotted by the Coverity checker.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> --- linux-2.6/drivers/acpi/ec.c.old	2007-10-23 19:39:47.000000000 +0200
> +++ linux-2.6/drivers/acpi/ec.c	2007-10-23 19:34:55.000000000 +0200
> @@ -434,11 +442,11 @@
>  EXPORT_SYMBOL_GPL(acpi_ec_add_query_handler);
>  
>  void acpi_ec_remove_query_handler(struct acpi_ec *ec, u8 query_bit)
>  {
> -	struct acpi_ec_query_handler *handler;
> +	struct acpi_ec_query_handler *handler, *tmp;
>  	mutex_lock(&ec->lock);
> -	list_for_each_entry(handler, &ec->list, node) {
> +	list_for_each_entry_safe(handler, tmp, &ec->list, node) {
>  		if (query_bit == handler->query_bit) {
>  			list_del(&handler->node);
>  			kfree(handler);
>  		}
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

