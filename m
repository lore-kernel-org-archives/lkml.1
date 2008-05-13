Return-Path: <linux-kernel-owner+w=401wt.eu-S1759996AbYEMUDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759996AbYEMUDJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:03:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759573AbYEMUCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:02:53 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:60679 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758049AbYEMUCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:02:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=NQE9uCLTIRY4fKGoyHGSM/0StZHFP/J7DhlLA0JsH+duhD/XFdw8TsHC6mxFkt5DptBjIUERpam6MIM6i+LuDMeoD/4R/sWKQBJB9Tan9ptm0EjaNVKk1rl8kpiGXjvzbN+zA6SzEZQD55PqRyS4jZUs/S4hY4fI2AAizvD0pqs=
From: Abdel Benamrouche <draconux@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH 0/2] /fs/partition/check.c : fix return value warning (V2)
Date: Tue, 13 May 2008 22:02:43 +0200
Message-Id: <1210708965-12220-1-git-send-email-draconux@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 12:27 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Sat, 10 May 2008 13:40:53 +0200
>  Abdel Benamrouche <draconux@gmail.com> wrote:
>  
>  > fs/partitions/check.c:381: warning: ignoring return value of ___device_add___,
>  >  declared with attribute warn_unused_result
>  >
>  > Signed-off-by: Abdel Benamrouche <draconux@gmail.com>
>  > ---
>  > :100644 100644 6149e4b... 7a87fad... M        fs/partitions/check.c
>  >  fs/partitions/check.c |    8 +++++++-
>  >  1 files changed, 7 insertions(+), 1 deletions(-)
>  >
>  > diff --git a/fs/partitions/check.c b/fs/partitions/check.c
>  > index 6149e4b..7a87fad 100644
>  > --- a/fs/partitions/check.c
>  > +++ b/fs/partitions/check.c
>  > @@ -378,7 +378,13 @@ void add_partition(struct gendisk *disk, int part, sector_t start, sector_t len,
>  >
>  >       /* delay uevent until 'holders' subdir is created */
>  >       p->dev.uevent_suppress = 1;
>  > -     device_add(&p->dev);
>  > +     if (device_add(&p->dev)) {
>  > +             put_device(&p->dev);
>  > +             free_part_stats(p);
>  > +             kfree(p);
>  > +             return;
>  > +     }
>  > +
>  >       partition_sysfs_add_subdir(p);
>  >       p->dev.uevent_suppress = 0;
>  >       if (flags & ADDPART_FLAG_WHOLEDISK)
>  
>  We should go further than this.  add_partition() just drops the error
>  on the floor.  It should be propagated back to callers, and callers
>  should be modified to handle it appropriately.
>  
>  Presumably we should also handle a device_create_file() failure as well
>  - that is presently being silently ignored.
>  
>  

done.
I make 2 patch so that it will be easier to read.



