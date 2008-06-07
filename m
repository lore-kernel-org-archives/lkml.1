Return-Path: <linux-kernel-owner+w=401wt.eu-S1760003AbYFGMe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760003AbYFGMe6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 08:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbYFGMet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 08:34:49 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:33753 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbYFGMes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 08:34:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=GSz9gLx+DqSB7FGPENq7OO9CTsHUU4k4ndcQzO5KBHLZ/Gz9td+VkPJf7qs96zW2CI
         nfEhQsMU/NehH+I2pHpDf6btradxpsovN+VHXRo/CYkLVWr10knBrq6W+JxRlEITZadb
         OaSXYMakGYwNQXUwAsMrJ5mI2p0pbwJUVOy1k=
Date: Sat, 7 Jun 2008 14:34:42 +0200
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, tglx <tglx@linutronix.de>,
       hpa <hpa@zytor.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: coding style fixes to arch/x86/kernel/sys_i386_32.c
Message-ID: <20080607143442.0d67012b@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before:
total: 16 errors, 25 warnings, 246 lines checked

After:
total: 0 errors, 7 warnings, 246 lines checked

Compile tested.

paolo@paolo-desktop:/tmp$ size sys*
   text    data     bss     dec     hex filename
   1209       0       0    1209     4b9 sys_i386_32.o.after
   1209       0       0    1209     4b9 sys_i386_32.o.before

paolo@paolo-desktop:/tmp$ md5sum sys*
6144f6d6ce7342c3e192681a1ccaa1c1  sys_i386_32.o.after
6144f6d6ce7342c3e192681a1ccaa1c1  sys_i386_32.o.before


Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/kernel/sys_i386_32.c |   64 ++++++++++++++++++++--------------------
 1 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kernel/sys_i386_32.c b/arch/x86/kernel/sys_i386_32.c
index d2ab52c..7066cb8 100644
--- a/arch/x86/kernel/sys_i386_32.c
+++ b/arch/x86/kernel/sys_i386_32.c
@@ -19,8 +19,8 @@
 #include <linux/utsname.h>
 #include <linux/ipc.h>
 
-#include <asm/uaccess.h>
-#include <asm/unistd.h>
+#include <linux/uaccess.h>
+#include <linux/unistd.h>
 
 asmlinkage long sys_mmap2(unsigned long addr, unsigned long len,
 			  unsigned long prot, unsigned long flags,
@@ -103,7 +103,7 @@ asmlinkage int old_select(struct sel_arg_struct __user *arg)
  *
  * This is really horribly ugly.
  */
-asmlinkage int sys_ipc (uint call, int first, int second,
+asmlinkage int sys_ipc(uint call, int first, int second,
 			int third, void __user *ptr, long fifth)
 {
 	int version, ret;
@@ -113,24 +113,24 @@ asmlinkage int sys_ipc (uint call, int first, int second,
 
 	switch (call) {
 	case SEMOP:
-		return sys_semtimedop (first, (struct sembuf __user *)ptr, second, NULL);
+		return sys_semtimedop(first, (struct sembuf __user *)ptr, second, NULL);
 	case SEMTIMEDOP:
 		return sys_semtimedop(first, (struct sembuf __user *)ptr, second,
 					(const struct timespec __user *)fifth);
 
 	case SEMGET:
-		return sys_semget (first, second, third);
+		return sys_semget(first, second, third);
 	case SEMCTL: {
 		union semun fourth;
 		if (!ptr)
 			return -EINVAL;
 		if (get_user(fourth.__pad, (void __user * __user *) ptr))
 			return -EFAULT;
-		return sys_semctl (first, second, third, fourth);
+		return sys_semctl(first, second, third, fourth);
 	}
 
 	case MSGSND:
-		return sys_msgsnd (first, (struct msgbuf __user *) ptr, 
+		return sys_msgsnd(first, (struct msgbuf __user *) ptr,
 				   second, third);
 	case MSGRCV:
 		switch (version) {
@@ -138,45 +138,45 @@ asmlinkage int sys_ipc (uint call, int first, int second,
 			struct ipc_kludge tmp;
 			if (!ptr)
 				return -EINVAL;
-			
+
 			if (copy_from_user(&tmp,
-					   (struct ipc_kludge __user *) ptr, 
-					   sizeof (tmp)))
+					   (struct ipc_kludge __user *) ptr,
+					   sizeof(tmp)))
 				return -EFAULT;
-			return sys_msgrcv (first, tmp.msgp, second,
+			return sys_msgrcv(first, tmp.msgp, second,
 					   tmp.msgtyp, third);
 		}
 		default:
-			return sys_msgrcv (first,
+			return sys_msgrcv(first,
 					   (struct msgbuf __user *) ptr,
 					   second, fifth, third);
 		}
 	case MSGGET:
-		return sys_msgget ((key_t) first, second);
+		return sys_msgget((key_t) first, second);
 	case MSGCTL:
-		return sys_msgctl (first, second, (struct msqid_ds __user *) ptr);
+		return sys_msgctl(first, second, (struct msqid_ds __user *) ptr);
 
 	case SHMAT:
 		switch (version) {
 		default: {
 			ulong raddr;
-			ret = do_shmat (first, (char __user *) ptr, second, &raddr);
+			ret = do_shmat(first, (char __user *) ptr, second, &raddr);
 			if (ret)
 				return ret;
-			return put_user (raddr, (ulong __user *) third);
+			return put_user(raddr, (ulong __user *) third);
 		}
 		case 1:	/* iBCS2 emulator entry point */
 			if (!segment_eq(get_fs(), get_ds()))
 				return -EINVAL;
 			/* The "(ulong *) third" is valid _only_ because of the kernel segment thing */
-			return do_shmat (first, (char __user *) ptr, second, (ulong *) third);
+			return do_shmat(first, (char __user *) ptr, second, (ulong *) third);
 		}
-	case SHMDT: 
-		return sys_shmdt ((char __user *)ptr);
+	case SHMDT:
+		return sys_shmdt((char __user *)ptr);
 	case SHMGET:
-		return sys_shmget (first, second, third);
+		return sys_shmget(first, second, third);
 	case SHMCTL:
-		return sys_shmctl (first, second,
+		return sys_shmctl(first, second,
 				   (struct shmid_ds __user *) ptr);
 	default:
 		return -ENOSYS;
@@ -186,28 +186,28 @@ asmlinkage int sys_ipc (uint call, int first, int second,
 /*
  * Old cruft
  */
-asmlinkage int sys_uname(struct old_utsname __user * name)
+asmlinkage int sys_uname(struct old_utsname __user *name)
 {
 	int err;
 	if (!name)
 		return -EFAULT;
 	down_read(&uts_sem);
-	err = copy_to_user(name, utsname(), sizeof (*name));
+	err = copy_to_user(name, utsname(), sizeof(*name));
 	up_read(&uts_sem);
-	return err?-EFAULT:0;
+	return err? -EFAULT:0;
 }
 
-asmlinkage int sys_olduname(struct oldold_utsname __user * name)
+asmlinkage int sys_olduname(struct oldold_utsname __user *name)
 {
 	int error;
 
 	if (!name)
 		return -EFAULT;
-	if (!access_ok(VERIFY_WRITE,name,sizeof(struct oldold_utsname)))
+	if (!access_ok(VERIFY_WRITE, name, sizeof(struct oldold_utsname)))
 		return -EFAULT;
-  
-  	down_read(&uts_sem);
-	
+
+	down_read(&uts_sem);
+
 	error = __copy_to_user(&name->sysname, &utsname()->sysname,
 			       __OLD_UTS_LEN);
 	error |= __put_user(0, name->sysname + __OLD_UTS_LEN);
@@ -223,9 +223,9 @@ asmlinkage int sys_olduname(struct oldold_utsname __user * name)
 	error |= __copy_to_user(&name->machine, &utsname()->machine,
 				__OLD_UTS_LEN);
 	error |= __put_user(0, name->machine + __OLD_UTS_LEN);
-	
+
 	up_read(&uts_sem);
-	
+
 	error = error ? -EFAULT : 0;
 
 	return error;
@@ -241,6 +241,6 @@ int kernel_execve(const char *filename, char *const argv[], char *const envp[])
 	long __res;
 	asm volatile ("push %%ebx ; movl %2,%%ebx ; int $0x80 ; pop %%ebx"
 	: "=a" (__res)
-	: "0" (__NR_execve),"ri" (filename),"c" (argv), "d" (envp) : "memory");
+	: "0" (__NR_execve), "ri" (filename), "c" (argv), "d" (envp) : "memory");
 	return __res;
 }
-- 
1.5.6.rc1.21.g03300

