Return-Path: <linux-kernel-owner+w=401wt.eu-S1757712AbZIPWct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757712AbZIPWct (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757696AbZIPWc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:32:29 -0400
Received: from kroah.org ([198.145.64.141]:40906 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757040AbZIPWc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:32:27 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Sep 16 15:29:01 2009
Message-Id: <20090916222900.956520721@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Sep 2009 15:28:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Michal Schmidt <mschmidt@redhat.com>,
       Douglas Gilbert <dgilbert@interlog.com>,
       James Bottomley <James.Bottomley@suse.de>
Subject: [patch 02/24] [SCSI] sg: fix oops in the error path in sg_build_indirect()
References: <20090916222819.244332644@mini.kroah.org>
Content-Disposition: inline; filename=sg-fix-oops-in-the-error-path-in-sg_build_indirect.patch
In-Reply-To: <20090916222934.GA31846@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Michal Schmidt <mschmidt@redhat.com>

commit e71044ee2efa4792e21d243b03d49006db66aec9 upstream.

When the allocation fails in sg_build_indirect(), an oops happens in
the error path. It's caused by an obvious typo.

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Reported-by: Bob Tracy <rct@gherkin.frus.com>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/sg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1811,7 +1811,7 @@ retry:
 	return 0;
 out:
 	for (i = 0; i < k; i++)
-		__free_pages(schp->pages[k], order);
+		__free_pages(schp->pages[i], order);
 
 	if (--order >= 0)
 		goto retry;


