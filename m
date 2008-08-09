Return-Path: <linux-kernel-owner+w=401wt.eu-S1758856AbYHIBKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758856AbYHIBKN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 21:10:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590AbYHIBKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 21:10:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48525 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbYHIBJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 21:09:59 -0400
Date: Fri, 8 Aug 2008 18:07:41 -0700
From: Greg KH <greg@kroah.com>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, joe@perches.com,
       nick@nick-andrew.net, randy.dunlap@oracle.com
Subject: Re: [PATCH 1/7] dynamic debug v2 - infrastructure
Message-ID: <20080809010741.GA26036@kroah.com>
References: <20080715213108.GB23331@redhat.com> <20080717070103.GA21961@kroah.com> <20080717212040.GB13252@redhat.com> <20080717223222.GA28016@kroah.com> <20080808215153.GA16729@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080808215153.GA16729@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2008 at 05:51:53PM -0400, Jason Baron wrote:
> 
> ok, here's a patch that implements just the basic core functionality that ties
> into pr_debug() and dev_dbg(). That is, any users of those two functions can
> be dynamically enabled/disabled at runtime if CONFIG_DYNAMIC_PRINTK_DEBUG is
> set at compile time. We can add the more complex flag/level debugging later as
> you suggest...

Very nice, just as I'm writing patches to dynamically make
CONFIG_USB_DEBUG be selectable on the fly :)

Don't worry, that can easily be moved over to your version once it is
done and in the tree...

> Few notes...there is still one control file: <debugfs>/dynamic_printk/modules
> We can split this up now or later, but I kind of like being able to see all
> the controls in one file. Also, i've used a djb2 hash function in the code,
> which i'm not sure is under the correct license/copyright, so i just wanted
> to point that out as well. see: scripts/basic/hash.c. If its an issue, i can
> find another hash function. 

Why use that hash function?  Actually, it looks like you are using 2
different ones, right?  Why?

> --- /dev/null
> +++ b/include/linux/dynamic_printk.h
> @@ -0,0 +1,94 @@
> +#ifndef _DYNAMIC_PRINTK_H
> +#define _DYNAMIC_PRINTK_H
> +
> +#ifdef __KERNEL__

Shouldn't be needed.

> +#include <linux/string.h>
> +#include <linux/hash.h>
> +
> +#define DYNAMIC_DEBUG_HASH_BITS 6
> +#define DEBUG_HASH_TABLE_SIZE (1 << DYNAMIC_DEBUG_HASH_BITS)
> +
> +#define TYPE_BOOLEAN 1

What's this for?

> +#define DYNAMIC_ENABLED_ALL 0
> +#define DYNAMIC_ENABLED_NONE 1
> +#define DYNAMIC_ENABLED_SOME 2
> +
> +extern int dynamic_enabled;
> +extern long long dynamic_printk_enabled;
> +extern long long dynamic_printk_enabled2;

What's up with the "2" versions?

> +config DYNAMIC_PRINTK_DEBUG
> +	bool "Enable dynamic printk() call support"
> +	default n
> +	depends on PRINTK
> +	select PRINTK_DEBUG
> +	help
> +	 
> +	  Compiles debug level messages into the kernel, which would not
> +	  otherwise be available at runtime. These messages can then be
> +	  enabled/disabled on a per module basis. This mechanism, implicitly 
> +	  enables all pr_debug() and dev_dbg() calls. The impact of this 
> +	  compile option is a larger kernel text size ~2%.

Trailing spaces :(

It's looking very good so far.

thanks,

greg k-h
