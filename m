Return-Path: <linux-kernel-owner+w=401wt.eu-S1758770AbYGCOdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758770AbYGCOdi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 10:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbYGCOd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 10:33:28 -0400
Received: from mx.sjtu.edu.cn ([202.112.26.52]:47912 "EHLO mx2.sjtu.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129AbYGCOd1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 10:33:27 -0400
Message-ID: <20080703223323.u3i8r8wg04ww48c8@webmail1.sjtu.edu.cn>
Date: Thu, 03 Jul 2008 22:33:23 +0800
From: xialiang <xiaiaxaxi@sjtu.edu.cn>
To: linux-kernel@vger.kernel.org
Subject: Why does migration take quite a long time?
MIME-Version: 1.0
Content-Type: text/plain;
	charset=GB2312;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Internet Messaging Program (IMP) H3 (4.1.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

     I've got a problem about the migration_thread. Migration_thread  
is used to migrate a specific task from one cpu to another. I use it  
to let one task migrate between cpus.
     I am working on Intel Duo Core and with Linux 2.6.21. And my  
problem is that the migration thread sometimes takes short time to  
finish, but sometimes takes lots of time to finish. Because I can't do  
another migration through migration thread before the previous  
migration finishes, I can only wait a long time.
     My function my_migrate() is called in softirq, just like  
load_balance() does.

My pseudocode is like following,
/**********************/
static int xl_migrate(int this_cpu, struct rq* this_rq)
{
	int dest_cpu;
	static int flag = 0;
	struct task_struct* curr;

	/* flag = 1 means code is being run, and migration code is protected.*/
         if(flag == 1)
                 return 0;

         if( Currently running is a task I want to migrate... ){
                 flag = 1;
                 Set dest_cpu...
                 sched_migrate_task(curr, mycpu);
                 printk("%s:migrate to cpu %d\n", today, mycpu);
                 flag = 0;
         }
         return 0;
}
/**********************/

      It seems that the printk is showed long after the thread  
migration is done. I don't know why the completion of migration is so  
slow. Or any code is wrong? Can anyone help me? Thanks!

Best regards,
Liang

