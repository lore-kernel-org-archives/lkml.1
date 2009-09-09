Return-Path: <linux-kernel-owner+w=401wt.eu-S1751770AbZIIGtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770AbZIIGtE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 02:49:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbZIIGtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 02:49:03 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54207
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751353AbZIIGtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 02:49:03 -0400
Date: Tue, 08 Sep 2009 23:49:18 -0700 (PDT)
Message-Id: <20090908.234918.174793485.davem@davemloft.net>
To: mingo@elte.hu
CC: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Subject: __hw_perf_counter_init() on x86
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It seems that for most of the error returns this function
can give, we'll leak the active_counters count grabbed
at the beginning of the function and therefore we'll never
re-enable the LAPIC NMI watchdog even once all the perf
counter users go away.

Just FYI...
