Return-Path: <linux-kernel-owner+w=401wt.eu-S1754630AbXDZBTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbXDZBTX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 21:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754632AbXDZBTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 21:19:23 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55737 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754630AbXDZBTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 21:19:22 -0400
Date: Wed, 25 Apr 2007 18:18:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rene Herman <rene.herman@gmail.com>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Adrian Bunk <bunk@stusta.de>,
       Marcel Holtmann <marcel@holtmann.org>,
       Christoph Hellwig <hch@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: MODULE_MAINTAINER
Message-Id: <20070425181856.42fcfeb4.akpm@linux-foundation.org>
In-Reply-To: <462CA764.5080401@gmail.com>
References: <46138B4C.2050409@gmail.com>
	<20070404123311.GA18552@infradead.org>
	<1175698135.5815.447.camel@violet>
	<20070404150231.GE27660@stusta.de>
	<4613C963.6070409@gmail.com>
	<20070404170016.453d26f1@the-village.bc.nu>
	<4613D492.2070404@gmail.com>
	<462C7D74.60003@gmail.com>
	<1177327476.17026.75.camel@localhost.localdomain>
	<Pine.LNX.4.64.0704230748270.25463@localhost.localdomain>
	<462CA764.5080401@gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2007 14:32:36 +0200 Rene Herman <rene.herman@gmail.com> wrote:

> Provide MODULE_MAINTAINER() as a convenient place to stick a name and email 
> address both for drivers having multiple (current and non-current) authors 
> and for when someone who wants to maintain a driver isn't so much an author.
> 
> Signed-off-by: Rene Herman <rene.herman@gmail.com>
> ===
> 
> Rene.
> 
> 
> 
> [module_maintainer2.diff  text/plain (604B)]
> diff --git a/include/linux/module.h b/include/linux/module.h
> index 10f771a..3c54774 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -128,6 +128,10 @@ extern struct module __this_module;
>  /* Author, ideally of form NAME <EMAIL>[, NAME <EMAIL>]*[ and NAME <EMAIL>] */
>  #define MODULE_AUTHOR(_author) MODULE_INFO(author, _author)
>    
> +/* Maintainer, ideally of form NAME <EMAIL> */
> +#define MODULE_MAINTAINER(_maintainer) \
> +	MODULE_AUTHOR("(Maintained by) "_maintainer)
> +

I'm not sure we want to do this - that's what ./MAINTAINERS is for and we
end up having to maintain the same info in two places.

I actually use git-whatchanged if I'm unsure who to blame^Wask for help on
a particular piece of code.

An easy way of doing this is to go to
http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/torvalds/linux-2.6.git;a=tree
then drill down to the file and hit the "history" link.  That will tell you who
is *really* doing work on the particular code.
