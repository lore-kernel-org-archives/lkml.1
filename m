Return-Path: <linux-kernel-owner+w=401wt.eu-S932711AbXBEOP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932711AbXBEOP2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:15:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932789AbXBEOP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:15:28 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45692 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932711AbXBEOP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:15:26 -0500
Subject: [DLM] rename dlm_config_info fields [18/54]
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Teigland <teigland@redhat.com>, cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:23:26 +0000
Message-Id: <1170685406.11001.306.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 96eb818411ad5df07e221d854a55e833c92bc0d0 Mon Sep 17 00:00:00 2001
From: David Teigland <teigland@redhat.com>
Date: Tue, 9 Jan 2007 09:41:48 -0600
Subject: [PATCH] [DLM] rename dlm_config_info fields

Add a "ci_" prefix to the fields in the dlm_config_info struct so that we
can use macros to add configfs functions to access them (in a later
patch).  No functional changes in this patch, just naming changes.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/config.c b/fs/dlm/config.c
index 8855305..958021f 100644
--- a/fs/dlm/config.c
+++ b/fs/dlm/config.c
@@ -777,13 +777,13 @@ int dlm_our_addr(struct sockaddr_storage *addr, int num)
 #define DEFAULT_SCAN_SECS          5
 
 struct dlm_config_info dlm_config = {
-	.tcp_port = DEFAULT_TCP_PORT,
-	.buffer_size = DEFAULT_BUFFER_SIZE,
-	.rsbtbl_size = DEFAULT_RSBTBL_SIZE,
-	.lkbtbl_size = DEFAULT_LKBTBL_SIZE,
-	.dirtbl_size = DEFAULT_DIRTBL_SIZE,
-	.recover_timer = DEFAULT_RECOVER_TIMER,
-	.toss_secs = DEFAULT_TOSS_SECS,
-	.scan_secs = DEFAULT_SCAN_SECS
+	.ci_tcp_port = DEFAULT_TCP_PORT,
+	.ci_buffer_size = DEFAULT_BUFFER_SIZE,
+	.ci_rsbtbl_size = DEFAULT_RSBTBL_SIZE,
+	.ci_lkbtbl_size = DEFAULT_LKBTBL_SIZE,
+	.ci_dirtbl_size = DEFAULT_DIRTBL_SIZE,
+	.ci_recover_timer = DEFAULT_RECOVER_TIMER,
+	.ci_toss_secs = DEFAULT_TOSS_SECS,
+	.ci_scan_secs = DEFAULT_SCAN_SECS
 };
 
diff --git a/fs/dlm/config.h b/fs/dlm/config.h
index 9da7839..ce603e1 100644
--- a/fs/dlm/config.h
+++ b/fs/dlm/config.h
@@ -17,14 +17,14 @@
 #define DLM_MAX_ADDR_COUNT 3
 
 struct dlm_config_info {
-	int tcp_port;
-	int buffer_size;
-	int rsbtbl_size;
-	int lkbtbl_size;
-	int dirtbl_size;
-	int recover_timer;
-	int toss_secs;
-	int scan_secs;
+	int ci_tcp_port;
+	int ci_buffer_size;
+	int ci_rsbtbl_size;
+	int ci_lkbtbl_size;
+	int ci_dirtbl_size;
+	int ci_recover_timer;
+	int ci_toss_secs;
+	int ci_scan_secs;
 };
 
 extern struct dlm_config_info dlm_config;
diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index ed52485..5bac982 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -810,7 +810,7 @@ static int shrink_bucket(struct dlm_ls *ls, int b)
 		list_for_each_entry_reverse(r, &ls->ls_rsbtbl[b].toss,
 					    res_hashchain) {
 			if (!time_after_eq(jiffies, r->res_toss_time +
-					   dlm_config.toss_secs * HZ))
+					   dlm_config.ci_toss_secs * HZ))
 				continue;
 			found = 1;
 			break;
diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index 59012b0..f40817b 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -236,7 +236,7 @@ static int dlm_scand(void *data)
 	while (!kthread_should_stop()) {
 		list_for_each_entry(ls, &lslist, ls_list)
 			dlm_scan_rsbs(ls);
-		schedule_timeout_interruptible(dlm_config.scan_secs * HZ);
+		schedule_timeout_interruptible(dlm_config.ci_scan_secs * HZ);
 	}
 	return 0;
 }
@@ -422,7 +422,7 @@ static int new_lockspace(char *name, int namelen, void **lockspace,
 	ls->ls_count = 0;
 	ls->ls_flags = 0;
 
-	size = dlm_config.rsbtbl_size;
+	size = dlm_config.ci_rsbtbl_size;
 	ls->ls_rsbtbl_size = size;
 
 	ls->ls_rsbtbl = kmalloc(sizeof(struct dlm_rsbtable) * size, GFP_KERNEL);
@@ -434,7 +434,7 @@ static int new_lockspace(char *name, int namelen, void **lockspace,
 		rwlock_init(&ls->ls_rsbtbl[i].lock);
 	}
 
-	size = dlm_config.lkbtbl_size;
+	size = dlm_config.ci_lkbtbl_size;
 	ls->ls_lkbtbl_size = size;
 
 	ls->ls_lkbtbl = kmalloc(sizeof(struct dlm_lkbtable) * size, GFP_KERNEL);
@@ -446,7 +446,7 @@ static int new_lockspace(char *name, int namelen, void **lockspace,
 		ls->ls_lkbtbl[i].counter = 1;
 	}
 
-	size = dlm_config.dirtbl_size;
+	size = dlm_config.ci_dirtbl_size;
 	ls->ls_dirtbl_size = size;
 
 	ls->ls_dirtbl = kmalloc(sizeof(struct dlm_dirtable) * size, GFP_KERNEL);
@@ -489,7 +489,7 @@ static int new_lockspace(char *name, int namelen, void **lockspace,
 	mutex_init(&ls->ls_requestqueue_mutex);
 	mutex_init(&ls->ls_clear_proc_locks);
 
-	ls->ls_recover_buf = kmalloc(dlm_config.buffer_size, GFP_KERNEL);
+	ls->ls_recover_buf = kmalloc(dlm_config.ci_buffer_size, GFP_KERNEL);
 	if (!ls->ls_recover_buf)
 		goto out_dirfree;
 
diff --git a/fs/dlm/lowcomms-sctp.c b/fs/dlm/lowcomms-sctp.c
index 0940a80..5aeadad 100644
--- a/fs/dlm/lowcomms-sctp.c
+++ b/fs/dlm/lowcomms-sctp.c
@@ -635,7 +635,7 @@ static int add_bind_addr(struct sockaddr_storage *addr, int addr_len, int num)
 
 	if (result < 0)
 		log_print("Can't bind to port %d addr number %d",
-			  dlm_config.tcp_port, num);
+			  dlm_config.ci_tcp_port, num);
 
 	return result;
 }
@@ -711,7 +711,7 @@ static int init_sock(void)
 	/* Bind to all interfaces. */
 	for (i = 0; i < dlm_local_count; i++) {
 		memcpy(&localaddr, dlm_local_addr[i], sizeof(localaddr));
-		make_sockaddr(&localaddr, dlm_config.tcp_port, &addr_len);
+		make_sockaddr(&localaddr, dlm_config.ci_tcp_port, &addr_len);
 
 		result = add_bind_addr(&localaddr, addr_len, num);
 		if (result)
@@ -863,7 +863,7 @@ static void initiate_association(int nodeid)
 		return;
 	}
 
-	make_sockaddr(&rem_addr, dlm_config.tcp_port, &addrlen);
+	make_sockaddr(&rem_addr, dlm_config.ci_tcp_port, &addrlen);
 
 	outmessage.msg_name = &rem_addr;
 	outmessage.msg_namelen = addrlen;
diff --git a/fs/dlm/lowcomms-tcp.c b/fs/dlm/lowcomms-tcp.c
index ce5e7cd..b4fb578 100644
--- a/fs/dlm/lowcomms-tcp.c
+++ b/fs/dlm/lowcomms-tcp.c
@@ -548,7 +548,7 @@ static void connect_to_sock(struct connection *con)
 	sock->sk->sk_user_data = con;
 	con->rx_action = receive_from_sock;
 
-	make_sockaddr(&saddr, dlm_config.tcp_port, &addr_len);
+	make_sockaddr(&saddr, dlm_config.ci_tcp_port, &addr_len);
 
 	add_sock(sock, con);
 
@@ -616,10 +616,10 @@ static struct socket *create_listen_sock(struct connection *con,
 	con->sock = sock;
 
 	/* Bind to our port */
-	make_sockaddr(saddr, dlm_config.tcp_port, &addr_len);
+	make_sockaddr(saddr, dlm_config.ci_tcp_port, &addr_len);
 	result = sock->ops->bind(sock, (struct sockaddr *) saddr, addr_len);
 	if (result < 0) {
-		printk("dlm: Can't bind to port %d\n", dlm_config.tcp_port);
+		printk("dlm: Can't bind to port %d\n", dlm_config.ci_tcp_port);
 		sock_release(sock);
 		sock = NULL;
 		con->sock = NULL;
@@ -638,7 +638,8 @@ static struct socket *create_listen_sock(struct connection *con,
 
 	result = sock->ops->listen(sock, 5);
 	if (result < 0) {
-		printk("dlm: Can't listen on port %d\n", dlm_config.tcp_port);
+		printk("dlm: Can't listen on port %d\n",
+		       dlm_config.ci_tcp_port);
 		sock_release(sock);
 		sock = NULL;
 		goto create_out;
diff --git a/fs/dlm/midcomms.c b/fs/dlm/midcomms.c
index c9b1c3d..a5126e0 100644
--- a/fs/dlm/midcomms.c
+++ b/fs/dlm/midcomms.c
@@ -82,7 +82,7 @@ int dlm_process_incoming_buffer(int nodeid, const void *base,
 		if (msglen < sizeof(struct dlm_header))
 			break;
 		err = -E2BIG;
-		if (msglen > dlm_config.buffer_size) {
+		if (msglen > dlm_config.ci_buffer_size) {
 			log_print("message size %d from %d too big, buf len %d",
 				  msglen, nodeid, len);
 			break;
@@ -103,7 +103,7 @@ int dlm_process_incoming_buffer(int nodeid, const void *base,
 
 		if (msglen > sizeof(__tmp) &&
 		    msg == (struct dlm_header *) __tmp) {
-			msg = kmalloc(dlm_config.buffer_size, GFP_KERNEL);
+			msg = kmalloc(dlm_config.ci_buffer_size, GFP_KERNEL);
 			if (msg == NULL)
 				return ret;
 		}
diff --git a/fs/dlm/rcom.c b/fs/dlm/rcom.c
index 2e246af..6bfbd61 100644
--- a/fs/dlm/rcom.c
+++ b/fs/dlm/rcom.c
@@ -138,7 +138,7 @@ int dlm_rcom_status(struct dlm_ls *ls, int nodeid)
 		goto out;
 
 	allow_sync_reply(ls, &rc->rc_id);
-	memset(ls->ls_recover_buf, 0, dlm_config.buffer_size);
+	memset(ls->ls_recover_buf, 0, dlm_config.ci_buffer_size);
 
 	send_rcom(ls, mh, rc);
 
@@ -213,7 +213,7 @@ int dlm_rcom_names(struct dlm_ls *ls, int nodeid, char *last_name, int last_len)
 	if (nodeid == dlm_our_nodeid()) {
 		dlm_copy_master_names(ls, last_name, last_len,
 		                      ls->ls_recover_buf + len,
-		                      dlm_config.buffer_size - len, nodeid);
+		                      dlm_config.ci_buffer_size - len, nodeid);
 		goto out;
 	}
 
@@ -223,7 +223,7 @@ int dlm_rcom_names(struct dlm_ls *ls, int nodeid, char *last_name, int last_len)
 	memcpy(rc->rc_buf, last_name, last_len);
 
 	allow_sync_reply(ls, &rc->rc_id);
-	memset(ls->ls_recover_buf, 0, dlm_config.buffer_size);
+	memset(ls->ls_recover_buf, 0, dlm_config.ci_buffer_size);
 
 	send_rcom(ls, mh, rc);
 
@@ -241,7 +241,7 @@ static void receive_rcom_names(struct dlm_ls *ls, struct dlm_rcom *rc_in)
 
 	nodeid = rc_in->rc_header.h_nodeid;
 	inlen = rc_in->rc_header.h_length - sizeof(struct dlm_rcom);
-	outlen = dlm_config.buffer_size - sizeof(struct dlm_rcom);
+	outlen = dlm_config.ci_buffer_size - sizeof(struct dlm_rcom);
 
 	error = create_rcom(ls, nodeid, DLM_RCOM_NAMES_REPLY, outlen, &rc, &mh);
 	if (error)
diff --git a/fs/dlm/recover.c b/fs/dlm/recover.c
index cf9f683..a7fa4cb 100644
--- a/fs/dlm/recover.c
+++ b/fs/dlm/recover.c
@@ -44,7 +44,7 @@
 static void dlm_wait_timer_fn(unsigned long data)
 {
 	struct dlm_ls *ls = (struct dlm_ls *) data;
-	mod_timer(&ls->ls_timer, jiffies + (dlm_config.recover_timer * HZ));
+	mod_timer(&ls->ls_timer, jiffies + (dlm_config.ci_recover_timer * HZ));
 	wake_up(&ls->ls_wait_general);
 }
 
@@ -55,7 +55,7 @@ int dlm_wait_function(struct dlm_ls *ls, int (*testfn) (struct dlm_ls *ls))
 	init_timer(&ls->ls_timer);
 	ls->ls_timer.function = dlm_wait_timer_fn;
 	ls->ls_timer.data = (long) ls;
-	ls->ls_timer.expires = jiffies + (dlm_config.recover_timer * HZ);
+	ls->ls_timer.expires = jiffies + (dlm_config.ci_recover_timer * HZ);
 	add_timer(&ls->ls_timer);
 
 	wait_event(ls->ls_wait_general, testfn(ls) || dlm_recovery_stopped(ls));
-- 
1.4.4.2



