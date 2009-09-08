Return-Path: <linux-kernel-owner+w=401wt.eu-S1754440AbZIHMKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440AbZIHMKc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 08:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754197AbZIHMKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 08:10:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46013
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754111AbZIHMKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 08:10:30 -0400
Date: Tue, 08 Sep 2009 05:10:45 -0700 (PDT)
Message-Id: <20090908.051045.26522683.davem@davemloft.net>
To: linux-kernel@vger.kernel.org
CC: a.p.zijlstra@chello.nl, mingo@elte.hu, jens.axboe@oracle.com
Subject: [PATCH 0/2]: Get perf counters working on D-cache aliasing cpus.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


With Jen's Axboe's basic sparc counter patch in my tree I started
playing with it on sparc64.  Turns out it won't work on anything
pre-Niagara.

The issue is D-cache aliasing between the kernel side mapping
and the user side mapping of the perf event ring buffer.

The following two patches attempt to address this issue and
are working properly on my test machine.
