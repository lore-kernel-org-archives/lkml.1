Return-Path: <linux-kernel-owner+w=401wt.eu-S1753435AbZJXN0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbZJXN0H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 09:26:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753387AbZJXN0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 09:26:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45443
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753384AbZJXN0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 09:26:05 -0400
Date: Sat, 24 Oct 2009 06:26:28 -0700 (PDT)
Message-Id: <20091024.062628.263337033.davem@davemloft.net>
To: ebiederm@xmission.com
Cc: jesse.brandeburg@gmail.com, ddaney@caviumnetworks.com, cfriesen@nortel.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
Subject: Re: Irq architecture for multi-core network driver.
From: David Miller <davem@davemloft.net>
In-Reply-To: <m17huln1ab.fsf@fess.ebiederm.org>
References: <m13a5apmm0.fsf@fess.ebiederm.org>
	<4807377b0910231028g60b479cfycdbf3f4e25384c58@mail.gmail.com>
	<m17huln1ab.fsf@fess.ebiederm.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 23 Oct 2009 16:22:36 -0700

> irqbalance is actually more likely to move irqs than the hardware.
> I have heard promises it won't move network irqs but I have seen
> the opposite behavior.

It knows what network devices are named, and looks for those keys
in /proc/interrupts.  Anything names 'ethN' will not be moved and
if you name them on a per-queue basis properly (ie. 'ethN-RX1' etc.)
it will flat distribute those interrupts amongst the cpus in the
machine.

So if you're doing "silly stuff" and naming your devices by some other
convention, you would end up defeating the detations built into
irqbalanced.

Actually, let's not even guess, go check out the sources of the
irqbalanced running on your system and make sure it has the network
device logic in it. :-)
