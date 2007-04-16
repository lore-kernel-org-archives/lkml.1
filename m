Return-Path: <linux-kernel-owner+w=401wt.eu-S1754102AbXDPQkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbXDPQkP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 12:40:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753007AbXDPQkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 12:40:15 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:59606 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbXDPQkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 12:40:12 -0400
Date: Mon, 16 Apr 2007 09:42:25 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       Tony Jones <tonyj@suse.de>
Subject: Re: [nameidata 2/2] Pass no useless nameidata to the create,
 lookup, and permission IOPs
Message-Id: <20070416094225.2616c4b6.randy.dunlap@oracle.com>
In-Reply-To: <200704161829.20669.agruen@suse.de>
References: <20070412090809.917795000@suse.de>
	<20070412090836.207973000@suse.de>
	<20070412100628.GA25078@infradead.org>
	<200704161829.20669.agruen@suse.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Apr 2007 18:29:20 +0200 Andreas Gruenbacher wrote:

> Here is a patch with request for comment.
> 
> --- a/include/linux/namei.h
> +++ b/include/linux/namei.h
> @@ -14,21 +14,39 @@ struct open_intent {
>  
>  enum { MAX_NESTED_LINKS = 8 };
>  
> +/**

Please don't use the kernel-doc begin-marker "/**" when the comment block
isn't in kernel-doc format.

> + * Fields shared between nameidata and nameidata2 -- nameidata2 could
> + * be embedded in nameidata, but then the vfs code would become
> + * cluttered with dereferences.
> + */
> +#define __NAMEIDATA2				\
> +	struct dentry	*dentry;		\
> +	struct vfsmount *mnt;			\
> +	unsigned int	flags;			\
> +						\
> +	union {					\
> +		struct open_intent open;	\
> +	} intent;
> +

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
