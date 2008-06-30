Return-Path: <linux-kernel-owner+w=401wt.eu-S1762180AbYF3SBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762180AbYF3SBK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 14:01:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752031AbYF3SA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 14:00:57 -0400
Received: from gv-out-0910.google.com ([216.239.58.187]:6165 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbYF3SA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 14:00:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=OezoFmHy2U1WVkDNqWvVyv/Ky86S0e0xoIUkAJ6toimgVWxTeqh1KRYhRNhhK9qjQn
         bzGxJ5JZcQlLGU9EM2QmY5tOh75VlhgUxNj13ghzgXX6ETj+wgv5OA8+1BDt8YbC79qL
         XvWFpeZuq3Da7GEWmeMhDekQH8Nm9rA2HqCXU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide: fix /proc/ide/ide?/mate reporting
Date: Mon, 30 Jun 2008 20:02:45 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806302002.46667.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we support warm-plug mate port will be registered
even if there are no devices attached to it.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ide/ide-proc.c
===================================================================
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -76,7 +76,7 @@ static int proc_ide_read_mate
 	ide_hwif_t	*hwif = (ide_hwif_t *) data;
 	int		len;
 
-	if (hwif && hwif->mate && hwif->mate->present)
+	if (hwif && hwif->mate)
 		len = sprintf(page, "%s\n", hwif->mate->name);
 	else
 		len = sprintf(page, "(none)\n");
