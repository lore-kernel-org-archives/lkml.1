Return-Path: <linux-kernel-owner+w=401wt.eu-S1759669AbYDPDbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759669AbYDPDbW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 23:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755339AbYDPDbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 23:31:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46273
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755113AbYDPDbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 23:31:06 -0400
Date: Tue, 15 Apr 2008 20:31:08 -0700 (PDT)
Message-Id: <20080415.203108.55491723.davem@davemloft.net>
To: tonyb@cybernetics.com
Cc: mcarlson@broadcom.com, herbert@gondor.apana.org.au, mchan@broadcom.com,
       netdev@vger.kernel.org, gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: TG3 network data corruption regression 2.6.24/2.6.23.4
From: David Miller <davem@davemloft.net>
In-Reply-To: <4804CC2F.6030403@cybernetics.com>
References: <47BC44E2.9060301@cybernetics.com>
	<20080415001207.GA11852@localdomain>
	<4804CC2F.6030403@cybernetics.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tony Battersby <tonyb@cybernetics.com>
Date: Tue, 15 Apr 2008 11:39:27 -0400

> Thanks, your patch fixes the problem (tested on 2.6.24.4).  However, I
> had to change "(skb->mac_header & 3)" in your patch to "((long)
> skb->mac_header & 3)" since mac_header is a pointer rather than an int
> on 32-bit systems.
> 
> Tested-by: Tony Battersby <tonyb@cybernetics.com>

Thanks for testing.

Matt, skb->mac_header is either a pointer or an integer offset
depending upon whether we are building 32-bit or 64-bit.

Testing skb->mac_header is therefore wrong, because it's an
offset from a pointer in the 64-bit case and therefore it's
alignment does not indicate correctly the actual final alignment
of skb->head + skb->max_header.

Therefore you should test skb_mac_header(skb) and cast it with
(unsigned long).

Please respin this fix with that correction so I can apply it
and get this bug fixed, thanks!
