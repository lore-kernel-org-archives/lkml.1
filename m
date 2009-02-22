Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbZBVH7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbZBVH7b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 02:59:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752448AbZBVH7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 02:59:20 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40473
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752428AbZBVH7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 02:59:20 -0500
Date: Sat, 21 Feb 2009 23:59:01 -0800 (PST)
Message-Id: <20090221.235901.244910753.davem@davemloft.net>
To: brian.haley@hp.com
Cc: arvidjaar@mail.ru, vladislav.yasevich@hp.com, chuck.lever@oracle.com,
       tytso@mit.edu, Valdis.Kletnieks@vt.edu, rjw@sisk.pl,
       netdev@vger.kernel.org, bonding-devel@lists.sourceforge.net,
       jamagallon@ono.com, linux-kernel@vger.kernel.org, fubar@us.ibm.com
Subject: Re: [PATCH] bonding: move IPv6 support into a separate kernel
 module
From: David Miller <davem@davemloft.net>
In-Reply-To: <499F4B61.3050508@hp.com>
References: <499F4B61.3050508@hp.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Brian Haley <brian.haley@hp.com>
Date: Fri, 20 Feb 2009 19:31:29 -0500

> [Possible fix for bonding IPv6 regression reported by Andrey Borzenkov,
> tried to keep all Cc's]
> 
> This patch moves the IPv6 bonding code into a separate kernel module
> called bonding_ipv6 if either bonding or IPv6 are built as modules.
> If both are built into the kernel then this is as well.  Bonding_ipv6.ko
> registers an "send_unsol_na" function pointer for the unsolicited
> advertisement function to be called on a failover - the default action
> is to do nothing.  The notifier callbacks are now registered in this
> module and not in the base bonding module.
> 
> Signed-off-by: Brian Haley <brian.haley@hp.com>

Thanks for taking the time to work on this Brian.

I wonder if we aren't just trading one evil for another.

Right now just configuring bonding will get the bonding
module loaded and the ipv6 facilities will be visible.

Now with your change, the user has to explicitly load
the module.  That's extremely user-unfriendly.
