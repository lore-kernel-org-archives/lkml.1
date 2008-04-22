Return-Path: <linux-kernel-owner+w=401wt.eu-S932353AbYDVJ6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353AbYDVJ6U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 05:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758065AbYDVJ6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 05:58:07 -0400
Received: from wx-out-0506.google.com ([66.249.82.230]:15443 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992AbYDVJ6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 05:58:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding;
        b=eIsgyY4xK5tP455oQm3zAEQrRti1jxmHfxJsi2MxvFvB5p3POyD4pH5mjrGeNG9gOlV+dc6JbIwmlPsbd47zZ9ZGBDRMsFDXUXe7uzGEov278CN1dZ+npYBpQ+WpS1k7MG3Q3ChZTiZiyE2wSpVI3KzR3ScT9vhi+M2EwPPkvbU=
Message-ID: <480DB6A4.20101@gmail.com>
Date: Tue, 22 Apr 2008 18:57:56 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       oliver@neukum.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       zaitcev@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
Subject: [PATCH 1/2] klist: implement KLIST_INIT() and DEFINE_KLIST()
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

klist is missing static initializers and definition helper.  Add them.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
I can't tell who's in charge of this code, so I'm including last two
people who made changes and Andrew :-) This will be used by later USB
mode switch support, so I'm cc'ing USB people too.

Thanks.

 include/linux/klist.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/linux/klist.h b/include/linux/klist.h
index 7407125..c6b697c 100644
--- a/include/linux/klist.h
+++ b/include/linux/klist.h
@@ -25,6 +25,14 @@ struct klist {
 	void			(*put)(struct klist_node *);
 };
 
+#define KLIST_INIT(_name, _get, _put)					\
+	{ .k_lock	= __SPIN_LOCK_UNLOCKED(klist.k_lock),		\
+	  .k_list	= LIST_HEAD_INIT(_name.k_list),			\
+	  .get		= _get,						\
+	  .put		= _put, }
+
+#define DEFINE_KLIST(_name, _get, _put)					\
+	struct klist _name = KLIST_INIT(_name, _get, _put)
 
 extern void klist_init(struct klist * k, void (*get)(struct klist_node *),
 		       void (*put)(struct klist_node *));
-- 
1.5.2.4

