Return-Path: <linux-kernel-owner+w=401wt.eu-S1755567AbXKEXPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbXKEXPz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 18:15:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754384AbXKEXPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 18:15:46 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41737
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754253AbXKEXPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 18:15:45 -0500
Date: Mon, 05 Nov 2007 15:15:44 -0800 (PST)
Message-Id: <20071105.151544.175839612.davem@davemloft.net>
To: kaber@trash.net
Cc: djohnson+linux-kernel@sw.starentnetworks.com, jes@trained-monkey.org,
       mchan@broadcom.com, ram.vepa@neterion.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, bguo@sw.starentnetworks.com
Subject: Re: [PATCH 1/2] NET: Re-add VLAN tag for devices incapable of
 keeping it
From: David Miller <davem@davemloft.net>
In-Reply-To: <472F5A33.20906@trash.net>
References: <472A6089.7020104@hp.com>
	<18223.22291.622615.129374@zeus.sw.starentnetworks.com>
	<472F5A33.20906@trash.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick McHardy <kaber@trash.net>
Date: Mon, 05 Nov 2007 19:00:19 +0100

> This looks like a rather expensive operation for the unlikely case
> that packets will be received by a packet socket. IMO it should only
> be reconstructed if actually needed, by af_packet itself.

Completely agreed.  We should not do this by default when %99
of the networking stack simply does not care about this.

> As we discussed some time back storing the VLAN tag in the CB on
> TX clashes with other users of the CB like qdiscs, so we need a
> new field in the skb for this anyway.

Someone will have to find a way to remove some other fields in
sk_buff before I'm going to allow more space to be eaten up
by this completely fringe case feature.
