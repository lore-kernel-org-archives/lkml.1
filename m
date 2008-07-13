Return-Path: <linux-kernel-owner+w=401wt.eu-S1753277AbYGMFRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277AbYGMFRp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 01:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751072AbYGMFRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 01:17:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59712 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750975AbYGMFRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 01:17:36 -0400
Date: Sat, 12 Jul 2008 22:16:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: bjorn.helgaas@hp.com, kkeil@suse.de, isdn4linux@listserv.isdn4linux.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix the fcpnp_driver declaration to only exist if
 CONFIG_PNP=y
Message-Id: <20080712221625.4461f2e6.akpm@linux-foundation.org>
In-Reply-To: <20080711143648.19650.93895.stgit@warthog.procyon.org.uk>
References: <20080711143648.19650.93895.stgit@warthog.procyon.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2008 15:36:48 +0100 David Howells <dhowells@redhat.com> wrote:

> Fix the fcpnp_driver declaration to only exist if CONFIG_PNP=y as it's only
> accessed in that case.
> 
> The PNP=n variant was added by patch 30d55e71a81b1f5a8136f191dc9f4c21f18e77e6.
> 

Does this fix a build error or a warning or what?  A warning, I think.

> 
> diff --git a/drivers/isdn/hisax/hisax_fcpcipnp.c b/drivers/isdn/hisax/hisax_fcpcipnp.c
> index c0b4db2..1925118 100644
> --- a/drivers/isdn/hisax/hisax_fcpcipnp.c
> +++ b/drivers/isdn/hisax/hisax_fcpcipnp.c
> @@ -974,8 +974,6 @@ static struct pnp_driver fcpnp_driver = {
>  	.remove		= __devexit_p(fcpnp_remove),
>  	.id_table	= fcpnp_ids,
>  };
> -#else
> -static struct pnp_driver fcpnp_driver;
>  #endif
>  
>  static void __devexit fcpci_remove(struct pci_dev *pdev)

I have to run around and work out of the fix is needed in 2.6.25
or 2.6.26 or linux-next.  Telling me this is always appreciated.
