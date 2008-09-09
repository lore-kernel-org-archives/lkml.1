Return-Path: <linux-kernel-owner+w=401wt.eu-S1757248AbYIIT5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248AbYIIT5a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 15:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754236AbYIIT5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 15:57:22 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54859
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753976AbYIIT5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 15:57:21 -0400
Date: Tue, 09 Sep 2008 12:57:14 -0700 (PDT)
Message-Id: <20080909.125714.35737132.davem@davemloft.net>
To: manfred@colorfullife.com
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       wli@holomorphy.com, sparclinux@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] prevent sparc64 from invoking irq handlers on offline
 CPUs
From: David Miller <davem@davemloft.net>
In-Reply-To: <48C6C520.5070103@colorfullife.com>
References: <20080903154217.GA6807@linux.vnet.ibm.com>
	<20080908.171708.43575256.davem@davemloft.net>
	<48C6C520.5070103@colorfullife.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manfred Spraul <manfred@colorfullife.com>
Date: Tue, 09 Sep 2008 20:49:04 +0200

> David Miller wrote:
> > And IPI handler runs in HW irq context, therefore such an IPI-creates-an-IPI
> > should not be allowed, at least not directly.
> >
> > Actually the restriction seems to be that an IPI cannot be sent when
> > "irqs_disabled()", hmmm...
> >
> >   
> Does this apply to smp_send_reschedule() as well?
> A [rare] codepath in the current rcu code does to trigger quiescent states on remote cpus.

It does work on sparc64.  Such an IPI doesn't do a wait so there would
be no deadlock issues either.

