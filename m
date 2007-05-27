Return-Path: <linux-kernel-owner+w=401wt.eu-S1757909AbXE0RMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909AbXE0RMx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 13:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694AbXE0RMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 13:12:47 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:26788 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbXE0RMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 13:12:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PR/+BijItmWyCw5BEfActFchr1Vy5K9k2f4WYdALRQUttXjV8J99nee9PNtXxX1H3VYRN6MbaXazETa8nNel0H/cYGHQjBOsi7tLf4Fq7ReOeVqIJqYYliA6SU/XiC8X8yhd6bnuc7mEDAcQGpxt+ln2XnontC9JqciWjK1k+m4=
Message-ID: <91b13c310705271012j6c73f539t8e993b21d51c64a9@mail.gmail.com>
Date: Mon, 28 May 2007 01:12:44 +0800
From: "rae l" <crquan@gmail.com>
To: "Matthias Kaehlcke" <matthias.kaehlcke@gmail.com>, axboe@kernel.dk,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Block device elevator: use list_for_each_entry() instead of list_for_each()
In-Reply-To: <20070527164302.GL31790@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070527164302.GL31790@traven>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

it makes sense to what it does.

On 5/28/07, Matthias Kaehlcke <matthias.kaehlcke@gmail.com> wrote:
> Use list_for_each_entry() instead of list_for_each() in the block
> device elevator
>
> Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
>
> --
>
> diff --git a/block/elevator.c b/block/elevator.c
> index ce866eb..4769a25 100644
> --- a/block/elevator.c
> +++ b/block/elevator.c
> @@ -112,12 +112,8 @@ static inline int elv_try_merge(struct request *__rq, struct bio *bio)
>  static struct elevator_type *elevator_find(const char *name)
>  {
>         struct elevator_type *e;
> -       struct list_head *entry;
> -
> -       list_for_each(entry, &elv_list) {
> -
> -               e = list_entry(entry, struct elevator_type, list);
>
> +       list_for_each_entry(e, &elv_list, list) {
>                 if (!strcmp(e->elevator_name, name))
>                         return e;
>         }
> @@ -1116,14 +1112,11 @@ ssize_t elv_iosched_show(request_queue_t *q, char *name)
>  {
>         elevator_t *e = q->elevator;
>         struct elevator_type *elv = e->elevator_type;
> -       struct list_head *entry;
> +       struct elevator_type *__e;
>         int len = 0;
>
>         spin_lock(&elv_list_lock);
> -       list_for_each(entry, &elv_list) {
> -               struct elevator_type *__e;
> -
> -               __e = list_entry(entry, struct elevator_type, list);
> +       list_for_each_entry(__e, &elv_list, list) {
>                 if (!strcmp(elv->elevator_name, __e->elevator_name))
>                         len += sprintf(name+len, "[%s] ", elv->elevator_name);
>                 else
>
> --
> Matthias Kaehlcke
> Linux Application Developer
> Barcelona
>
>
>    Usually when people are sad, they don't do anything. They just cry over
>      their condition. But when they get angry, they bring about a change
>                               (Malcolm X)
>                                                                  .''`.
>     using free software / Debian GNU/Linux | http://debian.org  : :'  :
>                                                                 `. `'`
> gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Denis Cheng
Linux Application Developer
