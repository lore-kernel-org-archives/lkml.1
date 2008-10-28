Return-Path: <linux-kernel-owner+w=401wt.eu-S1752864AbYJ1DaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbYJ1DaJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 23:30:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbYJ1D35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 23:29:57 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:50849 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbYJ1D34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 23:29:56 -0400
Message-ID: <49068729.6000304@linux.vnet.ibm.com>
Date: Tue, 28 Oct 2008 08:59:45 +0530
From: Nageswara R Sastry <rnsastry@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Johannes Weiner <hannes@saeurebad.de>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       balbir@linux.vnet.ibm.com, ego@linux.vnet.ibm.com,
       svaidy@linux.vnet.ibm.com, davej@codemonkey.org.uk,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: [BUG] While changing the cpufreq governor, kernel hits a bug
 in workqueue.c
References: <485F8028.1070302@linux.vnet.ibm.com> <87y74w41fp.fsf@skyscraper.fehenstaub.lan> <4860BB8E.2070505@linux.vnet.ibm.com> <87tzfh2t5l.fsf@skyscraper.fehenstaub.lan> <48638906.4090308@linux.vnet.ibm.com> <87y74l4scd.fsf@skyscraper.fehenstaub.lan> <87fxqp7nye.fsf@skyscraper.fehenstaub.lan> <4871E657.3040403@linux.vnet.ibm.com> <87d4lqq7ec.fsf@saeurebad.de> <487300B1.4040300@linux.vnet.ibm.com> <877ibukn8k.fsf@saeurebad.de> <1216215897.1652.24.camel@lappy.programming.kicks-ass.net> <48A145FA.2030803@linux.vnet.ibm.com> <8763q53ot0.fsf@skyscraper.fehenstaub.lan> <87y73129ik.fsf@skyscraper.fehenstaub.lan> <48EB2EDF.5000605@linux.vnet.ibm.com>
In-Reply-To: <48EB2EDF.5000605@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nageswara R Sastry wrote:
> Any updates on this bug. Thanks in advance for your coordination.
> 
> Johannes Weiner wrote:
>>> I have not yet looked at cpufreq_conservative...
>>>
>>> Thanks for your patience and insistence,

 From long time I didn't see any activity related to this bug so posting 
again after testing on the latest stable kernel.

------------[ cut here ]------------
kernel BUG at kernel/workqueue.c:240!
invalid opcode: 0000 [#1] SMP
Modules linked in: cpufreq_powersave cpufreq_conservative 
cpufreq_userspace usb_ 
                                           storage usbhid ehci_hcd 
ohci_hcd uhci_hcd usbcore

Pid: 236, comm: kondemand/1 Not tainted (2.6.27.2 #1)
EIP: 0060:[<c0131c6e>] EFLAGS: 00010286 CPU: 1
EIP is at queue_delayed_work_on+0x24/0xa6
EAX: 00000000 EBX: c3a3c9d4 ECX: c3a3c9d4 EDX: 00000000
ESI: c3a3c9f0 EDI: f7a45658 EBP: 00000001 ESP: f7a53f3c
  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process kondemand/1 (pid: 236, ti=f7a52000 task=f7904270 task.ti=f7a52000)
Stack: 00000000 f7a43d08 c3a3c9c0 f7ab5c68 c0424ee5 00000040 00000000 
00000001
        00000040 00000000 00000002 ffffffff 00000000 ffffffff c3a3c9d8 
f7a43d08
        c3a3c9d4 f7a53f9c c013156d 00000000 00000002 00000000 c013152f 
c0424cbb
Call Trace:
  [<c0424ee5>] do_dbs_timer+0x22a/0x24a
  [<c013156d>] run_workqueue+0xbf/0x18a
  [<c013152f>] run_workqueue+0x81/0x18a
  [<c0424cbb>] do_dbs_timer+0x0/0x24a
  [<c0131e25>] worker_thread+0x0/0xbd
  [<c0131ed8>] worker_thread+0xb3/0xbd
  [<c013423c>] autoremove_wake_function+0x0/0x2d
  [<c013418a>] kthread+0x38/0x5e
  [<c0134152>] kthread+0x0/0x5e
  [<c0104503>] kernel_thread_helper+0x7/0x10
  =======================
Code: 6c c0 e9 7a ff ff ff 55 89 c5 57 89 d7 56 53 89 cb 8d 71 1c f0 0f 
ba 29 00 
                              19 c0 31 d2 85 c0 0f 85 81 00 00 00 83 79 
1c 00 74 04 <0f> 0b eb fe 8d 41 04 39 
                                                           41 04 74 04 
0f 0b eb fe 8b 54 24 10 89
EIP: [<c0131c6e>] queue_delayed_work_on+0x24/0xa6 SS:ESP 0068:f7a53f3c
---[ end trace 69cb0cd122ebfb9d ]---


P.S. This time it took just 2 minutes to reproduce this bug. Previously 
it used to happen after 30 minutes.

Please let me know if you need more details.

Thanks a lot for your coordination.

Regards
R.Nageswara Sastry

