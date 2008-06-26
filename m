Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1761377AbYFZN13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761377AbYFZN13 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 26 Jun 2008 09:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763627AbYFZN0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 09:26:55 -0400
Received: from mx.sjtu.edu.cn ([202.112.26.52]:57255 "EHLO mx2.sjtu.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763616AbYFZN0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 09:26:54 -0400
X-Greylist: delayed 1799 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Jun 2008 09:26:53 EDT
Message-ID: <20080626205650.9ifra13zswgoo0ow@webmail1.sjtu.edu.cn>
Date: Thu, 26 Jun 2008 20:56:50 +0800
From: =?gb2312?b?z8TBwQ==?= <xiaiaxaxi@sjtu.edu.cn>
To: linux-kernel@vger.kernel.org
Subject: Can I use yield in this way
MIME-Version: 1.0
Content-Type: text/plain;
	charset=GB2312;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.1.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

        I'd like to ask a question about the use of a kernel function,  
yield(); I am working on Intel Core Duo, running Linux 2.6.21 I want  
to let current process be off the cpu when the temperature of cpu is  
too high. I add a function called thermal_balance in the timer  
interrupt. My program is as following,

scheduler_tick()
{
       static int count = 0;
       count++;
       if(count % 100 == 0)
           thermal_balance();
}

static int thermal_balance(void)
{
       int cpu = smp_processor_id();
       struct task_struct* task;
       Get CPU temperature.

       if (temperature is too high){
               task = cpu_rq(cpu)->curr;
               yield();
               Move task to other cpu.
       }
}

       Can yield() be used as above. After I compile the kernel and  
run again. Kernel is not working just as it meets deadlock. And if I  
comment yield(), it runs ok. Could anyone help me?Thanks!

