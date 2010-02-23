Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab0BWMxV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 07:53:21 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:34779 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752412Ab0BWMxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 07:53:19 -0500
X-Sasl-enc: ev7ercqE3ubFHrBCRSdkF614sXhorqYL3mdX0jc0YDBw 1266929598
Message-ID: <4B83CFBC.5030406@imap.cc>
Date: Tue, 23 Feb 2010 13:53:16 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.23) Gecko/20090825 SeaMonkey/1.1.18 Mnenhy/0.7.6.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Karsten Keil <isdn@linux-pingi.de>, David Miller <davem@davemloft.net>,
       Hansjoerg Lipp <hjlipp@web.de>, Karsten Keil <keil@b1-systems.de>,
       isdn4linux@listserv.isdn4linux.de, i4ldeveloper@listserv.isdn4linux.de,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] gigaset: reduce syslog clutter
References: <1266899531.9265.4.camel@Joe-Laptop.home>
In-Reply-To: <1266899531.9265.4.camel@Joe-Laptop.home>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches schrieb:
> Perhaps it'd be useful to add a ethtool/netif_msg interface
> and classify the messages as appropriate.

Interesting idea. On first glance, however, I don't see how to map the
Gigaset driver's diverse debugging categories (like USB communication
vs. V.25ter communication vs. ISDN subsystem communication) to the
NETIF_MSG_ flags in a useful way.

What's more, ethtool only seems to allow the setting of a numerical
message "level" enabling all debug flags "below" that level. It cannot
enable, for example, NETIF_MSG_TX_ERR without NETIF_MSG_PROBE. The
Gigaset driver OTOH follows the concept of individually selectable areas
of interest. In fact, I make frequent use of that ability when I help a
user with troubleshooting. For example, a typical first setting for a
user who cannot make an ISDN connection would be the value 0x102020
mentioned in the README.

OTOH, the ability to control the "non-debug" verbosity of the Gigaset
driver (ie. the messages not controlled by the "debug" parameter) with
ethtool/netif_msg might be appreciated. Perhaps that's what you had in mind?

Thanks,
Tilman
