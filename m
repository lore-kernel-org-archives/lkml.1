Return-Path: <linux-kernel-owner+w=401wt.eu-S1762751AbYFQXMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762751AbYFQXMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 19:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762272AbYFQXIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 19:08:40 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51473
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1762269AbYFQXIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 19:08:39 -0400
Date: Tue, 17 Jun 2008 16:08:39 -0700 (PDT)
Message-Id: <20080617.160839.112511197.davem@davemloft.net>
To: johannes@sipsolutions.net
Cc: linux-kernel@vger.kernel.org, mb@bu3sch.de, david@identd.dyndns.org,
       linux-wireless@vger.kernel.org, mingo@elte.hu,
       torvalds@linux-foundation.org
Subject: Re: [PATCH/RFC] remove irqs_disabled warning from local_bh_enable
From: David Miller <davem@davemloft.net>
In-Reply-To: <1213739834.3803.137.camel@johannes.berg>
References: <1213739834.3803.137.camel@johannes.berg>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 17 Jun 2008 23:57:14 +0200

> This warning has started to trigger with mac80211 because it can, under
> some circumstances, use spin_lock_bh() protected sections within
> irq-disabled sections. Is that a bug?

It is a bug.  The only legal nesting is base --> BH --> IRQ locking.

> Also, if you're going to treat IRQs being enabled as a bug, there's no
> point in disabling them right afterwards, is there?

It's treating IRQs being "disabled" as a bug.  It expects them to
be enabled, always.

> If you're going to reject this patch, I'll post one that adds the
> warning to local_bh_enable_ip() to allow detecting this for everybody
> and not just those poor people running UP/NO-PREEMPT :)

That might be useful :)
