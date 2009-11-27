Return-Path: <linux-kernel-owner+w=401wt.eu-S1753575AbZK0Xn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbZK0Xn7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 18:43:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752365AbZK0Xn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 18:43:58 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:49523 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbZK0Xn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 18:43:58 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [PATCH 0/3] macvlan: support for guest vm direct rx/tx
Date: Sat, 28 Nov 2009 00:43:58 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Patrick Mullaney <pmullaney@novell.com>, kaber@trash.net,
       netdev@vger.kernel.org, alacrityvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org
References: <4AFAD86A.9070506@trash.net> <20091113195201.11184.25766.stgit@mimic.site> <20091113132728.0f1db7c5@s6510>
In-Reply-To: <20091113132728.0f1db7c5@s6510>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911280043.58784.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+xa4XuWN8gtuSZn6ZqPZ1QFScBpOZJXnq2g2m
 Neqq/yVGAlG+XvoNoWCRrF1LnC+gCuCdP9Y/GseZh6tUDGAtbV
 Bxf7hvn8n4tq1bREIl0aQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 November 2009, Stephen Hemminger wrote:
> Also, macvlan should really being calling netif_receive_skb()
> not going through another queue/softirq cycle.

I've added a patch for this in my experimental queue now.
When I last tried this, I saw a kernel stack overflow
but it seems fine now.

I wonder if we can also return from the macvlan hook with
skb->dev changed to netif_receive_skb rather than calling it
recursively.

	Arnd <><
