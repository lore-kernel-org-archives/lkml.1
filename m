Return-Path: <linux-kernel-owner+w=401wt.eu-S1757734AbXGCVUD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757734AbXGCVUD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 17:20:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753611AbXGCVTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 17:19:52 -0400
Received: from gate.crashing.org ([63.228.1.57]:42427 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129AbXGCVTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 17:19:52 -0400
Subject: Re: [PATCH -mm] PM: Prevent frozen user mode helpers from failing
	the freezing of tasks (rev. 2)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Uli Luckas <u.luckas@road.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20070703174503.GB108@tv-sign.ru>
References: <200706252352.24137.rjw@sisk.pl>
	 <20070625215527.GE2051@elf.ucw.cz> <200706260027.02396.rjw@sisk.pl>
	 <1183440646.10386.66.camel@localhost.localdomain>
	 <20070703174503.GB108@tv-sign.ru>
Content-Type: text/plain
Date: Wed, 04 Jul 2007 07:19:12 +1000
Message-Id: <1183497552.3388.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Actually, spinlock_t is not suitable. Because spin_unlcok() does NOT imply
> mb(). The subsequent wait_event_timeout()->atomic_read() may leak into the
> critical section.
> 
> We can use set_mb(), if we don't want to play with smp_mb() by hand :)

spin_unlock implies a smp_wmb() but yeah, not a full mb(), though having
a read leak into a critical section is generally not an issue.

Ben.


