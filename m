Return-Path: <linux-kernel-owner+w=401wt.eu-S1754494AbYIUA0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494AbYIUA0w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 20:26:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbYIUA0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 20:26:42 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:44510 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbYIUA0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 20:26:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=KJTdurFWKybgpBwGKsr6o3wBjFW4dhJSU8kuwMtMtJRy5TTeSMvb07bfDpOxgNBzzC
         Iqob+3OOc1VQU1otqU7Zt68Dj4tfm1U4VjoNBLMwobI3a1sLGCnVY5OILN0mVk7ASqZK
         jy3J5NdKt+TfTI2B8iNyydi92SJecjo32UWzg=
Message-ID: <e9c3a7c20809201726v78f9a00gb9a168f7f9c19044@mail.gmail.com>
Date: Sat, 20 Sep 2008 17:26:40 -0700
From: "Dan Williams" <dan.j.williams@gmail.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] md: Add support for data integrity to MD
Cc: jens.axboe@oracle.com, neilb@suse.de, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org
In-Reply-To: <yq1y71mmjvw.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <yq1y71mmjvw.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 20, 2008 at 5:18 PM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
> If all subdevices support the same protection format the MD device is
> flagged as capable.
>
> Depends on d7533ad0e132f92e75c1b2eb7c26387b25a583c1 being reverted.
>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>  drivers/md/md.c |   32 +++++++++++++++++++++++++++++++-
>  1 files changed, 31 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 45521da..b038581 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -3497,7 +3497,7 @@ static int do_md_run(mddev_t * mddev)
>        int err;
>        int chunk_size;
>        struct list_head *tmp;
> -       mdk_rdev_t *rdev;
> +       mdk_rdev_t *rdev, *prev;
>        struct gendisk *disk;
>        struct mdk_personality *pers;
>        char b[BDEVNAME_SIZE];
> @@ -3759,6 +3759,35 @@ static int do_md_run(mddev_t * mddev)
>        sysfs_notify(&mddev->kobj, NULL, "sync_action");
>        sysfs_notify(&mddev->kobj, NULL, "degraded");
>        kobject_uevent(&disk_to_dev(mddev->gendisk)->kobj, KOBJ_CHANGE);
> +
> +       /* Data integrity passthrough not supported on RAID 4, 5 and 6 */
> +       if (pers->level >= 4 && pers->level <= 6)
> +               return 0;

Do you have a reference to the issues in supporting this?

Thanks,
Dan
