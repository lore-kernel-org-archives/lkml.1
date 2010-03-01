Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448Ab0CAIA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 03:00:27 -0500
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:54473 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750696Ab0CAIAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 03:00:25 -0500
Date: Mon, 1 Mar 2010 09:59:53 +0200
From: Jouni Malinen <j@w1.fi>
To: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: Problem with bridges and wireless NIC's
Message-ID: <20100301075953.GA32038@jm.kir.nu>
References: <9c30dffe1002281458w5705378fj52f36c5d352593fb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c30dffe1002281458w5705378fj52f36c5d352593fb@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 28, 2010 at 11:58:10PM +0100, Bjarke Istrup Pedersen wrote:

> There is a problem when trying to create a bridge containing a normal
> NIC and a wireless NIC, and using hostapd.
> 
> The problem is, that it is not possible to create a bridge containing
> a wireless NIC, if it hasn't been setup first.
> 
> Does anyone have a solution for this?

How about first creating the br0, then starting hostapd, and finally
adding wlan0 into br0?

> (The commit that introduced this problem is
> ad4bb6f8883a13bb0f65b194dae36c62a02ac779 , reverting it solves the
> problem).

I don't know whether I would call that a solution, but well..

> For more info, please have a look at this bug report:
> http://bugs.gentoo.org/show_bug.cgi?id=298824

I'm not sure whether I understood the description correctly, but this
sounds like a limitation in the way the network setup is done. Forcing
br0 to be created with wlan0 before wlan0 has been configured is not
going to work. I would consider removing wlan0 from the static
configuration of br0 and just creating br0 with eth0 with the setup
scripts and allowing hostapd to add wlan0 into br0 once the interface
has been configured properly (support for this was added in hostapd
0.7.1).
 
-- 
Jouni Malinen                                            PGP id EFC895FA
