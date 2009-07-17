Return-Path: <linux-kernel-owner+w=401wt.eu-S934728AbZGQQMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934728AbZGQQMj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 12:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964861AbZGQQMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 12:12:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:42209 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934708AbZGQQMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 12:12:38 -0400
Subject: Re: [patch 2/2] sched: fix nr_uninterruptible accounting of frozen
 tasks really
From: Peter Zijlstra <peterz@infradead.org>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Rafael Wysocki <rjw@sisk.pl>,
       Ingo Molnar <mingo@elte.hu>, Nathan Lynch <ntl@pobox.com>,
       Nigel Cunningham <nigel@tuxonice.net>, stable@kernel.org,
       containers@lists.linux-foundation.org,
       linux-pm@lists.linux-foundation.org
In-Reply-To: <20090717155116.GB5878@count0.beaverton.ibm.com>
References: <20090717121545.489258927@linutronix.de>
	 <20090717122103.225652146@linutronix.de>
	 <20090717155116.GB5878@count0.beaverton.ibm.com>
Content-Type: text/plain
Date: Fri, 17 Jul 2009 17:55:27 +0200
Message-Id: <1247846127.6522.21.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-17 at 08:51 -0700, Matt Helsley wrote:

> So it's not clear to me how adding PF_FREEZING fixes anything. Am I
> missing something?

Yep, PF_FROZEN is only observed going into schedule(), on the way back
out thaw_process() will already have cleared the flag.

So we don't increment in deactivate_task(), but we do decrement in
activate_task(), yielding for some very unbalanced accounting.

