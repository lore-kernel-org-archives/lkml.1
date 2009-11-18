Return-Path: <linux-kernel-owner+w=401wt.eu-S1756534AbZKRAWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534AbZKRAWQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 19:22:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756340AbZKRAWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 19:22:15 -0500
Received: from relay2.sgi.com ([192.48.179.30]:47463 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756169AbZKRAWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 19:22:15 -0500
Message-Id: <20091118002211.709343000@alcatraz.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 17 Nov 2009 18:22:11 -0600
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Yinghai Lu <yhlu.kernel@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, David Rientjes <rientjes@google.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] Limit console output by suppressing repetitious messages
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fifth version...

- Print Processor and Core ID's only for first cpu booted.


Fourth version...

- Make the cpu bootup message a static (inlinable) function.

- Remove the reference of smp_processor_id == 0 indicating the boot cpu.

- Moved Hidetoshi's latest patch (with mods to not use pr_cont()) to
  separate thread.


Third version...

- Remove Processor Summary at end of bootup sequence and added '#'
  to CPU numbers.  This makes it a bit easier to pick up the context if
  an error message disrupts the single output line of cpus.

- Remove cacheline size printout changes (dealt with in other patches)

- Modify MCE handler to send msgs to kernel debug log buffer and to not
  output an extra '\n' per cpu.

- ACPI messages moved to separate thread since they need to be submitted
  via the acpi group.

-- 
