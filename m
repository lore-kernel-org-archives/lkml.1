Return-Path: <linux-kernel-owner+w=401wt.eu-S1761550AbXEOERb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761550AbXEOERb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 00:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755858AbXEOERF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 00:17:05 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:34862 "EHLO
	asav10.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304AbXEOERD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 00:17:03 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvVoANzQSEZKhRO4W2dsb2JhbACBXIVUiEYdEhEB
Message-Id: <20070515041356.857196030.dtor@insightbb.com>
References: <20070515041249.301642231.dtor@insightbb.com>
Date: Tue, 15 May 2007 00:12:51 -0400
From: Dmitry Torokhov <dtor@insightbb.com>
To: Vernon Mauery <vernux@us.ibm.com>, Max Asbock <masbock@us.ibm.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: [patch 2/4] IBMASM: dont use extern in function declarations
Content-Disposition: inline; filename=ibmasm-dont-use-extern-in-headers.patch
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

IBMASM: don't use extern in function declarations

We normally don't use extern in function declarations located in header files.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/misc/ibmasm/ibmasm.h |   64 +++++++++++++++++++++----------------------
 1 files changed, 32 insertions(+), 32 deletions(-)

Index: work/drivers/misc/ibmasm/ibmasm.h
===================================================================
--- work.orig/drivers/misc/ibmasm/ibmasm.h
+++ work/drivers/misc/ibmasm/ibmasm.h
@@ -163,55 +163,55 @@ struct service_processor {
 };
 
 /* command processing */
-extern struct command *ibmasm_new_command(struct service_processor *sp, size_t buffer_size);
-extern void ibmasm_exec_command(struct service_processor *sp, struct command *cmd);
-extern void ibmasm_wait_for_response(struct command *cmd, int timeout);
-extern void ibmasm_receive_command_response(struct service_processor *sp, void *response,  size_t size);
+struct command *ibmasm_new_command(struct service_processor *sp, size_t buffer_size);
+void ibmasm_exec_command(struct service_processor *sp, struct command *cmd);
+void ibmasm_wait_for_response(struct command *cmd, int timeout);
+void ibmasm_receive_command_response(struct service_processor *sp, void *response,  size_t size);
 
 /* event processing */
-extern int ibmasm_event_buffer_init(struct service_processor *sp);
-extern void ibmasm_event_buffer_exit(struct service_processor *sp);
-extern void ibmasm_receive_event(struct service_processor *sp, void *data,  unsigned int data_size);
-extern void ibmasm_event_reader_register(struct service_processor *sp, struct event_reader *reader);
-extern void ibmasm_event_reader_unregister(struct service_processor *sp, struct event_reader *reader);
-extern int ibmasm_get_next_event(struct service_processor *sp, struct event_reader *reader);
-extern void ibmasm_cancel_next_event(struct event_reader *reader);
+int ibmasm_event_buffer_init(struct service_processor *sp);
+void ibmasm_event_buffer_exit(struct service_processor *sp);
+void ibmasm_receive_event(struct service_processor *sp, void *data,  unsigned int data_size);
+void ibmasm_event_reader_register(struct service_processor *sp, struct event_reader *reader);
+void ibmasm_event_reader_unregister(struct service_processor *sp, struct event_reader *reader);
+int ibmasm_get_next_event(struct service_processor *sp, struct event_reader *reader);
+void ibmasm_cancel_next_event(struct event_reader *reader);
 
 /* heartbeat - from SP to OS */
-extern void ibmasm_register_panic_notifier(void);
-extern void ibmasm_unregister_panic_notifier(void);
-extern int ibmasm_heartbeat_init(struct service_processor *sp);
-extern void ibmasm_heartbeat_exit(struct service_processor *sp);
-extern void ibmasm_receive_heartbeat(struct service_processor *sp,  void *message, size_t size);
+void ibmasm_register_panic_notifier(void);
+void ibmasm_unregister_panic_notifier(void);
+int ibmasm_heartbeat_init(struct service_processor *sp);
+void ibmasm_heartbeat_exit(struct service_processor *sp);
+void ibmasm_receive_heartbeat(struct service_processor *sp,  void *message, size_t size);
 
 /* reverse heartbeat - from OS to SP */
-extern void ibmasm_init_reverse_heartbeat(struct service_processor *sp, struct reverse_heartbeat *rhb);
-extern int ibmasm_start_reverse_heartbeat(struct service_processor *sp, struct reverse_heartbeat *rhb);
-extern void ibmasm_stop_reverse_heartbeat(struct reverse_heartbeat *rhb);
+void ibmasm_init_reverse_heartbeat(struct service_processor *sp, struct reverse_heartbeat *rhb);
+int ibmasm_start_reverse_heartbeat(struct service_processor *sp, struct reverse_heartbeat *rhb);
+void ibmasm_stop_reverse_heartbeat(struct reverse_heartbeat *rhb);
 
 /* dot commands */
-extern void ibmasm_receive_message(struct service_processor *sp, void *data, int data_size);
-extern int ibmasm_send_driver_vpd(struct service_processor *sp);
-extern int ibmasm_send_os_state(struct service_processor *sp, int os_state);
+void ibmasm_receive_message(struct service_processor *sp, void *data, int data_size);
+int ibmasm_send_driver_vpd(struct service_processor *sp);
+int ibmasm_send_os_state(struct service_processor *sp, int os_state);
 
 /* low level message processing */
-extern int ibmasm_send_i2o_message(struct service_processor *sp);
-extern irqreturn_t ibmasm_interrupt_handler(int irq, void * dev_id);
+int ibmasm_send_i2o_message(struct service_processor *sp);
+irqreturn_t ibmasm_interrupt_handler(int irq, void * dev_id);
 
 /* remote console */
-extern void ibmasm_handle_mouse_interrupt(struct service_processor *sp);
-extern int ibmasm_init_remote_input_dev(struct service_processor *sp);
-extern void ibmasm_free_remote_input_dev(struct service_processor *sp);
+void ibmasm_handle_mouse_interrupt(struct service_processor *sp);
+int ibmasm_init_remote_input_dev(struct service_processor *sp);
+void ibmasm_free_remote_input_dev(struct service_processor *sp);
 
 /* file system */
-extern int ibmasmfs_register(void);
-extern void ibmasmfs_unregister(void);
-extern void ibmasmfs_add_sp(struct service_processor *sp);
+int ibmasmfs_register(void);
+void ibmasmfs_unregister(void);
+void ibmasmfs_add_sp(struct service_processor *sp);
 
 /* uart */
 #ifdef CONFIG_SERIAL_8250
-extern void ibmasm_register_uart(struct service_processor *sp);
-extern void ibmasm_unregister_uart(struct service_processor *sp);
+void ibmasm_register_uart(struct service_processor *sp);
+void ibmasm_unregister_uart(struct service_processor *sp);
 #else
 #define ibmasm_register_uart(sp)	do { } while(0)
 #define ibmasm_unregister_uart(sp)	do { } while(0)
