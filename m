Return-Path: <linux-kernel-owner+w=401wt.eu-S1754168AbZGNNxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbZGNNxv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 09:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754041AbZGNNxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 09:53:50 -0400
Received: from mail-qy0-f192.google.com ([209.85.221.192]:35556 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877AbZGNNxu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 09:53:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xifr0rjJkr3lim0cN/46WmBoHjpLdYqrx1fesP/r9XY5AlSYypuyKMIeDLVdfjM7M5
         kVwEpHg9PwNtQMNQbx0wJDVVwPGGgBPJjRfhOVH/tJCG7uw9iHbbiWfre4uzAcrx+S53
         tI3gk0fq2uxkT0oIouOKoK28WA3nEEH8OEQKA=
MIME-Version: 1.0
In-Reply-To: <1247572618-24073-1-git-send-email-dfeng@redhat.com>
References: <1247572618-24073-1-git-send-email-dfeng@redhat.com>
Date: Tue, 14 Jul 2009 21:53:49 +0800
Message-ID: <2375c9f90907140653n3d689416jac8fbff43237fc15@mail.gmail.com>
Subject: Re: [PATCH] block: sysfs fix mismatched queue_var_{store,show} in 
	64bit kernel
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Xiaotian Feng <dfeng@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 14, 2009 at 7:56 PM, Xiaotian Feng<dfeng@redhat.com> wrote:
> In blk-sysfs.c, queue_var_store uses unsigned long to store data,
> but queue_var_show uses unsigned int to show data. This causes,
>
>        # echo 70000000000 > /sys/block/<dev>/queue/read_ahead_kb
>        # cat /sys/block/<dev>/queue/read_ahead_kb => get wrong value
>
> Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
> ---
>  block/blk-sysfs.c |   13 +++++++------
>  1 files changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> index b1cd040..e177eb3 100644
> --- a/block/blk-sysfs.c
> +++ b/block/blk-sysfs.c
> @@ -16,9 +16,9 @@ struct queue_sysfs_entry {
>  };
>
>  static ssize_t
> -queue_var_show(unsigned int var, char *page)
> +queue_var_show(unsigned long var, char *page)
>  {
> -       return sprintf(page, "%d\n", var);
> +       return sprintf(page, "lu\n", var);


%lu

>  }
>
>  static ssize_t
> @@ -77,7 +77,8 @@ queue_requests_store(struct request_queue *q, const char *page, size_t count)
>
>  static ssize_t queue_ra_show(struct request_queue *q, char *page)
>  {
> -       int ra_kb = q->backing_dev_info.ra_pages << (PAGE_CACHE_SHIFT - 10);
> +       unsigned long ra_kb = q->backing_dev_info.ra_pages <<
> +                                       (PAGE_CACHE_SHIFT - 10);


It looks like that your email client replaces tab's with spaces.
