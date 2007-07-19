Return-Path: <linux-kernel-owner+w=401wt.eu-S938396AbXGSQVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938396AbXGSQVd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 12:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764905AbXGSQVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 12:21:22 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47103 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762398AbXGSQVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 12:21:21 -0400
Date: Thu, 19 Jul 2007 17:21:05 +0100
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: andrei radulescu-banu <iubica2@yahoo.com>
Cc: Patrick McHardy <kaber@trash.net>, Krzysztof Halasa <khc@pm.waw.pl>,
       linux-kernel@vger.kernel.org,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: Linux, tcpdump and vlan
Message-ID: <20070719172105.01454686@oldman.hamilton.local>
In-Reply-To: <123837.78916.qm@web56604.mail.re3.yahoo.com>
References: <123837.78916.qm@web56604.mail.re3.yahoo.com>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2007 08:47:01 -0700 (PDT)
andrei radulescu-banu <iubica2@yahoo.com> wrote:

> The consensus seems to be that skb's need to carry vlan accelerated tags in their cb's, on rx as well as tx. VLAN_TX_SKB_CB() is perfect for that.
> 
> > [Patrick] On the TX path, it could simply use the CB, but this is actually
> also wrong (for both macvlan and real devices) since qdiscs have
> ownership of the skb in between, and at least netem *does* modify
> the CB, breaking VLAN.

No, VLAN is wrong to expect the CB to survive through layers. The CB is
a private scribble area that can be used by which ever piece of code currently
"owns" the skb.  If data needs to be passed from layer to layer, it needs to
be done as separate fields in the skb itself. If A passes an skb to B, then
the CB can be changed by B (or things it calls) before it arrives at C.



