Return-Path: <linux-kernel-owner+w=401wt.eu-S965292AbXDPIqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965292AbXDPIqO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 04:46:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965287AbXDPIqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 04:46:14 -0400
Received: from smtp4.yandex.ru ([213.180.223.136]:50436 "EHLO smtp4.yandex.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965292AbXDPIqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 04:46:13 -0400
X-Greylist: delayed 344 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Apr 2007 04:46:13 EDT
X-Comment: RFC 2476 MSA function at smtp4.yandex.ru logged sender identity as: yantux
From: yantux <yantux@yandex.ru>
Organization: office
To: Linux List <linux-kernel@vger.kernel.org>
Subject: clone and waitpid syscall: return strange error
Date: Sun, 15 Apr 2007 21:41:47 -0600
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704152141.47138.yantux@yandex.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Help my please.

Question about "interactive" clone and waitpid syscalls.

Describe.
Process was create five a process using clone syscall.
Two clone calling with CLONE_THREAD, other three without CLONE_THREAD.

After then process was calling waitpid(getpid, &status, __WNOTHREAD),
then it must not checkout process, that was created by clone with 
CLONE_THREAD, is not it?

Questions.
Where define thread_info struct?
Where define list_head struct?

I right understand, that in kernel/fork.c, copy_process() function add process 
to thread group?
//1171 string number
list_add_tail_rcu(&p->thread_group, &p->group_leader->thread_group);

And do_wait contain next_thread too, but waitpid(getpid(), &status, __WALL) it 
is good, but really waitpid syscall not return info about thread, because 
return error "no child process".
I sure that is not right, or I delusion? I waiting from waitpid info about 
thread, but not error.

Best regards,
yantux.
