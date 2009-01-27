Return-Path: <linux-kernel-owner+w=401wt.eu-S1754166AbZA0X65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166AbZA0X65 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 18:58:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753603AbZA0X60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 18:58:26 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37405 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753562AbZA0X6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 18:58:25 -0500
Date: Tue, 27 Jan 2009 15:57:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dwmw2@infradead.org
Subject: Re: [PATCH] Fix longstanding "error: storage size of
 '__mod_dmi_device_table' isn't known"
Message-Id: <20090127155719.2b88da3f.akpm@linux-foundation.org>
In-Reply-To: <20090121225836.GA14105@x200.localdomain>
References: <20090121225836.GA14105@x200.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2009 01:58:36 +0300
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> gcc 3.4.6 doesn't like MODULE_DEVICE_TABLE(dmi, x) expansion enough to error out.
> Shut it up in a most simple way.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
> 
>  include/linux/mod_devicetable.h |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> --- a/include/linux/mod_devicetable.h
> +++ b/include/linux/mod_devicetable.h
> @@ -443,6 +443,13 @@ struct dmi_system_id {
>  	struct dmi_strmatch matches[4];
>  	void *driver_data;
>  };
> +/*
> + * struct dmi_device_id appears during expansion of
> + * "MODULE_DEVICE_TABLE(dmi, x)". Compiler doesn't look inside it
> + * but this is enough for gcc 3.4.6 to error out:
> + *	error: storage size of '__mod_dmi_device_table' isn't known
> + */
> +#define dmi_device_id dmi_system_id
>  #endif
>  
>  #define DMI_MATCH(a, b)	{ a, b }

I don't get it.

If code has

MODULE_DEVICE_TABLE(dmi, x);

and correctly includes mod_devicetable.h then that code will be
expanded and compiled happily by all compiler versions?  Or not?


Under what circumstances does it fail?  Presumably if some header files
weren't included?  If so, why is that specific to a gcc version?


Or something else.  I have no idea.  Sigh.  New changelog, please.
