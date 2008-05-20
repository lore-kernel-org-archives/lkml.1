Return-Path: <linux-kernel-owner+w=401wt.eu-S1760147AbYETCdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760147AbYETCdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 22:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756194AbYETCdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 22:33:13 -0400
Received: from gate.crashing.org ([63.228.1.57]:53213 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754451AbYETCdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 22:33:12 -0400
Subject: Re: [patch v2] LMB: Add basic spin locking to lmb
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: David Miller <davem@davemloft.net>
Cc: geoffrey.levand@am.sony.com, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, paulus@samba.org
In-Reply-To: <20080519.192215.193701293.davem@davemloft.net>
References: <20080515.000203.225783838.davem@davemloft.net>
	 <48321DF9.6060807@am.sony.com> <48322191.6060909@am.sony.com>
	 <20080519.192215.193701293.davem@davemloft.net>
Content-Type: text/plain
Date: Mon, 19 May 2008 22:32:58 -0400
Message-Id: <1211250778.8297.159.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-05-19 at 19:22 -0700, David Miller wrote:
> From: Geoff Levand <geoffrey.levand@am.sony.com>
> Date: Mon, 19 May 2008 17:55:45 -0700
> 
> > Add a spinlock to struct lmb to enforce concurrency in
> > lmb_add(), lmb_remove(), lmb_analyze(), lmb_find(), and
> > lmb_dump_all().
> > 
> > This locking is needed for SMP systems that access the lmb structure
> > during hot memory add and remove operations after secondary cpus
> > have been started.
> > 
> > Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
> > ---
> > 
> > v2: o Add locking to lmb_find().
> 
> I'm not against this patch, but I'm pretty sure it's not
> necessary.  Isn't memory hotplug already synchronized at
> a higher level?
> 
> If not, it should be.

I think the core memory hotplug is... However, we used to not change the
LMB when doing so (afaik, I'm travelling and not looking at the code
right now). However, things like PS3 memory hotplug tries to keep LMB is
sync for the sake of /dev/mem or similar and that happens before the
memory is added to the core.

Ben.


