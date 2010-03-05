Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab0CEBT6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 20:19:58 -0500
Received: from web52303.mail.re2.yahoo.com ([206.190.48.146]:39632 "HELO
	web52303.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753294Ab0CEBT5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 20:19:57 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=XnF8jyyzhR/p1UmCCYYFJMLv0s9Qcby5dW6yp2o2BH6cCKYJq/HGkG81h/vE7Ex6tLWC/OJ/oF7OFp7gDBRYYuA1spkuvqCidnEi9O7ck590eHMZ63347Wh1rC18vIYiLGgBLXgd1lnf0M0OwF0HS5MLkZHVW8l112X/XYW4W2I=;
Message-ID: <263639.39994.qm@web52303.mail.re2.yahoo.com>
X-YMail-OSG: mwoyQ.YVM1lgaE2JSH_2rs4tH2CCxaAs5rLbKt6XouwSFbO
 FSTVc5lit80ZcV2tu1lh1GvCMAkf5Ce2gGcDIGVemmbyaV63wMD6Wj2eooqN
 EApw7wWOIfAZlrYgfiZxj7nhJbQoDrXkwTIKDVH7GZv2D3XR2iAGLnuQj7uP
 wjSRHerGLEUyRPig9SU8lvuUUG_7AekmWY99vRXnvXWJ2cRLdrG4PqNjYnuI
 nVBQKPOg8nhb24hxbCRHXoK.t3G8qVJAWgg0tqw6MHndR5VwcT6kZrrJcFL_
 6VywzXdXsg2lNgMgdqCqLppDq5luXt81ROQlNkLFLSTIukQN.IVClpEMJvxv
 tEIa3hkK0cdHA41HTT3TNVK0lSWUXok8-
X-Mailer: YahooMailClassic/9.2.12 YahooMailWebService/0.8.100.260964
Date: Thu, 4 Mar 2010 17:19:56 -0800 (PST)
From: dev nath <dev_wip_bms@yahoo.com>
Subject: fork problem in multithreaded process -- segmentation fault seen
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi *, 

I am facing a seg fault with the backtrace as below. Not sure if this is a kernel problem or glibc problem or something in the application.
 
This problem is similar to the one listed in the below URL
http://lkml.indiana.edu/hypermail/linux/kernel/9908.0/0486.html
 
Explanation of the scenario:
----------------------------
A multiple threaded process tries to fork another process and the application crashes at fork () api.  glibc-2.3.3 is used. I have ensured that the application is not doing anything between fork() and exec() api. In the pthread_mutex_init call the mutex variable seems NULL and not sure if this is something related to streams. 
 
Please help me with the problem.
 
 
 
 
Loaded symbols for /opt/montavista/pro/devkit/ppc/7xx/target/lib/libnss_files.so.2
#0  *__GI___pthread_mutex_init (mutex=0x0, mutex_attr=0x257ffe78) at spinlock.h:102
102     spinlock.h: No such file or directory.
        in spinlock.h
(gdb) bt
#0  *__GI___pthread_mutex_init (mutex=0x0, mutex_attr=0x257ffe78) at spinlock.h:102
#1  0x0f9af820 in __fresetlockfiles () at lockfile.c:77
#2  0x0f9ad59c in __pthread_fork (b=0xfb4eef8) at ptfork.c:51
#3  0x0faaaa20 in __libc_fork () at ../linuxthreads/sysdeps/unix/sysv/linux/fork.c:39
#4  0x100e8f80 in pn_exec_XXXX () at XXXX_pim_msgq_YYY_thread.c:714
#5  0x100131bc in PN_PI_ThreadStarter (theArg=0x0) at pn_pi.c:377
#6  0x0f9abd48 in pthread_start_thread (arg=0x0) at manager.c:310
#7  0x0fadc228 in ?? () at ../sysdeps/unix/sysv/linux/powerpc/powerpc32/clone.S:94
   from /opt/montavista/pro/devkit/ppc/777/target/lib/libc.so.6
warning: Previous frame inner to this frame (corrupt stack?)
(gdb) frame 0
#0  *__GI___pthread_mutex_init (mutex=0x0, mutex_attr=0x257ffe78) at spinlock.h:102
102     in spinlock.h
(gdb) frame 1
#1  0x0f9af820 in __fresetlockfiles () at lockfile.c:77
77      lockfile.c: No such file or directory.
        in lockfile.c
(gdb) list
72      in lockfile.c
(gdb) p *attr
Structure has no component named operator*.
(gdb) p attr
$1 = {__mutexkind = 1}
(gdb) p i
$2 = 0x224ee690
(gdb) p *i
$3 = {_flags = -72503612, _IO_read_ptr = 0x238f1000 "", _IO_read_end = 0x238f1000 "",
  _IO_read_base = 0x238f1000 "", _IO_write_base = 0x238f1000 "", _IO_write_ptr = 0x238f1000 "",
  _IO_write_end = 0x238f1000 "", _IO_buf_base = 0x238f1000 "",
  _IO_buf_end = 0x238f2000 <Address 0x238f2000 out of bounds>, _IO_save_base = 0x0,
  _IO_backup_base = 0x0, _IO_save_end = 0x0, _markers = 0x0, _chain = 0x10270708, _fileno = 48,
  _flags2 = 0, _old_offset = 0, _cur_column = 0, _vtable_offset = 0 '\0', _shortbuf = "",
  _lock = 0x0, _offset = -1, _codecvt = 0x0, _wide_data = 0x224ee730, _mode = -1,
  _unused2 = '\0' <repeats 40 times>, "\"Nè°\000\000\000\001\020\000\000"}


      
