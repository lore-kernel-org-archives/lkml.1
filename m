Return-Path: <linux-kernel-owner+w=401wt.eu-S1753586AbXC3Hqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbXC3Hqb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 03:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbXC3Hqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 03:46:31 -0400
Received: from 25.mail-out.ovh.net ([213.186.37.103]:50968 "HELO
	25.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753198AbXC3Hqa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 03:46:30 -0400
Date: 30 Mar 2007 07:46:27 -0000
To: gl@dsa-ac.de, jeff@garzik.org
Subject: Re: [git patches] net driver fixes
X-IlohaMail-Blah: samuel@sortiz.org
X-IlohaMail-Method: mail() [mem]
X-IlohaMail-Dummy: moo
X-Mailer: OVH (On: ssl0.ovh.net)
Message-ID: <cyuyCPrK.1175240787.9348410.samuel@sortiz.org>
In-Reply-To: <Pine.LNX.4.63.0703300922490.534@pcgl.dsa-ac.de>
From: "Samuel Ortiz" <samuel@sortiz.org>
Bounce-To: "Samuel Ortiz" <samuel@sortiz.org>
CC: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "LKML" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On 3/30/2007, "Guennadi Liakhovetski" <gl@dsa-ac.de> wrote:

>On Thu, 29 Mar 2007, Jeff Garzik wrote:
>
>> Guennadi Liakhovetski wrote:
>>> Jeff, might be worth getting the sk_buff leak fix in ppp from
>>> http://www.spinics.net/lists/netdev/msg27706.html in 2.6.21 too?
>>>
>>> Don't know how important it is for stable. It was present in 2.6.18 too.
>>
>> Can you resend the patch to me, please?
>>
>> Easier for the system to apply than the URL...
>
>Sure, attached below. I think, though, this patch is already in someone's
>tree. Andrew has applied it to -mm under the name
>
>ppp-dont-leak-an-sk_buff-on-interface-destruction.patch
>
>but then dropped with the reasoning "This patch was dropped because it was
>merged into mainline or a subsystem tree". So, maybe it is now in Samuel's
>IrDA tree. Samuel?So, maybe all you have to do is to pull it from his
>tree.
It's already in Linus tree, and has landed there through davem's
net-2.6 tree.
So, this is all taken care of, Jeff doesn't need to worry about this one.

Cheers,
Samuel.


>Thanks
>Guennadi
>---------------------------------
>Guennadi Liakhovetski, Ph.D.
>DSA Daten- und Systemtechnik GmbH
>Pascalstr. 28
>D-52076 Aachen
>Germany
>
>Don't leak an sk_buff on interface destruction.
>
>Signed-off-by: G. Liakhovetski <gl@dsa-ac.de>
>
>--- a/drivers/net/ppp_generic.c	2007-03-23 13:04:04.000000000 +0100
>+++ b/drivers/net/ppp_generic.c	2007-03-23 13:05:29.000000000 +0100
>@@ -2544,6 +2544,9 @@
>  	ppp->active_filter = NULL;
>  #endif /* CONFIG_PPP_FILTER */
>
>+	if (ppp->xmit_pending)
>+		kfree_skb(ppp->xmit_pending);
>+
>  	kfree(ppp);
>  }
>
