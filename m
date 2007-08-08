Return-Path: <linux-kernel-owner+w=401wt.eu-S935765AbXHHDAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935765AbXHHDAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 23:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760761AbXHHDAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 23:00:32 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:21615 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759134AbXHHDAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 23:00:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GB+v53eBDsbVGLenUX/DnlMCk1ZfYhDxARvApJmlbdw0mnSaCPyBxu8KDmYayIpDK7egh5RfiDBAgKDS8SwkCReb0ToHAqgJ+QyKXFGkpmB773So4EMBwLwE5dDoXT1xudymXFW+wtTYHf11QiKJNGnObyxteLODqXCSLtEJurg=
Message-ID: <29495f1d0708072000m3d6d6febpad0db101ed48aa24@mail.gmail.com>
Date: Tue, 7 Aug 2007 20:00:24 -0700
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Joe Perches" <joe@perches.com>
Subject: Re: [PATCH] Add missing newlines to some uses of dev_<level> messages
Cc: linux-kernel@vger.kernel.org, "Greg KH" <gregkh@suse.de>,
       "Jeff Garzik" <jeff@garzik.org>, "Tony Luck" <tony.luck@intel.com>,
       "Jiri Slaby" <jirislaby@gmail.com>, "Roland Dreier" <rolandd@cisco.com>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "James Smart" <james.smart@emulex.com>,
       "Hansjoerg Lipp" <hjlipp@web.de>, "Jean Delvare" <khali@linux-fr.org>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       "Jeremy Fitzhardinge" <jeremy@xensource.com>
In-Reply-To: <1186535381.11897.29.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1186535381.11897.29.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/7/07, Joe Perches <joe@perches.com> wrote:
> Found these while looking at printk uses.
>
> Add missing newlines to dev_<level> uses
> Add missing KERN_<level> prefixes to multiline dev_<level>s
> Fixed a wierd->weird spelling typo
> Added a newline to a printk

I think these should have been split logically into 4 groups of
patches (except perhaps where they touched the same file for the first
two and the last).

The third type should go through trivial.

And they should have been split logically by subsystem, most likely?

<snip diffstat>

> diff --git a/arch/ia64/sn/kernel/xpnet.c b/arch/ia64/sn/kernel/xpnet.c
> index e58fcad..a5df672 100644
> --- a/arch/ia64/sn/kernel/xpnet.c
> +++ b/arch/ia64/sn/kernel/xpnet.c
> @@ -269,8 +269,9 @@ xpnet_receive(partid_t partid, int channel, struct xpnet_message *msg)
>         skb->protocol = eth_type_trans(skb, xpnet_device);
>         skb->ip_summed = CHECKSUM_UNNECESSARY;
>
> -       dev_dbg(xpnet, "passing skb to network layer; \n\tskb->head=0x%p "
> -               "skb->data=0x%p skb->tail=0x%p skb->end=0x%p skb->len=%d\n",
> +       dev_dbg(xpnet, "passing skb to network layer\n"
> +               KERN_DEBUG "\tskb->head=0x%p skb->data=0x%p skb->tail=0x%p "
> +               "skb->end=0x%p skb->len=%d\n",
>                 (void *)skb->head, (void *)skb->data, skb_tail_pointer(skb),
>                 skb_end_pointer(skb), skb->len);

<snip>

I'm not a maintainer of any code by any means, but it seems odd,
redundant and visually confusing to me to use the dev_dbg() function
and have KERN_DEBUG's inside the string -- makes me question every
time why there isn't one for the first line too.

Perhaps these multi-line debug statements should simply be split into
multiple dev_dbg() calls? Similar for the other dev_ functions. I
think it might look cleaner, at least. Just my two cents, not a NAK or
anything.

Thanks,
Nish
