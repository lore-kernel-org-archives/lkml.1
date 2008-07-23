Return-Path: <linux-kernel-owner+w=401wt.eu-S1754277AbYGWIpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277AbYGWIpK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 04:45:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbYGWIo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 04:44:58 -0400
Received: from s200aog14.obsmtp.com ([207.126.144.128]:41163 "EHLO
	s200aog14.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbYGWIo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 04:44:57 -0400
X-Greylist: delayed 1254 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Jul 2008 04:44:57 EDT
Message-ID: <4886EA28.4080801@st.com>
Date: Wed, 23 Jul 2008 10:22:00 +0200
From: Wolfgang Johann BETZ <wolfgang.betz@st.com>
Organization: STMicroelectronics Srl
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.4) Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Wolfgang Betz <wolfgang.betz@st.com>, mingo@elte.hu
Subject: RT task preemtion/scheduling on SMP
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ciao,

while studying how real-time tasks (i.e. SCHED_FIFO or SCHED_RR) are 
implemented on SMP systems with respect to preemption of lower priority 
tasks, I came to the following question:
On uni-processor (UP) systems higher priority tasks are guaranteed to 
preempt lower priority ones as soon as they become runnable. Now I am 
wondering what happens on SMP systems as ideally for example once a RT 
task which has a higher priority than any of the currently executing 
tasks on the different CPUs becomes runnable it should also be 
immediately scheduled on the CPU with the lowest priority currently 
executing task. So, in terms of real-time, it should be guaranteed that 
at any moment the set of runnable tasks with the highest priorities are 
actually running on the available CPUs.
Now, while studying the Linux kernel (precisely version 2.6.24.4 with 
Ingo Molnar's RT patch version 2.6.24.4-rt4 applied) it seemed to me as 
if the kernel maintains a separate run queue for each of the available 
CPUs and would anyway put a RT task which becomes (again) runnable on 
the run queue of the CPU with the lowest priority currently executing 
task, but I could not find anything which would make sure that a 
rescheduling takes place (e.g. by triggering an IPI) in case the awaking 
task has a higher priority and the current CPU is different from the 
selected one (on whose run queue it has put the awaking task).
Now, first of all I would like to ask if my observation is correct?
If yes, I am wondering if this problem has in the meanwhile been tackled 
with, is currently under investigation, is gonna be tackled with in the 
(near) future, is considered as being non resolvable (e.g. without 
compromising the overall throughput of the system too heavily), or ... 
something else?

Regards,
Wolfgang


P.S.: similarly to the above example, in case a RT task blocks, to me
       it seems as if the next task is gonna be taken from the run queue
       of the current CPU without considering that another CPU might have
       a higher priority runnable task in its run queue.


