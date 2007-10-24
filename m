Return-Path: <linux-kernel-owner+w=401wt.eu-S1754050AbXJXBH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050AbXJXBH3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 21:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbXJXBHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 21:07:19 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34283
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752807AbXJXBHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 21:07:17 -0400
Date: Tue, 23 Oct 2007 18:07:44 -0700 (PDT)
Message-Id: <20071023.180744.115914004.davem@davemloft.net>
To: jeff@garzik.org
Cc: netdev@vger.kernel.org, davej@redhat.com, auke-jan.h.kok@intel.com,
       ajax@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] e1000, e1000e valid-addr fixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <471E99E8.6030404@garzik.org>
References: <20071023.145339.55504234.davem@davemloft.net>
	<471E9801.2000006@garzik.org>
	<471E99E8.6030404@garzik.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jeff@garzik.org>
Date: Tue, 23 Oct 2007 21:03:36 -0400

> I'm wondering if there is a way to avoid adding
> 
> 	if (!is_valid_ether_addr(dev->dev_addr))
> 		return -EINVAL;
> 
> to every ethernet driver's ->open() hook.

The first idea I get is:

1) Create netdev->validate_dev_addr().

2) If it exists, invoke it before ->open(), abort
   and return if any errors signaled.

etherdev init hooks up a function that does the above
check, which allows us to avoid editing every ethernet
driver

What do you think?
