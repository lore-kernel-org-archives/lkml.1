Return-Path: <linux-kernel-owner+w=401wt.eu-S1756067AbZA0QsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067AbZA0QsH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 11:48:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbZA0Qrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 11:47:51 -0500
Received: from rn-out-0910.google.com ([64.233.170.186]:25580 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbZA0Qru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 11:47:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=XPsjVbVtk+6qg+cmZfBdWuG4FjzhYB1/TvaRPslLm8vSV82/knoOjbcgBzXCelbuSW
         rGjK9/GQH/oefBS7SgrTSz7Y8nKYtGeK2FgJxwXLnEl3yWJfhC0gkYweOeyTdPcehy7B
         lMGP5PU+98P8/Uh71Av4Yns8TLne1xK4aoS54=
MIME-Version: 1.0
Reply-To: petkovbb@gmail.com
In-Reply-To: <200901271607.10869.bzolnier@gmail.com>
References: <1233002440-4325-1-git-send-email-petkovbb@gmail.com>
	 <200901271607.10869.bzolnier@gmail.com>
Date: Tue, 27 Jan 2009 17:47:47 +0100
Message-ID: <9ea470500901270847m40264331le1092dc1589ec9de@mail.gmail.com>
Subject: Re: [PATCH 1/3] ide-cd: use ide_drive_t's rq in cdrom_queue_request_sense
From: Borislav Petkov <petkovbb@googlemail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 4:07 PM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
> On Monday 26 January 2009, Borislav Petkov wrote:
>> There should be no functionality change resulting from this patch.
>>
>> Suggested-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
>> ---
>>  drivers/ide/ide-cd.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
>> index d3d5fb6..3907466 100644
>> --- a/drivers/ide/ide-cd.c
>> +++ b/drivers/ide/ide-cd.c
>> @@ -207,7 +207,7 @@ static void cdrom_queue_request_sense(ide_drive_t *drive, void *sense,
>>                                     struct request *failed_command)
>>  {
>>       struct cdrom_info *info         = drive->driver_data;
>> -     struct request *rq              = &info->request_sense_request;
>> +     struct request *rq              = &drive->request_sense_rq;
>
> Don't we want to also remove now unused ->request_sense_request?

sure we do :)

--
From: Borislav Petkov <petkovbb@gmail.com>
Date: Tue, 27 Jan 2009 17:42:28 +0100
Subject: [PATCH 1/3] ide-cd: use ide_drive_t's rq in cdrom_queue_request_sense

There should be no functionality change resulting from this patch.

Suggested-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-cd.c |    2 +-
 drivers/ide/ide-cd.h |    2 --
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 3554dc4..bf4e7a0 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -205,7 +205,7 @@ static void cdrom_queue_request_sense(ide_drive_t
*drive, void *sense,
 				      struct request *failed_command)
 {
 	struct cdrom_info *info		= drive->driver_data;
-	struct request *rq		= &info->request_sense_request;
+	struct request *rq		= &drive->request_sense_rq;

 	ide_debug_log(IDE_DBG_SENSE, "enter");

diff --git a/drivers/ide/ide-cd.h b/drivers/ide/ide-cd.h
index 0b82233..b26d305 100644
--- a/drivers/ide/ide-cd.h
+++ b/drivers/ide/ide-cd.h
@@ -91,8 +91,6 @@ struct cdrom_info {
 	   on this device. */
 	struct request_sense sense_data;

-	struct request request_sense_request;
-
 	u8 max_speed;		/* Max speed of the drive. */
 	u8 current_speed;	/* Current speed of the drive. */

-- 
1.6.0.4

-- 
Regards/Gruss,
Boris
