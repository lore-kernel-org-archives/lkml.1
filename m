Return-Path: <linux-kernel-owner+w=401wt.eu-S1755505AbZJACvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbZJACvG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 22:51:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755479AbZJACvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 22:51:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55144
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755467AbZJACvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 22:51:05 -0400
Date: Wed, 30 Sep 2009 19:51:23 -0700 (PDT)
Message-Id: <20090930.195123.33813752.davem@davemloft.net>
To: shemminger@vyatta.com
Cc: sbhatewara@vmware.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, shemminger@linux-foundation.org,
       jgarzik@pobox.com, anthony@codemonkey.ws, chrisw@sous-sol.org,
       greg@kroah.com, akpm@linux-foundation.org,
       virtualization@lists.linux-foundation.org, pv-drivers@vmware.com
Subject: Re: [PATCH 2.6.32-rc1] net: VMware virtual Ethernet NIC driver:
 vmxnet3
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090930173923.4520716a@s6510>
References: <alpine.LRH.2.00.0909301432410.8073@localhost.localdomain>
	<20090930173923.4520716a@s6510>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@vyatta.com>
Date: Wed, 30 Sep 2009 17:39:23 -0700

> Why not use NETIF_F_LRO and ethtool to control LRO support?

In fact, you must, in order to handle bridging and routing
correctly.

Bridging and routing is illegal with LRO enabled, so the kernel
automatically issues the necessary ethtool commands to disable
LRO in the relevant devices.

Therefore you must support the ethtool LRO operation in order to
support LRO at all.
