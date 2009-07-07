Return-Path: <linux-kernel-owner+w=401wt.eu-S1756745AbZGGIYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745AbZGGIYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 04:24:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756516AbZGGIXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 04:23:53 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:56290 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756440AbZGGIXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 04:23:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: liqin.chen@sunplusct.com, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] signals: declare sys_rt_tgsigqueueinfo in syscalls.h
Date: Tue, 7 Jul 2009 10:23:43 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.30-9-generic; KDE/4.2.95; x86_64; ; )
References: <OF7F45750A.C485B285-ON482575EC.000B875E-482575EC.000C4628@sunplusct.com>
In-Reply-To: <OF7F45750A.C485B285-ON482575EC.000B875E-482575EC.000C4628@sunplusct.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?iso-8859-1?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60?=
 =?iso-8859-1?q?Y=2Ea=5E3zb?=)
 =?iso-8859-1?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5C?=
 =?iso-8859-1?q?wg=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Message-Id: <200907071023.44008.arnd@arndb.de>
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       liqin.chen@sunplusct.com,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+o6/KBEIl6P1h8TwAxwNqXIhI/5mgvPp0HWg9
 j0/n8vonNsoMnKCaZFNNl9PCQQqF29MbSj7Onvkqn4Scu1kHtR
 BZuk5TyiH+B8+oOh4IJvA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sys_rt_tgsigqueueinfo needs to be declared in linux/syscalls.h so that
architectures defining the system call table in C can reference it.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

---
On Tuesday 07 July 2009, liqin.chen@sunplusct.com wrote:
> In file included from 
> /home/score/work-linux/work-kernel/mainline/linux-2.6.git.new2/arch/score/include/asm/unistd.h:6,
>                  from arch/score/kernel/sys_call_table.c:11:
> include/asm-generic/unistd.h:622: error: 'sys_rt_tgsigqueueinfo' 
> undeclared here (not in a f

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index fa4242c..34182de 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -321,6 +321,8 @@ asmlinkage long sys_rt_sigtimedwait(const sigset_t __user *uthese,
 				siginfo_t __user *uinfo,
 				const struct timespec __user *uts,
 				size_t sigsetsize);
+asmlinkage long sys_rt_tgsigqueueinfo(pid_t tgid, pid_t  pid, int sig,
+		siginfo_t __user *uinfo);
 asmlinkage long sys_kill(int pid, int sig);
 asmlinkage long sys_tgkill(int tgid, int pid, int sig);
 asmlinkage long sys_tkill(int pid, int sig);
