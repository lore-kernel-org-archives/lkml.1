Return-Path: <linux-kernel-owner+w=401wt.eu-S1758023AbZLFXio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758023AbZLFXio (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 18:38:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757851AbZLFXim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 18:38:42 -0500
Received: from kroah.org ([198.145.64.141]:33774 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757899AbZLFXij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 18:38:39 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 15:32:08 2009
Message-Id: <20091206233208.580098254@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 15:30:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dave Jones <davej@redhat.com>,
       James Bottomley <James.Bottomley@suse.de>
Subject: [04/20] [SCSI] gdth: Prevent negative offsets in ioctl CVE-2009-3080
References: <20091206233032.387950574@mini.kroah.org>
Content-Disposition: inline; filename=gdth-prevent-negative-offsets-in-ioctl-cve-2009-3080.patch
In-Reply-To: <20091206233711.GA11609@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Dave Jones <davej@redhat.com>

commit 690e744869f3262855b83b4fb59199cf142765b0 upstream.

A negative offset could be used to index before the event buffer and
lead to a security breach.

Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/gdth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -2912,7 +2912,7 @@ static int gdth_read_event(gdth_ha_str *
         eindex = handle;
     estr->event_source = 0;
 
-    if (eindex >= MAX_EVENTS) {
+    if (eindex < 0 || eindex >= MAX_EVENTS) {
         spin_unlock_irqrestore(&ha->smp_lock, flags);
         return eindex;
     }


