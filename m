Return-Path: <linux-kernel-owner+w=401wt.eu-S1759539AbYETCWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759539AbYETCWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 22:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246AbYETCWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 22:22:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36605
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752151AbYETCWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 22:22:20 -0400
Date: Mon, 19 May 2008 19:22:15 -0700 (PDT)
Message-Id: <20080519.192215.193701293.davem@davemloft.net>
To: geoffrey.levand@am.sony.com
Cc: linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
       linuxppc-dev@ozlabs.org, paulus@samba.org
Subject: Re: [patch v2] LMB: Add basic spin locking to lmb
From: David Miller <davem@davemloft.net>
In-Reply-To: <48322191.6060909@am.sony.com>
References: <20080515.000203.225783838.davem@davemloft.net>
	<48321DF9.6060807@am.sony.com>
	<48322191.6060909@am.sony.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geoff Levand <geoffrey.levand@am.sony.com>
Date: Mon, 19 May 2008 17:55:45 -0700

> Add a spinlock to struct lmb to enforce concurrency in
> lmb_add(), lmb_remove(), lmb_analyze(), lmb_find(), and
> lmb_dump_all().
> 
> This locking is needed for SMP systems that access the lmb structure
> during hot memory add and remove operations after secondary cpus
> have been started.
> 
> Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
> ---
> 
> v2: o Add locking to lmb_find().

I'm not against this patch, but I'm pretty sure it's not
necessary.  Isn't memory hotplug already synchronized at
a higher level?

If not, it should be.
