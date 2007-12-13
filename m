Return-Path: <linux-kernel-owner+w=401wt.eu-S1762566AbXLMUhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762566AbXLMUhl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 15:37:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754154AbXLMUh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 15:37:29 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57378
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751641AbXLMUh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 15:37:28 -0500
Date: Thu, 13 Dec 2007 12:37:27 -0800 (PST)
Message-Id: <20071213.123727.224454625.davem@davemloft.net>
To: jarkao2@gmail.com
Cc: auke-jan.h.kok@intel.com, gallatin@myri.com, joonwpark81@gmail.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       shemminger@linux-foundation.org, jesse.brandeburg@intel.com
Subject: Re: [RFC] net: napi fix
From: David Miller <davem@davemloft.net>
In-Reply-To: <4761930C.3030504@gmail.com>
References: <20071213134953.GA3806@ff.dom.local>
	<20071213.055013.83963139.davem@davemloft.net>
	<4761930C.3030504@gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarek Poplawski <jarkao2@gmail.com>
Date: Thu, 13 Dec 2007 21:16:12 +0100

> I see in a nearby thread you would prefer to save some work to drivers
> (like this netif_running() check), but I think this all is at the cost
> of flexibility, and there will probably appear new problems, when a
> driver simply can't wait till the next poll (which btw. looks strange
> with all these hotplugging, usb and powersaving).

As someone who has actually had to edit the NAPI support of _EVERY_
single driver in the tree I can tell you that code duplication and
subtle semantic differences are a huge issue.

And when you talk about driver flexibility, it's wise to mention that
this comes at the expense of flexibility in the core implmentation.
For example, if we export the list handling widget into the ->poll()
routines, god help the person who wants to change how the poll list is
managed in net_rx_action() :-/

So we don't want to export datastructure details like that to the
driver.
