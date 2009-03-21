Return-Path: <linux-kernel-owner+w=401wt.eu-S1757312AbZCULly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312AbZCULly (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 07:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbZCULlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 07:41:44 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:53379 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890AbZCULln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 07:41:43 -0400
Date: Sat, 21 Mar 2009 12:41:39 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Sam Ravnborg <sam@ravnborg.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] trace/ring_buffer: fix section mismatch warning
Message-ID: <20090321124139.4ca216d9@osiris.boeblingen.de.ibm.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

With linux-next I get this:

Section mismatch in reference from the function ring_buffer_alloc() to the function .cpuinit.text:rb_cpu_notify()
The function ring_buffer_alloc() references
the function __cpuinit rb_cpu_notify().
This is often because ring_buffer_alloc lacks a __cpuinit 
annotation or the annotation of rb_cpu_notify is wrong.

This is a false positive since rb_cpu_notify gets only referenced if
CONFIG_HOTPLUG_CPU=y.
To get rid of the warning annotate ring_buffer_alloc with __ref.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 kernel/trace/ring_buffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-next/kernel/trace/ring_buffer.c
===================================================================
--- linux-next.orig/kernel/trace/ring_buffer.c
+++ linux-next/kernel/trace/ring_buffer.c
@@ -549,7 +549,7 @@ static int __cpuinit rb_cpu_notify(struc
  * when the buffer wraps. If this flag is not set, the buffer will
  * drop data when the tail hits the head.
  */
-struct ring_buffer *ring_buffer_alloc(unsigned long size, unsigned flags)
+struct ring_buffer * __ref ring_buffer_alloc(unsigned long size, unsigned flags)
 {
 	struct ring_buffer *buffer;
 	int bsize;
