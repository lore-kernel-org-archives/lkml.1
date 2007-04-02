Return-Path: <linux-kernel-owner+w=401wt.eu-S965407AbXDBNYE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965407AbXDBNYE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 09:24:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965425AbXDBNYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 09:24:04 -0400
Received: from mx1.suse.de ([195.135.220.2]:57300 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965419AbXDBNYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 09:24:03 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: CPU ordering with respect to krefs
Date: Mon, 2 Apr 2007 14:47:59 +0200
User-Agent: KMail/1.9.1
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704021447.59476.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

some atomic operations are only atomic, not ordered. Thus a CPU is allowed
to reorder memory references to an object to before the reference is
obtained. This fixes it.

	Regards
		Oliver
Signed-off-by: Oliver Neukum <oneukum@suse.de>
------

--- a/lib/kref.c	2007-04-02 14:40:40.000000000 +0200
+++ b/lib/kref.c	2007-04-02 14:40:50.000000000 +0200
@@ -21,6 +21,7 @@
 void kref_init(struct kref *kref)
 {
 	atomic_set(&kref->refcount,1);
+	smp_mb();
 }
 
 /**
@@ -31,6 +32,7 @@
 {
 	WARN_ON(!atomic_read(&kref->refcount));
 	atomic_inc(&kref->refcount);
+	smp_mb__after_atomic_inc();
 }
 
 /**
