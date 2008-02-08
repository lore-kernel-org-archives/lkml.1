Return-Path: <linux-kernel-owner+w=401wt.eu-S932716AbYBHG3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932716AbYBHG3a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 01:29:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbYBHG3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 01:29:21 -0500
Received: from fk-out-0910.google.com ([209.85.128.190]:49287 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbYBHG3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 01:29:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:mime-version:content-type:content-disposition:content-transfer-encoding:user-agent:from;
        b=NoFfKZ6f1fYgFIJYBb5yqXU9Svp3hTalBzE2z4TRskkdrJ+bwTZwvFf/mlxXpuBjRdgb2XmNbN7uwKbFvxxlzsdWvHKa0EkMa5p6ERTf0xl1RoXjHzsd7nrNgS1rXCxKADPII2AH/PqIRtUvz1BBAwADOv8DjdL8tgoaZpCYMxQ=
Date: Fri, 8 Feb 2008 07:29:03 +0100
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ide-cd: replace ntohs with generic byteorder macro
	be16_to_cpu
Message-ID: <20080208062903.GA20018@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, bzolnier@gmail.com,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit d41c6bc739e7ea7880f7f5983a9694f2e0214d92
Author: Borislav Petkov <petkovbb@gmail.com>
Date:   Fri Feb 8 07:25:44 2008 +0100

    ide-cd: replace ntohs with generic byteorder macro be16_to_cpu
    
    Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 5e42c19..354c91d 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1555,7 +1555,7 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 	if (stat)
 		return stat;
 
-	toc->hdr.toc_length = ntohs (toc->hdr.toc_length);
+	toc->hdr.toc_length = be16_to_cpu(toc->hdr.toc_length);
 
 	if (info->cd_flags & IDE_CD_FLAG_TOCTRACKS_AS_BCD) {
 		toc->hdr.first_track = BCD2BIN(toc->hdr.first_track);
-- 
Regards/Gruﬂ,
    Boris.
