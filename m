Return-Path: <linux-kernel-owner+w=401wt.eu-S933211AbXBWVvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933211AbXBWVvn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 16:51:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933224AbXBWVvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 16:51:43 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48602
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933211AbXBWVvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 16:51:42 -0500
Date: Fri, 23 Feb 2007 13:45:05 -0800 (PST)
Message-Id: <20070223.134505.74749340.davem@davemloft.net>
To: linux-kernel@vger.kernel.org
Subject: radeon breaks with clocksource_jiffies
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


While probeing PLL information via radeon_get_pllinfo(), it does a
"gettimeofday(); do_something(); gettimeofday();" type sequence
explicitly with interrupts disabled, so ends up with a zero
measurement which then results in a bunch of divisions by zero.

We should decide whether gettimeofday() can be expected to advance with
interrupts disabled, or that clocksource_jiffies is simply invalid because
of this behavior.
