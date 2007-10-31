Return-Path: <linux-kernel-owner+w=401wt.eu-S1759920AbXJaQBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759920AbXJaQBS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 12:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756571AbXJaQBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 12:01:05 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54771 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749AbXJaQBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 12:01:04 -0400
Subject: Re: sched: fix new task startup crash
From: Peter Zijlstra <peterz@infradead.org>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 31 Oct 2007 17:00:59 +0100
Message-Id: <1193846459.27652.220.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: 'Re:' in Subject but no References or In-Reply-To headers
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Commit: b9dca1e0fcb696716840a3bc8f20a6941b484dbf

seems to me that by calling enqueue_fair_task() from task_new_fair() is
wrong. The wakeup=1 in enqueue_fair_task() will cause all non-top
sched_entities to be re-positioned by place_entity().

Although the current implementation thereof seems to avoid doing
something horrible.



