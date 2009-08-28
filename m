Return-Path: <linux-kernel-owner+w=401wt.eu-S1753096AbZH1UAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096AbZH1UAu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 16:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbZH1UAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 16:00:49 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:62441 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122AbZH1UAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 16:00:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=V21xgc91WyEX3+ryYm4+M26Sus+KW87H7o2pD6RBZGi7HQljJt6pjzKgTdKaQnc0Y6
         6Km0WTNovz2pMDiDzpBr9hO5XBuzaMJ9otwvVvscihGDi2/MAWkX7weIFR/JSdG82yU1
         6i0tApjogv02nbrfFXzTPt1m03P2pf7KvoCD4=
Date: Sat, 29 Aug 2009 00:00:47 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: steiner@sgi.com, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] gru: use proc_create()
Message-ID: <20090828200047.GF15123@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/misc/sgi-gru/gruprocfs.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/misc/sgi-gru/gruprocfs.c
+++ b/drivers/misc/sgi-gru/gruprocfs.c
@@ -340,10 +340,9 @@ static struct proc_dir_entry *proc_gru __read_mostly;
 
 static int create_proc_file(struct proc_entry *p)
 {
-	p->entry = create_proc_entry(p->name, p->mode, proc_gru);
+	p->entry = proc_create(p->name, p->mode, proc_gru, p->fops);
 	if (!p->entry)
 		return -1;
-	p->entry->proc_fops = p->fops;
 	return 0;
 }
 
