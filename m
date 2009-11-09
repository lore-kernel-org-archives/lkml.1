Return-Path: <linux-kernel-owner+w=401wt.eu-S1754977AbZKIJSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977AbZKIJSk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 04:18:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754932AbZKIJSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 04:18:39 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:56114 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754896AbZKIJSi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 04:18:38 -0500
From: "Dasgupta, Romit" <romit@ti.com>
To: Pavel Machek <pavel@ucw.cz>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>
Date: Mon, 9 Nov 2009 14:48:09 +0530
Subject: RE: [PATCH 1/1] PM: Thaws refrigerated and to be exited kernel
 threads
Thread-Topic: [PATCH 1/1] PM: Thaws refrigerated and to be exited kernel
 threads
Thread-Index: AcphFxvOPMfD77rbRZuefGAoxehDHQABf6/g
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB59301DE3B67A0@dbde02.ent.ti.com>
References: <B85A65D85D7EB246BE421B3FB0FBB59301DE31F934@dbde02.ent.ti.com>
 <20091107165421.GA1630@ucw.cz>
 <B85A65D85D7EB246BE421B3FB0FBB59301DE31FCF1@dbde02.ent.ti.com>
 <20091108082727.GC16482@elf.ucw.cz>
 <B85A65D85D7EB246BE421B3FB0FBB59301DE31FD10@dbde02.ent.ti.com>
 <20091109083133.GB4818@elf.ucw.cz>
In-Reply-To: <20091109083133.GB4818@elf.ucw.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Really? I believe the "ktrhead_should_stop" is new rule, and code does
> not seem to follow it. Actually, for example audit does not seem to
> use kthread_should_stop() at all...
> 
> ./kernel/rtmutex-tester.c-
> ./kernel/rtmutex-tester.c-		/* Wait for the next 
> command to be executed */
> ./kernel/rtmutex-tester.c-		schedule();
> ./kernel/rtmutex-tester.c:		try_to_freeze();
> ./kernel/rtmutex-tester.c-
> ./kernel/rtmutex-tester.c-		if (signal_pending(current))
> ./kernel/rtmutex-tester.c-			flush_signals(current);
> --
Not a new rule. For these threads you listed no one stops them by sending 
'kthread_stop' so the problem does not arise! But for the threads that are 
stopped by invoking kthread_stop they do check kthread_should_stop. 