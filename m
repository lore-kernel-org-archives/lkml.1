Return-Path: <linux-kernel-owner+w=401wt.eu-S1752628AbXCEELo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbXCEELo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 23:11:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbXCEELo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 23:11:44 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45309
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752628AbXCEELn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 23:11:43 -0500
Date: Sun, 04 Mar 2007 20:11:42 -0800 (PST)
Message-Id: <20070304.201142.41654149.davem@davemloft.net>
To: npiggin@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: [rfc][patch] dynamic resizing dentry hash using RCU
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070223153743.GA26141@wotan.suse.de>
References: <20070223153743.GA26141@wotan.suse.de>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <npiggin@suse.de>
Date: Fri, 23 Feb 2007 16:37:43 +0100

> So I introduce a new method for resizing hash tables with RCU, and apply
> that to the dentry hash.

Thanks for doing this work Nick.  I'm going to take your ideas
and apply them to an ipv4 routing cache dynamic growth patch I
worked on a while ago.

One minor nit:

> +struct dentry_hash {
> +	unsigned int shift;
> +	unsigned long mask;
> +	struct hlist_head *table;
> +};

I don't see any reason to make 'mask' an unsigned long
and this makes this structure take up 8 bytes more than
necessary on 64-bit.
