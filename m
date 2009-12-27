Return-Path: <linux-kernel-owner+w=401wt.eu-S1752585AbZL0ER2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbZL0ER2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 23:17:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbZL0ER1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 23:17:27 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52636
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750815AbZL0ER0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 23:17:26 -0500
Date: Sat, 26 Dec 2009 20:17:29 -0800 (PST)
Message-Id: <20091226.201729.15225529.davem@davemloft.net>
To: error27@gmail.com
Cc: jarkao2@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] hamradio: avoid null deref v2
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091226123812.GB6075@bicker>
References: <20091223132550.GD17923@bicker>
	<4B3257C2.2050500@gmail.com>
	<20091226123812.GB6075@bicker>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>
Date: Sat, 26 Dec 2009 14:38:12 +0200

> Bump the stats on the original dev not on the newly assigned NULL version of
> dev.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

This doesn't look real nice.

The bpq_get_ether_dev() abstraction exists so that the details of
bpq->this and bpq->that are hidden behind it.

Exposing those details inline just to fix this bug makes the
abstraction significantly less useful, and the code more ugly.

Please just create an "orig_dev" pointer to save the original device
in, and use it to fix this problem properly.

That way you only fetch the bpq ether device pointer via the
abstraction interface.

And BTW, this is how other reviewers told you to implement this
fix. :-)

Thanks.
