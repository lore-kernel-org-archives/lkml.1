Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686Ab0BDCAo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 21:00:44 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46710
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754532Ab0BDCAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 21:00:42 -0500
Date: Wed, 03 Feb 2010 18:00:56 -0800 (PST)
Message-Id: <20100203.180056.206222084.davem@davemloft.net>
To: Tristram.Ha@Micrel.Com
Cc: alan@lxorguk.ukuu.org.uk, shemminger@vyatta.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.33 1/4] net: Micrel KSZ8841/2 PCI Ethernet driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <14385191E87B904DBD836449AA30269D021A4D@MORGANITE.micrel.com>
References: <14385191E87B904DBD836449AA30269D021A4D@MORGANITE.micrel.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ha, Tristram" <Tristram.Ha@Micrel.Com>
Date: Fri, 29 Jan 2010 14:37:22 -0800

> This is a resubmission of the Micrel KSZ8841/2 PCI Ethernet driver.

The procfs stuff is a non-starter.

There will undoubtedly be other devices that have switch-like
facilities that we'd like to export configuration support for.

The last thing we want is a bunch of procfs files that each
driver decides the layout and behavior of.

We need a centralized way to config such things, and probably
the best is to have a rtnl_link_ops facility to get at the
ports and configure them with attribute blobs or similar.

We also said in your first submission that the way you're
getting at the bridge STP stuff with things like:

+/* Needed for STP support. */
+#ifdef CONFIG_KSZ8842_STP
+#include <../net/bridge/br_private.h>
+#endif

Yet you left all of this stuff in there.
