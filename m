Return-Path: <linux-kernel-owner+w=401wt.eu-S1764351AbXESW0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764351AbXESW0x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 18:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760152AbXESW0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 18:26:46 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32918
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759928AbXESW0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 18:26:46 -0400
Date: Sat, 19 May 2007 15:26:49 -0700 (PDT)
Message-Id: <20070519.152649.102577495.davem@davemloft.net>
To: akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org
Subject: that page count overflow thing
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I think we may be able to fix that one without making the
counter larger, it's silly overhead for such an extreme
case IMHO.

Perhaps it might be possible to just make the counter stick at it's
maximum, and when it's there we have an rbtree of external "large"
counters, keyed by page struct address.

So basically externalize counters that go over the maximally
representable value.  In this way only the idiotic cases pay
the price.
