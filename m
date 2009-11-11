Return-Path: <linux-kernel-owner+w=401wt.eu-S1756020AbZKKOUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbZKKOUX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 09:20:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbZKKOUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 09:20:23 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:53256 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbZKKOUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 09:20:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=K+hpSpuODsL8EReZVWkdOtN7JB/YfSZZaJ+ugvdJ1b6t0ThVOzizs+M6kS+1X4AYAv
         vshbYajy28DR1AMTiM5kp7Cu2iDee7zw6OKPMW/C3mkRxQ8tg3PW9JWXWWoHAl2PGSUw
         KQq3qBBcXilJ4wF01UpHyqXMuy8l6/b7lAr7Q=
Date: Wed, 11 Nov 2009 22:20:54 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: resource_size doesn't change the resource
Message-ID: <20091111142054.GA2448@hack>
References: <20091111150424.37d56849@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091111150424.37d56849@hyperion.delvare>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 11, 2009 at 03:04:24PM +0100, Jean Delvare wrote:
>The resource_size function doesn't change the resource it operates on,
>so the res parameter can be marked const. Same for the resource_type
>function.
>
>Signed-off-by: Jean Delvare <khali@linux-fr.org>

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>


>---
> include/linux/ioport.h |    4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>
>--- linux-2.6.32-rc6.orig/include/linux/ioport.h	2009-09-28 10:29:17.000000000 +0200
>+++ linux-2.6.32-rc6/include/linux/ioport.h	2009-11-11 13:22:27.000000000 +0100
>@@ -126,11 +126,11 @@ extern int allocate_resource(struct reso
> int adjust_resource(struct resource *res, resource_size_t start,
> 		    resource_size_t size);
> resource_size_t resource_alignment(struct resource *res);
>-static inline resource_size_t resource_size(struct resource *res)
>+static inline resource_size_t resource_size(const struct resource *res)
> {
> 	return res->end - res->start + 1;
> }
>-static inline unsigned long resource_type(struct resource *res)
>+static inline unsigned long resource_type(const struct resource *res)
> {
> 	return res->flags & IORESOURCE_TYPE_BITS;
> }
>
>
>-- 
>Jean Delvare
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/

-- 
Live like a child, think like the god.
 
