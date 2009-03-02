Return-Path: <linux-kernel-owner+w=401wt.eu-S1758606AbZCBX7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758606AbZCBX7l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 18:59:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754187AbZCBX72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 18:59:28 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36810 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755273AbZCBX71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 18:59:27 -0500
Date: Mon, 2 Mar 2009 14:57:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: a.p.zijlstra@chello.nl, dbrownell@users.sourceforge.net,
       tglx@linutronix.de, me@felipebalbi.com, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, felipe.balbi@nokia.com,
       dmitry.torokhov@gmail.com, sameo@openedhand.com
Subject: Re: lockdep and threaded IRQs
Message-Id: <20090302145757.38a44307.akpm@linux-foundation.org>
In-Reply-To: <20090302.144647.116847598.davem@davemloft.net>
References: <1236030106.5330.1553.camel@laptop>
	<200903021409.21344.david-b@pacbell.net>
	<1236032371.5330.1654.camel@laptop>
	<20090302.144647.116847598.davem@davemloft.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Mar 2009 14:46:47 -0800 (PST)
David Miller <davem@davemloft.net> wrote:

> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Mon, 02 Mar 2009 23:19:31 +0100
> 
> > I state that every !IRQF_DISABLED usage is a bug, either due to broken
> > hardware or broken drivers.
> 
> We'll send you the bill to have everyone's hardware
> replaced :-)

yes, but with what?

No matter how fast all our interrupt handlers are, running them with
local interrupts disabled has to worsen the worst-case interrupt
latency.

I don't see how removing !IRQF_DISABLED improves the kernel - in fact
there's a latency argument for making !IRQF_DISABLED the default.
