Return-Path: <linux-kernel-owner+w=401wt.eu-S1760036AbXETIsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760036AbXETIsh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 04:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754297AbXETIs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 04:48:29 -0400
Received: from smtp-out.google.com ([216.239.45.13]:7842 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191AbXETIs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 04:48:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=Ud33/YcBgfBejj36Il1Y4CDNelZCBQbFHgSPGPj5zh5ApSMYjrYkbymAqaIPk019+
	VvFulmWgAFS5FcIiSYywQ==
Date: Sun, 20 May 2007 01:47:42 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Robert P. J. Day" <rpjday@mindspring.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Extract common MODULE_INFO content into new
 moduleinfo.h.
In-Reply-To: <Pine.LNX.4.64.0705200354380.3319@localhost.localdomain>
Message-ID: <alpine.DEB.0.99.0705200142080.25601@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0705200354380.3319@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 May 2007, Robert P. J. Day wrote:

> diff --git a/include/linux/moduleinfo.h b/include/linux/moduleinfo.h
> new file mode 100644
> index 0000000..cee86a9
> --- /dev/null
> +++ b/include/linux/moduleinfo.h
> @@ -0,0 +1,18 @@
> +#ifndef _LINUX_MODULEINFO_H
> +#define _LINUX_MODULEINFO_H
> +
> +#ifdef MODULE
> +#include <linux/stringify.h>
> +#define ___module_cat(a,b) __mod_ ## a ## b
> +#define __module_cat(a,b) ___module_cat(a,b)
> +#define __MODULE_INFO(tag, name, info)				\
> +static const char __module_cat(name,__LINE__)[]			\
> +  __attribute_used__						\
> +  __attribute__((section(".modinfo"),unused)) = __stringify(tag) "=" info

This isn't a function definition so __attribute_used__ (which is 
deprecated anyway) doesn't mean anything.  Please simply use 
__maybe_unused and remove "unused" from the second attribute.
