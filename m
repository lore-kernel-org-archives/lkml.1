Return-Path: <linux-kernel-owner+w=401wt.eu-S1761508AbYBTIOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761508AbYBTIOz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 03:14:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760167AbYBTIOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 03:14:30 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56495
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760053AbYBTIO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 03:14:28 -0500
Date: Wed, 20 Feb 2008 00:15:05 -0800 (PST)
Message-Id: <20080220.001505.196948168.davem@davemloft.net>
To: mingo@elte.hu
Cc: tony.luck@gmail.com, rdreier@cisco.com, linux-kernel@vger.kernel.org
Subject: Re: Strange hang on ia64 with CONFIG_PRINTK_TIME=y
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080220081228.GA27036@elte.hu>
References: <12c511ca0802141817i3295e83cxd7c05e07f2c54fea@mail.gmail.com>
	<12c511ca0802191440q6a2f5604xe6b563c32c3a90b2@mail.gmail.com>
	<20080220081228.GA27036@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Wed, 20 Feb 2008 09:12:28 +0100

> 
> * Tony Luck <tony.luck@gmail.com> wrote:
> 
> > > Perhaps what is happening is that cpu0 comes online ... safely skips 
> > > over the early printk calls.  Calls cpu_init() which sets up the 
> > > resources *it* needs (ar.k3 points to per-cpu space), and then 
> > > executes sched_init() which marks it safe for all printk's. Then 
> > > cpu1 comes up and does a printk before it gets to cpu_init().
> > 
> > I just tried Ingo's patch[1] on a 2.6.25-rc2 kernel with printk 
> > timestamps turned on ... and it booted just fine on my tiger4.  The 
> > default path for non-boot cpus is from head.S to start_secondary(), 
> > and that calls cpu_init() pretty quickly.  There shouldn't normally[2] 
> > be any printk() calls on the non-boot cpu before it is safe to do so.
> 
> ok. I've queued up the patch again in sched.git, as a .25 fix. Can i add 
> your Tested-by and Acked-by tags?

Acked-by: David S. Miller <davem@davemloft.net>
