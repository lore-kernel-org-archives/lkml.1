Return-Path: <linux-kernel-owner+w=401wt.eu-S1757427AbZBZPvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427AbZBZPvq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 10:51:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756512AbZBZPvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 10:51:35 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:10037 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756450AbZBZPve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 10:51:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=gixg/2aDp0H3wvCBtCEgXEjnXEYf8HT84bVPzgrRc3NkF2+lFnEdzuH7SbJ4jl+Th+
         0y4oJoUVJuVtqE/N6OvCCJR4WR8fGgcmMl4ETi2Bv834H9A1WwF8egTT8+hgD/wU/hcE
         8Zp0JaFad4RGxC9YGoTnhZkfGRTkJsjXmfRvg=
MIME-Version: 1.0
Reply-To: petkovbb@gmail.com
In-Reply-To: <200902261529.43554.bzolnier@gmail.com>
References: <200902260229.n1Q2T2lY006773@www262.sakura.ne.jp>
	 <200902261529.43554.bzolnier@gmail.com>
Date: Thu, 26 Feb 2009 16:51:30 +0100
Message-ID: <9ea470500902260751t4221d04cm839765a93300d861@mail.gmail.com>
Subject: Re: linux-next-20090225: ide-cd triggers BUG at arch/x86/mm/ioremap.c:80!
From: Borislav Petkov <petkovbb@googlemail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Feb 26, 2009 at 3:29 PM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
> On Thursday 26 February 2009, Tetsuo Handa wrote:
>> 2.6.29-rc6 is OK.
>
> Could you try to narrow down the issue by bisecting linux-next?

Can you also apply the following patch and send us the output?

Thanks.

--
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 9e19aec..fca6e64 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -918,6 +918,12 @@ static ide_startstop_t
ide_cd_do_request(ide_drive_t *drive, struct request *rq,

 	ide_init_sg_cmd(&cmd,
 		blk_fs_request(rq) ? (rq->nr_sectors << 9) : rq->data_len);
+
+	blk_dump_rq_flags(rq, "mapping rq to sg");
+
+	if ((unsigned long)rq->data < PAGE_OFFSET)
+		dump_stack();
+
 	ide_map_sg(drive, &cmd);

 	return ide_issue_pc(drive, &cmd);

-- 
Regards/Gruss,
Boris
