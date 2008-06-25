Return-Path: <linux-kernel-owner+w=401wt.eu-S1755794AbYFYWXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794AbYFYWXn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 18:23:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753003AbYFYWXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 18:23:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59496
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752736AbYFYWXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 18:23:34 -0400
Date: Wed, 25 Jun 2008 15:23:34 -0700 (PDT)
Message-Id: <20080625.152334.32728378.davem@davemloft.net>
To: vda.linux@googlemail.com
Cc: mpatocka@redhat.com, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: Re: [3/10 PATCH] inline wake_up_bit
From: David Miller <davem@davemloft.net>
In-Reply-To: <200806251724.57689.vda.linux@googlemail.com>
References: <200806251617.40871.vda.linux@googlemail.com>
	<Pine.LNX.4.64.0806251031330.7542@engineering.redhat.com>
	<200806251724.57689.vda.linux@googlemail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Wed, 25 Jun 2008 17:24:57 +0200

> talk to gcc people to remedy insane call convention sounds as a more
> workable solution.

It's not a tenable solution to this problem.  We have to make this
work properly with compiler tools currently available to users, rather
than versions of gcc that don't even exist yet.

And what's more, the amount we can get back from the current stack
size allocation is, at best, 16 bytes.  The problem isn't going away
no matter what we do to the compiler.

> BTW, i386 uses regparm call convention, is similar trick
> possible for sparc64?

sparc64 already passes arguments in registers.

The stack frame is (predominantly, size wise) to accomodate the save
area for the cpu's register windows in non-leaf functions, and that
isn't going anywhere.

Back to the patch set, several of these non-inlined cases really
are extremely suboptimal.  If it's just moving args around, it
should be inline.  This would help even x86.

Also, suggesting that IRQSTACKS are mandatory for correct operation is
a pretty unreasonable thing to say.  It's currently still optional on
the platforms where it is implemented, so I wonder if this means that
correct operation is optional on these platforms? :-)

I have a sparc64 IRQSTACKS implementation that I'm working on, but
it's not something I can stick into 2.6.26 by any stretch of the
imagination.
