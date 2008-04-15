Return-Path: <linux-kernel-owner+w=401wt.eu-S1758696AbYDOHt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758696AbYDOHt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 03:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752984AbYDOHtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 03:49:17 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51375
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752390AbYDOHtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 03:49:17 -0400
Date: Tue, 15 Apr 2008 00:49:18 -0700 (PDT)
Message-Id: <20080415.004918.91296536.davem@davemloft.net>
To: michael@ellerman.id.au
Cc: netdev@vger.kernel.org, satyam@infradead.org, mpm@selenic.com,
       linux-kernel@vger.kernel.org, k-keiichi@bx.jp.nec.com
Subject: Re: [PATCH] netconsole: only set CON_PRINTBUFFER if the user
 specifies a netconsole
From: David Miller <davem@davemloft.net>
In-Reply-To: <a3af251c8f942cf306b3b3e610883b72cce4b3cb.1208245294.git.michael@ellerman.id.au>
References: <a3af251c8f942cf306b3b3e610883b72cce4b3cb.1208245294.git.michael@ellerman.id.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Ellerman <michael@ellerman.id.au>
Date: Tue, 15 Apr 2008 17:43:12 +1000 (EST)

> Since 0bcc1816188e570bde1d56a208996660f2633ae0 (netconsole: Support
> dynamic reconfiguration using configfs), the netconsole is always
> registered, regardless of whether the user actually specified a
> netconsole configuration on the command line.
> 
> However because netconsole has CON_PRINTBUFFER set, when it is
> registered it causes the printk buffer to be replayed to all consoles.
> When there is no netconsole configured this is a) pointless, and b)
> somewhat annoying for the user of the existing console.
> 
> So instead we should only set CON_PRINTBUFFER if there is a netconsole
> configuration found on the command line. This retains the existing
> behaviour if a netconsole is setup by the user, and avoids spamming
> other consoles when we're only registering for the dynamic
> netconsole case.
> 
> Signed-off-by: Michael Ellerman <michael@ellerman.id.au>

That's a regression, so applied to net-2.6, thanks Michael.
