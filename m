Return-Path: <linux-kernel-owner+w=401wt.eu-S1757266AbZGPDRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266AbZGPDRM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 23:17:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757221AbZGPDRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 23:17:11 -0400
Received: from mail-px0-f185.google.com ([209.85.216.185]:51908 "EHLO
	mail-px0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757117AbZGPDRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 23:17:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sXeBCXv22epPiybs8IUNTJdRZoqdmL59Zdxj8du8uhtL1JMZFD5c6eW5xIrpVJxvfH
         RbmFK54aEHZWga9xNVHzPCNdOi9TbZ4+IH68IUPEZZEZNTm0FWbH+4UlPeIrpN9WMEKR
         ss2jqcHID0UwwCnJpaNVdspa1IhmH8F0dMpAg=
Date: Thu, 16 Jul 2009 11:19:20 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel.h: Verify that arguments to swap() are the same
	type
Message-ID: <20090716031920.GB5713@cr0.nay.redhat.com>
References: <1247708061.15087.13.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247708061.15087.13.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 06:34:21PM -0700, Joe Perches wrote:
>Signed-off-by: Joe Perches <joe@perches.com>
>

Hmm, sounds reasonable.

Does this catch any actual wrong usages of swap()?

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>


>diff --git a/include/linux/kernel.h b/include/linux/kernel.h
>index d6320a3..72878a5 100644
>--- a/include/linux/kernel.h
>+++ b/include/linux/kernel.h
>@@ -637,8 +637,13 @@ static inline void ftrace_dump(void) { }
> /*
>  * swap - swap value of @a and @b
>  */
>-#define swap(a, b) \
>-	do { typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; } while (0)
>+#define swap(a, b)				\
>+do {						\
>+	typeof(a) __tmp = (a);			\
>+	BUILD_BUG_ON(!__same_type(__tmp, (b)));	\
>+	(a) = (b);				\
>+	(b) = __tmp;				\
>+} while (0)
> 
> /**
>  * container_of - cast a member of a structure out to the containing structure
>
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
