Return-Path: <linux-kernel-owner+w=401wt.eu-S1756059AbZDNQa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059AbZDNQa0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 12:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752098AbZDNQaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 12:30:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:24766 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178AbZDNQaK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 12:30:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,186,1239001200"; 
   d="scan'208";a="681465738"
From: "Luck, Tony" <tony.luck@intel.com>
To: "ego@in.ibm.com" <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>
CC: "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Date: Tue, 14 Apr 2009 09:29:53 -0700
Subject: RE: [tip:sched/urgent] sched: Print sched_group::__cpu_power in
	sched_domain_debug
Thread-Topic: [tip:sched/urgent] sched: Print sched_group::__cpu_power in
	sched_domain_debug
Thread-Index: Acm8srZ38v4hx1OwQ6KOHe9oVScXzgAaUHlg
Message-ID: <57C9024A16AD2D4C97DC78E552063EA39B3CF29A@orsmsx505.amr.corp.intel.com>
References: <20090330045520.2869.24777.stgit@sofia.in.ibm.com>
 <tip-46e0bb9c12f4bab539736f1714cbf16600f681ec@git.kernel.org>
 <12c511ca0904131153g39b99ec6n6c6ec2e7de3f7ea6@mail.gmail.com>
 <20090414000934.GN817@elte.hu> <20090414033936.GA534@in.ibm.com>
In-Reply-To: <20090414033936.GA534@in.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-               printk(KERN_CONT " %s (__cpu_power = %d)", str,
-                                               group->__cpu_power);
+               if (group->__cpu_power != SCHED_LOAD_SCALE)
+                       printk(KERN_CONT " %s (__cpu_power = %d)", str,
+                                                       group->__cpu_power);

Much quieter ... but perhaps a little too quiet?
Is this what you want?  Now the console output looks like this:

CPU0 attaching sched-domain:
 domain 0: span 0-15 level CPU
  groups:
CPU1 attaching sched-domain:
 domain 0: span 0-15 level CPU
  groups:
CPU2 attaching sched-domain:
 domain 0: span 0-15 level CPU
  groups:
 ...

instead of the original:

CPU0 attaching sched-domain:
 domain 0: span 0-15 level CPU
  groups: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
CPU1 attaching sched-domain:
 domain 0: span 0-15 level CPU
  groups: 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 0
CPU2 attaching sched-domain:
 domain 0: span 0-15 level CPU
  groups: 2 3 4 5 6 7 8 9 10 11 12 13 14 15 0 1
 ...

Either we don't need the empty "groups:" line, or we should
still list the cpus in the group?  I'm not really sure what
information you are trying to convey here.

-Tony

