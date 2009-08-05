Return-Path: <linux-kernel-owner+w=401wt.eu-S1752825AbZHEV67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825AbZHEV67 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 17:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbZHEV66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 17:58:58 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:43905 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517AbZHEV65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 17:58:57 -0400
Message-ID: <4A7A009E.2000202@us.ibm.com>
Date: Wed, 05 Aug 2009 14:58:54 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
CC: tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       mingo@elte.hu, dino@in.ibm.com, johnstul@us.ibm.com
Subject: [PATCH 0/2] futex: requeue_pi lock steal deadlock fixes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[resend: quilt mail wasn't making it to the lists for some reason]

The following patch series addresses a deadlock and a race related to the
newly introduced requeue_pi futex op codes.  I discovered this while running
I modified version of pthread_cond_many from ltp/testcases/realtime (with a PI
aware mutex) and a patched glibc (for new futex op codes).  These patches fix
the deadlock and close the race window considerably - but not 100%.  My test
case, however, now runs to completion without deadlock, and without triggering
the pi_state related WARN_ON()'s.

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team

