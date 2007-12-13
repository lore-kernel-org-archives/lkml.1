Return-Path: <linux-kernel-owner+w=401wt.eu-S1765079AbXLMWex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765079AbXLMWex (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 17:34:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934367AbXLMWe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 17:34:28 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50644
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S934368AbXLMWe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 17:34:26 -0500
Date: Thu, 13 Dec 2007 14:34:25 -0800 (PST)
Message-Id: <20071213.143425.142750733.davem@davemloft.net>
To: jarkao2@gmail.com
Cc: auke-jan.h.kok@intel.com, gallatin@myri.com, joonwpark81@gmail.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       shemminger@linux-foundation.org, jesse.brandeburg@intel.com
Subject: Re: [RFC] net: napi fix
From: David Miller <davem@davemloft.net>
In-Reply-To: <4761B219.1030303@gmail.com>
References: <4761930C.3030504@gmail.com>
	<20071213.123727.224454625.davem@davemloft.net>
	<4761B219.1030303@gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarek Poplawski <jarkao2@gmail.com>
Date: Thu, 13 Dec 2007 23:28:41 +0100

> ...I'm afraid I can't understand: I mean doing the same but without
> passing this info with 'work == weight': if driver sends this info,
> why it can't instead call something like napi_continue() with
> this list_move_tail() (and probably additional local_irq_disable()/
> enble() - but since it's unlikely()?) which looks much more readable,
> and saves one whole unlikely if ()?

Because the poll list is private to net_rx_action() and we don't
want to expose implementation details like that to every
->poll() implementation.
