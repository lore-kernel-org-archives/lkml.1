Return-Path: <linux-kernel-owner+w=401wt.eu-S1753532Ab0AKX7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab0AKX7G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 18:59:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752255Ab0AKX7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 18:59:05 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57669
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751592Ab0AKX7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 18:59:03 -0500
Date: Mon, 11 Jan 2010 15:59:12 -0800 (PST)
Message-Id: <20100111.155912.68138954.davem@davemloft.net>
To: mpm@selenic.com
Cc: danborkmann@googlemail.com, linux-kernel@vger.kernel.org,
       jmoyer@redhat.com, netdev@vger.kernel.org, netdev@oss.sgi.com
Subject: Re: [PATCH] netpoll: allow execution of multiple rx_hooks per
 interface
From: David Miller <davem@davemloft.net>
In-Reply-To: <1263252108.29868.4774.camel@calx>
References: <4B4630C0.6090206@gmail.com>
	<4B467A4D.9070708@gmail.com>
	<1263252108.29868.4774.camel@calx>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Mackall <mpm@selenic.com>
Date: Mon, 11 Jan 2010 17:21:48 -0600

> Looks pretty good. Dave?
> 
> Acked-by: Matt Mackall <mpm@selenic.com>

I don't like the loop for RX ARP processing.

The packet contents aren't going to change, so doing basic
packet validation inside of the "for each RX client" loop
of arp_reply() doesn't make any sense.
