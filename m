Return-Path: <linux-kernel-owner+w=401wt.eu-S965598AbXHJUeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965598AbXHJUeW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 16:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765166AbXHJUeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 16:34:13 -0400
Received: from smtp-105-friday.nerim.net ([62.4.16.105]:59368 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760305AbXHJUeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 16:34:12 -0400
Date: Fri, 10 Aug 2007 22:34:20 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Nish Aravamudan" <nish.aravamudan@gmail.com>
Cc: "Joe Perches" <joe@perches.com>, linux-kernel@vger.kernel.org,
       "Greg KH" <gregkh@suse.de>, "Jeff Garzik" <jeff@garzik.org>,
       "Tony Luck" <tony.luck@intel.com>, "Jiri Slaby" <jirislaby@gmail.com>,
       "Roland Dreier" <rolandd@cisco.com>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "James Smart" <james.smart@emulex.com>,
       "Hansjoerg Lipp" <hjlipp@web.de>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       "Jeremy Fitzhardinge" <jeremy@xensource.com>
Subject: Re: [PATCH] Add missing newlines to some uses of dev_<level>
 messages
Message-ID: <20070810223420.3d20f771@hyperion.delvare>
In-Reply-To: <29495f1d0708072000m3d6d6febpad0db101ed48aa24@mail.gmail.com>
References: <1186535381.11897.29.camel@localhost>
	<29495f1d0708072000m3d6d6febpad0db101ed48aa24@mail.gmail.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nish,

On Tue, 7 Aug 2007 20:00:24 -0700, Nish Aravamudan wrote:
> On 8/7/07, Joe Perches <joe@perches.com> wrote:
> > Found these while looking at printk uses.
> >
> > Add missing newlines to dev_<level> uses
> > Add missing KERN_<level> prefixes to multiline dev_<level>s
> > Fixed a wierd->weird spelling typo
> > Added a newline to a printk
> 
> I think these should have been split logically into 4 groups of
> patches (except perhaps where they touched the same file for the first
> two and the last).

Not worth splitting IMHO, these are all misuses of printk.

> The third type should go through trivial.

Except for this one, which really doesn't belong to this patch, granted.

> And they should have been split logically by subsystem, most likely?

Depends. If Andrew is going to pick the patch quickly and apply it,
then it's fine (except that I see that Andrew wasn't Cc'd, so it's
unlikely to happen.) But if Andrew doesn't want to take this patch,
then indeed, the only way to get it applied is to split it by
subsystem.

> 
> <snip diffstat>
> 
> > diff --git a/arch/ia64/sn/kernel/xpnet.c b/arch/ia64/sn/kernel/xpnet.c
> > index e58fcad..a5df672 100644
> > --- a/arch/ia64/sn/kernel/xpnet.c
> > +++ b/arch/ia64/sn/kernel/xpnet.c
> > @@ -269,8 +269,9 @@ xpnet_receive(partid_t partid, int channel, struct xpnet_message *msg)
> >         skb->protocol = eth_type_trans(skb, xpnet_device);
> >         skb->ip_summed = CHECKSUM_UNNECESSARY;
> >
> > -       dev_dbg(xpnet, "passing skb to network layer; \n\tskb->head=0x%p "
> > -               "skb->data=0x%p skb->tail=0x%p skb->end=0x%p skb->len=%d\n",
> > +       dev_dbg(xpnet, "passing skb to network layer\n"
> > +               KERN_DEBUG "\tskb->head=0x%p skb->data=0x%p skb->tail=0x%p "
> > +               "skb->end=0x%p skb->len=%d\n",
> >                 (void *)skb->head, (void *)skb->data, skb_tail_pointer(skb),
> >                 skb_end_pointer(skb), skb->len);
> 
> <snip>
> 
> I'm not a maintainer of any code by any means, but it seems odd,
> redundant and visually confusing to me to use the dev_dbg() function
> and have KERN_DEBUG's inside the string -- makes me question every
> time why there isn't one for the first line too.

The code above looks correct to me.

> Perhaps these multi-line debug statements should simply be split into
> multiple dev_dbg() calls? Similar for the other dev_ functions. I
> think it might look cleaner, at least. Just my two cents, not a NAK or
> anything.

The benefit of having a single call is that other calls to printk()
won't be interlaced with our message. This has been discussed lately in
a different thread. So you may think that the code above is confusing,
but it is currently the best way to ensure that related lines stay
grouped in the kernel log.

-- 
Jean Delvare
