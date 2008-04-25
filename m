Return-Path: <linux-kernel-owner+w=401wt.eu-S1765573AbYDYSQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765573AbYDYSQc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 14:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759757AbYDYSQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 14:16:23 -0400
Received: from rn-out-0910.google.com ([64.233.170.184]:38494 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758212AbYDYSQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 14:16:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Th1NVoj5Zso2gVbuQCsPC72Hp7cSTB5uZq/nSayHN5b8RbjebgYg5acSO9yNf4fFU5uAyU+Gfzi9W+k65dm4HdZOoy7H8js/rNftO/eNh1HzT8Fwj1zwLsC+6oBgKiAndl/mI908o2TapBGottLnpTuGlJ7mNp/PAu9EqhikSLc=
Message-ID: <48121FE4.5010803@gmail.com>
Date: Sat, 26 Apr 2008 03:16:04 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Peter Zijlstra <peterz@infradead.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, oliver@neukum.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, zaitcev@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
Subject: [PATCH 1/2 UPDATED] klist: implement KLIST_INIT() and DEFINE_KLIST()
References: <480DB6A4.20101@gmail.com> <1208869049.7115.254.camel@twins> <480DE215.2070803@gmail.com> <1208869591.7115.263.camel@twins> <480DE3B3.6050702@gmail.com> <20080425163736.GC10397@kroah.com>
In-Reply-To: <20080425163736.GC10397@kroah.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

klist is missing static initializers and definition helper.  Add them.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
Updated to use _name.k_lock as advised.

Thanks.

 include/linux/klist.h |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: work/include/linux/klist.h
===================================================================
--- work.orig/include/linux/klist.h
+++ work/include/linux/klist.h
@@ -25,6 +25,14 @@ struct klist {
 	void			(*put)(struct klist_node *);
 };
 
+#define KLIST_INIT(_name, _get, _put)					\
+	{ .k_lock	= __SPIN_LOCK_UNLOCKED(_name.k_lock),		\
+	  .k_list	= LIST_HEAD_INIT(_name.k_list),			\
+	  .get		= _get,						\
+	  .put		= _put, }
+
+#define DEFINE_KLIST(_name, _get, _put)					\
+	struct klist _name = KLIST_INIT(_name, _get, _put)
 
 extern void klist_init(struct klist * k, void (*get)(struct klist_node *),
 		       void (*put)(struct klist_node *));
