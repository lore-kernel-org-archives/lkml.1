Return-Path: <linux-kernel-owner+w=401wt.eu-S1758460AbYHSW5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758460AbYHSW5z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 18:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753589AbYHSWyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 18:54:40 -0400
Received: from mail9.dslextreme.com ([66.51.199.94]:39708 "HELO
	mail9.dslextreme.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756054AbYHSWyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 18:54:39 -0400
Message-ID: <48AB4F2B.9070405@gawab.com>
Date: Tue, 19 Aug 2008 15:54:35 -0700
From: Justin Madru <jdm64@gawab.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080726)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       Michal Januszewski <spock@gentoo.org>,
       Antonino Daplas <adaplas@gmail.com>, Rafael Wysocki <rjw@sisk.pl>,
       Romano Giannetti <romano.giannetti@gmail.com>,
       Adrian Bunk <bunk@kernel.org>,
       Jeremy Nickurak <kernel-bugs@atrus.rifetech.com>
Subject: [PATCH] sched: disable hrtick implementation
References: <48A9BDC0.9070800@gawab.com> <20080819003110.GH9914@elte.hu> <1219127296.10800.357.camel@twins> <20080819092543.GD28713@elte.hu> <1219138380.10800.376.camel@twins> <20080819182222.GA25576@suse.de> <48AB1F49.6040207@gawab.com> <20080819194428.GA9997@suse.de>
In-Reply-To: <20080819194428.GA9997@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hrtick implementation in 2.6.25 and .26 has been known to cause boot
problems with at least Intel GMA cards. see:

 https://bugs.freedesktop.org/show_bug.cgi?id=15602
 http://bugzilla.kernel.org/show_bug.cgi?id=10892

A full fix to hrtick went into 2.6.27 
(31656519e132f6612584815f128c83976a9aaaef),
but that fix is too intrusive to backport. Henceforth, we default to 
disable hrtick.

Signed-off-by: Justin Madru <jdm64@gawab.com>
Tested-by: Justin Madru <jdm64@gawab.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>

--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -4,7 +4,7 @@
 SCHED_FEAT(AFFINE_WAKEUPS, 1)
 SCHED_FEAT(CACHE_HOT_BUDDY, 1)
 SCHED_FEAT(SYNC_WAKEUPS, 1)
-SCHED_FEAT(HRTICK, 1)
+SCHED_FEAT(HRTICK, 0)
 SCHED_FEAT(DOUBLE_TICK, 0)
 SCHED_FEAT(NORMALIZED_SLEEPER, 1)
 SCHED_FEAT(DEADLINE, 1)

