Return-Path: <linux-kernel-owner+w=401wt.eu-S1754355AbXHBI6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355AbXHBI6g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 04:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbXHBI63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 04:58:29 -0400
Received: from wudika.de ([213.239.211.247]:51806 "EHLO wudika.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863AbXHBI61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 04:58:27 -0400
Message-ID: <46B19CA1.7050204@felicis.org>
Date: Thu, 02 Aug 2007 10:58:09 +0200
From: Martin Roehricht <ml@felicis.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: mingo@elte.hu
Subject: Scheduling the highest priority task
References: <8KLFD-G9-5@gated-at.bofh.it>
In-Reply-To: <8KLFD-G9-5@gated-at.bofh.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

perhaps someone can give me a hint what I should consider to look for in 
order to change the ("old" 2.6.21) scheduler such that it schedules the 
highest priority task of a given runqueue.
Given a multiprocessor system I currently observe that whenever there 
are two tasks on one CPU, the lower priority one is migrated to another 
CPU. But I don't realize why this happens. From looking at the source 
code I thought it should be the highest priority one (lowest bit set in 
the runqueue's bitmap) according to
	idx = sched_find_first_bit(array->bitmap);
within move_tasks(). The idx value is then used as an index (surprise) 
to the linked list of tasks of this particular priority and one task is 
picked:
	head = array->queue + idx;
         curr = head->prev;
         tmp = list_entry(curr, struct task_struct, run_list);

Is my assumption wrong? Using printk()s within this code section makes 
the system just hang completely quite soon. The schedstats do not notify 
me immediately. So I am a bit lost on how to track down or trace the 
problem.

Can anybody confirm that my observations are correct that the scheduler 
picks the lowest priority job of a runqueue for migration?
What needs to be changed in order to pick the highest priority one?

Martin
