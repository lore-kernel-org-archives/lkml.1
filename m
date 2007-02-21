Return-Path: <linux-kernel-owner+w=401wt.eu-S1423105AbXBUUeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423105AbXBUUeJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 15:34:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423104AbXBUUdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 15:33:45 -0500
Received: from [198.99.130.12] ([198.99.130.12]:59700 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1423102AbXBUUdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 15:33:39 -0500
Message-Id: <200702212025.l1LKPJYO006779@ccure.user-mode-linux.org>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.0.4
To: akpm@osdl.org
cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: [PATCH 2/4] UML - formatting fixes
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Wed, 21 Feb 2007 15:25:19 -0500
From: Jeff Dike <jdike@addtoit.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Formatting fixes -
	style violations
	whitespace breakage
	emacs formatting comment removal

Signed-off-by: Jeff Dike <jdike@addtoit.com>
--
 arch/um/kernel/um_arch.c  |   51 +++++++++++++++++++++----------------------
 arch/um/os-Linux/main.c   |   11 +++++----
 arch/um/sys-i386/bugs.c   |   54 ++++++++++++++++++++--------------------------
 arch/um/sys-x86_64/bugs.c |   34 ++++++++++------------------
 4 files changed, 67 insertions(+), 83 deletions(-)

Index: linux-2.6.17/arch/um/kernel/um_arch.c
===================================================================
--- linux-2.6.17.orig/arch/um/kernel/um_arch.c	2007-02-19 11:39:10.000000000 -0500
+++ linux-2.6.17/arch/um/kernel/um_arch.c	2007-02-19 12:53:54.000000000 -0500
@@ -64,8 +64,8 @@ struct cpuinfo_um boot_cpu_data = { 
 
 unsigned long thread_saved_pc(struct task_struct *task)
 {
-	return(os_process_pc(CHOOSE_MODE_PROC(thread_pid_tt, thread_pid_skas,
-					      task)));
+	return os_process_pc(CHOOSE_MODE_PROC(thread_pid_tt, thread_pid_skas,
+					      task));
 }
 
 static int show_cpuinfo(struct seq_file *m, void *v)
@@ -87,7 +87,7 @@ static int show_cpuinfo(struct seq_file 
 		   loops_per_jiffy/(500000/HZ),
 		   (loops_per_jiffy/(5000/HZ)) % 100);
 
-	return(0);
+	return 0;
 }
 
 static void *c_start(struct seq_file *m, loff_t *pos)
@@ -213,12 +213,12 @@ __uml_setup("debug", no_skas_debug_setup
 #ifdef CONFIG_SMP
 static int __init uml_ncpus_setup(char *line, int *add)
 {
-       if (!sscanf(line, "%d", &ncpus)) {
-               printf("Couldn't parse [%s]\n", line);
-               return -1;
-       }
+	if (!sscanf(line, "%d", &ncpus)) {
+		printf("Couldn't parse [%s]\n", line);
+		return -1;
+	}
 
-       return 0;
+	return 0;
 }
 
 __uml_setup("ncpus=", uml_ncpus_setup,
@@ -235,7 +235,7 @@ static int force_tt = 0;
 static int __init mode_tt_setup(char *line, int *add)
 {
 	force_tt = 1;
-	return(0);
+	return 0;
 }
 
 #else
@@ -246,7 +246,7 @@ static int __init mode_tt_setup(char *li
 static int __init mode_tt_setup(char *line, int *add)
 {
 	printf("CONFIG_MODE_TT disabled - 'mode=tt' ignored\n");
-	return(0);
+	return 0;
 }
 
 #else
@@ -257,7 +257,7 @@ static int __init mode_tt_setup(char *li
 static int __init mode_tt_setup(char *line, int *add)
 {
 	printf("CONFIG_MODE_SKAS disabled - 'mode=tt' redundant\n");
-	return(0);
+	return 0;
 }
 
 #endif
@@ -275,16 +275,15 @@ int mode_tt = DEFAULT_TT;
 
 static int __init Usage(char *line, int *add)
 {
- 	const char **p;
+	const char **p;
 
 	printf(usage_string, init_utsname()->release);
- 	p = &__uml_help_start;
- 	while (p < &__uml_help_end) {
- 		printf("%s", *p);
- 		p++;
- 	}
+	p = &__uml_help_start;
+	while (p < &__uml_help_end) {
+		printf("%s", *p);
+		p++;
+	}
 	exit(0);
-
 	return 0;
 }
 
@@ -380,8 +379,8 @@ int linux_main(int argc, char **argv)
 					  set_task_sizes_skas, &task_size);
 
 	/*
- 	 * Setting up handlers to 'sig_info' struct
- 	 */
+	 * Setting up handlers to 'sig_info' struct
+	 */
 	os_fill_handlinfo(handlinfo_kern);
 
 	brk_start = (unsigned long) sbrk(0);
@@ -408,7 +407,7 @@ int linux_main(int argc, char **argv)
 	argv1_begin = argv[1];
 	argv1_end = &argv[1][strlen(argv[1])];
 #endif
-  
+
 	highmem = 0;
 	iomem_size = (iomem_size + PAGE_SIZE - 1) & PAGE_MASK;
 	max_physmem = get_kmem_end() - uml_physmem - iomem_size - MIN_VMALLOC;
@@ -450,12 +449,12 @@ int linux_main(int argc, char **argv)
 		printf("Kernel virtual memory size shrunk to %lu bytes\n",
 		       virtmem_size);
 
-  	uml_postsetup();
+	uml_postsetup();
 
 	task_protections((unsigned long) &init_thread_info);
 	os_flush_stdout();
 
-	return(CHOOSE_MODE(start_uml_tt(), start_uml_skas()));
+	return CHOOSE_MODE(start_uml_tt(), start_uml_skas());
 }
 
 extern int uml_exitcode;
@@ -468,7 +467,7 @@ static int panic_exit(struct notifier_bl
 	bust_spinlocks(0);
 	uml_exitcode = 1;
 	machine_halt();
-	return(0);
+	return 0;
 }
 
 static struct notifier_block panic_exit_notifier = {
@@ -483,14 +482,14 @@ void __init setup_arch(char **cmdline_p)
 			&panic_exit_notifier);
 	paging_init();
         strlcpy(saved_command_line, command_line, COMMAND_LINE_SIZE);
- 	*cmdline_p = command_line;
+	*cmdline_p = command_line;
 	setup_hostinfo();
 }
 
 void __init check_bugs(void)
 {
 	arch_check_bugs();
- 	os_check_bugs();
+	os_check_bugs();
 }
 
 void apply_alternatives(struct alt_instr *start, struct alt_instr *end)
Index: linux-2.6.17/arch/um/os-Linux/main.c
===================================================================
--- linux-2.6.17.orig/arch/um/os-Linux/main.c	2007-02-19 12:52:22.000000000 -0500
+++ linux-2.6.17/arch/um/os-Linux/main.c	2007-02-19 12:52:59.000000000 -0500
@@ -218,7 +218,7 @@ int main(int argc, char **argv, char **e
 		ret = 1;
 	}
 	printf("\n");
-	return(uml_exitcode);
+	return uml_exitcode;
 }
 
 #define CAN_KMALLOC() \
@@ -231,7 +231,7 @@ void *__wrap_malloc(int size)
 	void *ret;
 
 	if(!CAN_KMALLOC())
-		return(__real_malloc(size));
+		return __real_malloc(size);
 	else if(size <= PAGE_SIZE) /* finding contiguos pages can be hard*/
 		ret = um_kmalloc(size);
 	else ret = um_vmalloc(size);
@@ -242,16 +242,17 @@ void *__wrap_malloc(int size)
 	if(ret == NULL)
 		errno = ENOMEM;
 
-	return(ret);
+	return ret;
 }
 
 void *__wrap_calloc(int n, int size)
 {
 	void *ptr = __wrap_malloc(n * size);
 
-	if(ptr == NULL) return(NULL);
+	if(ptr == NULL)
+		return NULL;
 	memset(ptr, 0, n * size);
-	return(ptr);
+	return ptr;
 }
 
 extern void __real_free(void *);
Index: linux-2.6.17/arch/um/sys-i386/bugs.c
===================================================================
--- linux-2.6.17.orig/arch/um/sys-i386/bugs.c	2007-02-19 12:52:22.000000000 -0500
+++ linux-2.6.17/arch/um/sys-i386/bugs.c	2007-02-19 12:52:59.000000000 -0500
@@ -1,4 +1,4 @@
-/* 
+/*
  * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
  * Licensed under the GPL
  */
@@ -32,21 +32,21 @@ static char token(int fd, char *buf, int
 		n = os_read_file(fd, ptr, sizeof(*ptr));
 		c = *ptr++;
 		if(n != sizeof(*ptr)){
-			if(n == 0) return(0);
+			if(n == 0)
+				return 0;
 			printk("Reading /proc/cpuinfo failed, err = %d\n", -n);
 			if(n < 0)
-				return(n);
-			else
-				return(-EIO);
+				return n;
+			else return -EIO;
 		}
 	} while((c != '\n') && (c != stop) && (ptr < end));
 
 	if(ptr == end){
 		printk("Failed to find '%c' in /proc/cpuinfo\n", stop);
-		return(-1);
+		return -1;
 	}
 	*(ptr - 1) = '\0';
-	return(c);
+	return c;
 }
 
 static int find_cpuinfo_line(int fd, char *key, char *scratch, int len)
@@ -58,25 +58,25 @@ static int find_cpuinfo_line(int fd, cha
 	while(1){
 		c = token(fd, scratch, len - 1, ':');
 		if(c <= 0)
-			return(0);
+			return 0;
 		else if(c != ':'){
 			printk("Failed to find ':' in /proc/cpuinfo\n");
-			return(0);
+			return 0;
 		}
 
 		if(!strncmp(scratch, key, strlen(key)))
-			return(1);
+			return 1;
 
 		do {
 			n = os_read_file(fd, &c, sizeof(c));
 			if(n != sizeof(c)){
 				printk("Failed to find newline in "
 				       "/proc/cpuinfo, err = %d\n", -n);
-				return(0);
+				return 0;
 			}
 		} while(c != '\n');
 	}
-	return(0);
+	return 0;
 }
 
 static int check_cpu_flag(char *feature, int *have_it)
@@ -96,7 +96,8 @@ static int check_cpu_flag(char *feature,
 		goto out;
 
 	c = token(fd, buf, len - 1, ' ');
-	if(c < 0) goto out;
+	if(c < 0)
+		goto out;
 	else if(c != ' '){
 		printk("Failed to find ' ' in /proc/cpuinfo\n");
 		goto out;
@@ -104,7 +105,8 @@ static int check_cpu_flag(char *feature,
 
 	while(1){
 		c = token(fd, buf, len - 1, ' ');
-		if(c < 0) goto out;
+		if(c < 0)
+			goto out;
 		else if(c == '\n') break;
 
 		if(!strcmp(buf, feature)){
@@ -113,8 +115,10 @@ static int check_cpu_flag(char *feature,
 		}
 	}
  out:
-	if(*have_it == 0) printk("No\n");
-	else if(*have_it == 1) printk("Yes\n");
+	if(*have_it == 0)
+		printk("No\n");
+	else if(*have_it == 1)
+		printk("Yes\n");
 	os_close_file(fd);
 	return 1;
 }
@@ -166,12 +170,13 @@ int arch_handle_signal(int sig, union um
 	/* This is testing for a cmov (0x0f 0x4x) instruction causing a
 	 * SIGILL in init.
 	 */
-	if((sig != SIGILL) || (TASK_PID(get_current()) != 1)) return(0);
+	if((sig != SIGILL) || (TASK_PID(get_current()) != 1))
+		return 0;
 
 	if (copy_from_user_proc(tmp, (void *) UPT_IP(regs), 2))
 		panic("SIGILL in init, could not read instructions!\n");
 	if((tmp[0] != 0x0f) || ((tmp[1] & 0xf0) != 0x40))
-		return(0);
+		return 0;
 
 	if(host_has_cmov == 0)
 		panic("SIGILL caused by cmov, which this processor doesn't "
@@ -185,16 +190,5 @@ int arch_handle_signal(int sig, union um
 		      "implements it, boot a filesystem compiled for older "
 		      "processors");
 	else panic("Bad value for host_has_cmov (%d)", host_has_cmov);
-	return(0);
+	return 0;
 }
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
Index: linux-2.6.17/arch/um/sys-x86_64/bugs.c
===================================================================
--- linux-2.6.17.orig/arch/um/sys-x86_64/bugs.c	2007-02-19 12:52:22.000000000 -0500
+++ linux-2.6.17/arch/um/sys-x86_64/bugs.c	2007-02-19 12:52:59.000000000 -0500
@@ -21,7 +21,7 @@ void arch_check_bugs(void)
 
 int arch_handle_signal(int sig, union uml_pt_regs *regs)
 {
-	return(0);
+	return 0;
 }
 
 #define MAXTOKEN 64
@@ -41,21 +41,21 @@ static char token(int fd, char *buf, int
 		n = os_read_file(fd, ptr, sizeof(*ptr));
 		c = *ptr++;
 		if(n != sizeof(*ptr)){
-			if(n == 0) return(0);
+			if(n == 0)
+				return 0;
 			printk("Reading /proc/cpuinfo failed, err = %d\n", -n);
 			if(n < 0)
-				return(n);
-			else
-				return(-EIO);
+				return n;
+			else return -EIO;
 		}
 	} while((c != '\n') && (c != stop) && (ptr < end));
 
 	if(ptr == end){
 		printk("Failed to find '%c' in /proc/cpuinfo\n", stop);
-		return(-1);
+		return -1;
 	}
 	*(ptr - 1) = '\0';
-	return(c);
+	return c;
 }
 
 static int find_cpuinfo_line(int fd, char *key, char *scratch, int len)
@@ -67,33 +67,23 @@ static int find_cpuinfo_line(int fd, cha
 	while(1){
 		c = token(fd, scratch, len - 1, ':');
 		if(c <= 0)
-			return(0);
+			return 0;
 		else if(c != ':'){
 			printk("Failed to find ':' in /proc/cpuinfo\n");
-			return(0);
+			return 0;
 		}
 
 		if(!strncmp(scratch, key, strlen(key)))
-			return(1);
+			return 1;
 
 		do {
 			n = os_read_file(fd, &c, sizeof(c));
 			if(n != sizeof(c)){
 				printk("Failed to find newline in "
 				       "/proc/cpuinfo, err = %d\n", -n);
-				return(0);
+				return 0;
 			}
 		} while(c != '\n');
 	}
-	return(0);
+	return 0;
 }
-
-/* Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */

