Return-Path: <linux-kernel-owner+w=401wt.eu-S1753537AbYLZHxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbYLZHxj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 02:53:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbYLZHx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 02:53:27 -0500
Received: from wf-out-1314.google.com ([209.85.200.169]:46286 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437AbYLZHx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 02:53:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=NTGfEpoBin3jQUs1mItwxa+qxp2OZmzd65ZpfGdshSfKCf28vzMT+xAIyvnvRpoQcz
         LMEWyuBwgJ19U5jA4/+lrDs7ECN6RWV7+iQ/l7WIfd+yf9mF2fgTLN0yTAyrCwGsSbhb
         LnPybReskxvOBLkMU5pLpUiBx1CuFmtPMHkmI=
Message-ID: <cbe409c50812252353n56ab5a59u75fc99243ec89265@mail.gmail.com>
Date: Fri, 26 Dec 2008 15:53:25 +0800
From: "eagle black" <rochacker@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Russell King" <rmk+lkml@arm.linux.org.uk>
Subject: Re: [BUG] It seems that i found a bug in the linux kernel, and it also in the newest kernel version
In-Reply-To: <cbe409c50812252315w1bb62fa0n3c0e05e7d9432e40@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cbe409c50812252315w1bb62fa0n3c0e05e7d9432e40@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 26, 2008 at 3:15 PM, eagle black <rochacker@gmail.com> wrote:
>
> let's see, int the function elevator_init of block/elevator.c ,
> if the function elevator_init_queue failed for some reason, and the memory
> of elevator_alloc  alloced does not free!
>
> int elevator_init(struct request_queue *q, char *name)
> {
>         struct elevator_type *e = NULL;
>         struct elevator_queue *eq;
>         int ret = 0;
>         void *data;
>
>         INIT_LIST_HEAD(&q->queue_head);
>         q->last_merge = NULL;
>         q->end_sector = 0;
>         q->boundary_rq = NULL;
>
>         if (name) {
>                 e = elevator_get(name);
>                 if (!e)
>                         return -EINVAL;
>         }
>
>         if (!e && *chosen_elevator) {
>                 e = elevator_get(chosen_elevator);
>                 if (!e)
>                         printk(KERN_ERR "I/O scheduler %s not found\n",
>                                                         chosen_elevator);
>         }
>
>         if (!e) {
>                 e = elevator_get(CONFIG_DEFAULT_IOSCHED);
>                 if (!e) {
>                         printk(KERN_ERR
>                                 "Default I/O scheduler not found. " \
>                                 "Using noop.\n");
>                         e = elevator_get("noop");
>                 }
>         }
>
>         eq = elevator_alloc(q, e);
>         if (!eq)
>                 return -ENOMEM;
>
>         data = elevator_init_queue(q, eq);
>         if (!data) {
>                 kobject_put(&eq->kobj);
>                 return -ENOMEM;
>         }
>
>         elevator_attach(q, eq, data);
>         return ret;
> }
> EXPORT_SYMBOL(elevator_init);
>
