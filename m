Return-Path: <linux-kernel-owner+w=401wt.eu-S1751120AbZK1Fid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751120AbZK1Fid (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 00:38:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750923AbZK1Fic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 00:38:32 -0500
Received: from mail.vyatta.com ([76.74.103.46]:58567 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881AbZK1Fic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 00:38:32 -0500
Date: Fri, 27 Nov 2009 21:38:24 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: David Miller <davem@davemloft.net>
Cc: arnd@arndb.de, pmullaney@novell.com, kaber@trash.net,
       netdev@vger.kernel.org, alacrityvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: Re: [PATCH 0/3] macvlan: support for guest vm direct rx/tx
Message-ID: <20091127213824.53c5a23a@nehalam>
In-Reply-To: <20091127.161957.243886653.davem@davemloft.net>
References: <20091113195201.11184.25766.stgit@mimic.site>
	<20091113132728.0f1db7c5@s6510>
	<200911280043.58784.arnd@arndb.de>
	<20091127.161957.243886653.davem@davemloft.net>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Nov 2009 16:19:57 -0800 (PST)
David Miller <davem@davemloft.net> wrote:

> From: Arnd Bergmann <arnd@arndb.de>
> Date: Sat, 28 Nov 2009 00:43:58 +0100
> 
> > On Friday 13 November 2009, Stephen Hemminger wrote:
> >> Also, macvlan should really being calling netif_receive_skb()
> >> not going through another queue/softirq cycle.
> > 
> > I've added a patch for this in my experimental queue now.
> > When I last tried this, I saw a kernel stack overflow
> > but it seems fine now.
> 
> I think it is unwise for any virtual device layer to use netif_receive_skb().
> Just like tunnels they should always use netif_rx().
> 
> Otherwise stack overflow is a very real concern.

Maybe we should figure out a way for protocols to return new skb in netif_receive_skb
to avoid extra softirq, but avoid stack overflow?

-- 
