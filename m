Return-Path: <linux-kernel-owner+w=401wt.eu-S965719AbXC1TKD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965719AbXC1TKD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 15:10:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965701AbXC1TJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 15:09:52 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:16615 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965711AbXC1TJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 15:09:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Q+uknIDVlVVr3wid34KTP/WLkcETf9f0OSXnJCdXUgsmy9MX9F1v4aTShOIzmMy6HnwnhHvAQdrYjM5Jf6KKLUN/OquyCBNAhzWWtQ5Cy3Kkhq6BlS6d0nyr8TtIH2bsrjdaW/nWT8TUj9isPbM3qe/K4opn3+9iD/x350lypC0=
Date: Wed, 28 Mar 2007 23:09:25 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Milind Arun Choudhary <milindchoudhary@gmail.com>
Cc: kernel-janitors@lists.osdl.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [KJ][PATCH] BIT macro cleanup
Message-ID: <20070328190925.GC5306@martell.zuzino.mipt.ru>
References: <20070328033309.GA9597@arun.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070328033309.GA9597@arun.site>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2007 at 09:03:09AM +0530, Milind Arun Choudhary wrote:
> --- a/include/linux/bitops.h
> +++ b/include/linux/bitops.h
> @@ -8,6 +8,9 @@
>   */
>  #include <asm/bitops.h>
>
> +#define BIT(nr)	(1UL << ((nr) % BITS_PER_LONG))

I think this would be a disaster because something like

	BIT(123)

would not even generate a warning.

