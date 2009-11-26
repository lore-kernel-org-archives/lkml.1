Return-Path: <linux-kernel-owner+w=401wt.eu-S1753393AbZKZX2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393AbZKZX2B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 18:28:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752933AbZKZX2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 18:28:00 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47828
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750919AbZKZX17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 18:27:59 -0500
Date: Thu, 26 Nov 2009 15:28:16 -0800 (PST)
Message-Id: <20091126.152816.233622295.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
Subject: Re: linux-next: sparc tree build failure
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091126201607.023e1269.sfr@canb.auug.org.au>
References: <20091126201607.023e1269.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 26 Nov 2009 20:16:07 +1100

> Today's linux-next build (sparc32 defconfig) failed like this:
> 
> arch/sparc/lib/atomic32.c: In function '__atomic_add_return':
> arch/sparc/lib/atomic32.c:34: error: implicit declaration of function '__raw_spin_lock_irqsave'
> arch/sparc/lib/atomic32.c:38: error: implicit declaration of function '__raw_spin_unlock_irqrestore'
> 
> Caused by commit 4df286e52917c95c415400367cfd523dfbb0f93a ("sparc: Make
> atomic locks raw") which I have reverted for today.

Ho hum, that's the second iteration and it broke the build first time
too.

__raw_spin_lock_irqsave() definitions don't exist anywhere in the
tree, I wonder what this was even build tested against?

I'm reverting, and I'll be hard pressed to add new versions without
solid proof that it doesn't break the build a third time :-)
