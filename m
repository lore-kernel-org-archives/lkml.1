Return-Path: <linux-kernel-owner+w=401wt.eu-S1753705AbZDMWx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705AbZDMWx5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 18:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752437AbZDMWxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 18:53:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43331
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751622AbZDMWxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 18:53:44 -0400
Date: Mon, 13 Apr 2009 15:53:35 -0700 (PDT)
Message-Id: <20090413.155335.248383596.davem@davemloft.net>
To: jpirko@redhat.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, jgarzik@pobox.com,
       shemminger@linux-foundation.org, bridge@lists.linux-foundation.org,
       fubar@us.ibm.com, bonding-devel@lists.sourceforge.net, kaber@trash.net,
       mschmidt@redhat.com, dada1@cosmosbay.com, ivecera@redhat.com
Subject: Re: [PATCH 2/4] net: introduce a list of device addresses
 dev_addr_list
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090413084201.GC23734@psychotron.englab.brq.redhat.com>
References: <20090313183303.GF3436@psychotron.englab.brq.redhat.com>
	<20090413083729.GA23734@psychotron.englab.brq.redhat.com>
	<20090413084201.GC23734@psychotron.englab.brq.redhat.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Pirko <jpirko@redhat.com>
Date: Mon, 13 Apr 2009 10:42:02 +0200

> @@ -210,6 +210,12 @@ struct dev_addr_list
>  #define dmi_users	da_users
>  #define dmi_gusers	da_gusers
>  
> +struct hw_addr {
> +	struct list_head	list;
> +	unsigned char		addr[MAX_ADDR_LEN];
> +	int			refcount;
> +};
> +

Please don't pollute the global namespace with a structure name
like this.  Use "netdev_hw_addr" or "net_hw_addr".

> +static inline int __hw_addr_add(struct list_head *list, unsigned char *addr,
> +				int addr_len)

Please let the compiler inline things as it sees fit.  These
aren't routines in some header file or anything like that.
