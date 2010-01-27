Return-Path: <linux-kernel-owner+w=401wt.eu-S1751903Ab0A0IAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903Ab0A0IAW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 03:00:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751018Ab0A0IAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 03:00:21 -0500
Received: from mail-pz0-f189.google.com ([209.85.222.189]:59589 "EHLO
	mail-pz0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab0A0IAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 03:00:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=CyXTikZER/Wi04P+qsKKxpBSzLMd6pXy5d+26YNYRzW/9Msc71o0i69PHOCkpbWw3t
         LcfBVbES7iT0Wwq0eLV+CKSZ1LuEqq6AAztbS9m0mShQMvqfxC8MtUB9VRGgOT4LwCvZ
         V5OYG+lEWQyqCa301gZvJO3mckZV3bi6IOsRw=
MIME-Version: 1.0
In-Reply-To: <4B5FDCD1.8060806@gmail.com>
References: <4B5FDCD1.8060806@gmail.com>
Date: Wed, 27 Jan 2010 16:00:20 +0800
X-Google-Sender-Auth: e43408f7d5b73b68
Message-ID: <3d0408631001270000w49fc9100yb1e3b59df2e032e9@mail.gmail.com>
Subject: Re: [PATCH]btrfs: avoid comparing with NULL pointer
From: "Yan, Zheng " <yanzheng@21cn.com>
To: Liuwenyi <qingshenlwy@gmail.com>
Cc: chris.mason@oracle.com, jbacik@redhat.com, jens.axboe@oracle.com,
       linux-btrfs <linux-btrfs@vger.kernel.org>, linux-kernel@vger.kernel.org,
       strongzgy@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/27 Liuwenyi <qingshenlwy@gmail.com>:
> In this patch, I adjust the seqence of if-conditions.
> It will assess the page->private situation.
> First, we make sure the page->private is not null.
> And then, we can do some with this page->private.
>
> ---
> Signed-off-by: Liuwenyi <qingshenlwy@gmail.com>
> Cc: Chris Mason <chris.mason@oracle.com>
> Cc: Yan Zheng <zheng.yan@oracle.com>
> Cc: Josef Bacik <jbacik@redhat.com>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Cc: linux-btrfs@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
>
> ---
> fs/btrfs/disk-io.c | 4 ++--
> 1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 009e3bd..a300dca 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1407,11 +1407,11 @@ static int bio_ready_for_csum(struct bio *bio)
>
> bio_for_each_segment(bvec, bio, i) {
> page = bvec->bv_page;
> - if (page->private == EXTENT_PAGE_PRIVATE) {
> + if (!page->private) {
> length += bvec->bv_len;
> continue;
> }
> - if (!page->private) {
> + if (page->private == EXTENT_PAGE_PRIVATE) {
> length += bvec->bv_len;
> continue;
> }
> --

Why do you want to do this? The code is perfect safe even
page->private is NULL. Furthermore, your patch is malformed.

Yan, Zheng
