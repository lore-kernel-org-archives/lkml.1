Return-Path: <linux-kernel-owner+w=401wt.eu-S637734AbXECVio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S637734AbXECVio (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 17:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161480AbXECVio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 17:38:44 -0400
Received: from mail.screens.ru ([213.234.233.54]:42722 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161485AbXECVin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 17:38:43 -0400
Date: Fri, 4 May 2007 01:38:35 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Tom Zanussi <zanussi@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Karim Yaghmour <karim@opersys.com>, linux-kernel@vger.kernel.org
Subject: kernel/relay.c: a strange usage of delayed_work
Message-ID: <20070503213835.GA243@tv-sign.ru>
References: <200704260110.22224.rjw@sisk.pl> <20070425165410.b73443b4.akpm@linux-foundation.org> <20070426100922.GB12892@in.ibm.com> <20070426101547.GA97@tv-sign.ru> <20070426125838.GC12892@in.ibm.com> <20070427184258.62794053.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070427184258.62794053.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

relay_switch_subbuf() does schedule_delayed_work(&buf->wake_readers, 1),
wakeup_readers() only does wake_up_interruptible() and nothing more.

Why can't we use a plain timer for this?

In any case, this "wake_up ->read_wait after a minimal possible delay"
looks somewhat strange to me, could you explain? just curious.

Oleg.

