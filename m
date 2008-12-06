Return-Path: <linux-kernel-owner+w=401wt.eu-S1758497AbYLFPE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758497AbYLFPE6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 10:04:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756783AbYLFPEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 10:04:50 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:20095 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756761AbYLFPEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 10:04:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=tjh9inCcsiI7O+HpTK9hhW5VXWUyBUAvn3zCasvgbjg3vZXKkXIfaUXdlc/OdE/b06
         fcuxOl0ALMsrZMgJCpvrltWcyyu/gX/LJ8gU6cuD7wSjIneY8oNaZNlhiHsBCJi+N+H1
         bCvYOjld3YmjueZzbBniyNta1vJ7k1bKtJxZc=
Message-ID: <b9df5fa10812060704t1685710aw65f7c1e00e5f98@mail.gmail.com>
Date: Sat, 6 Dec 2008 21:04:48 +0600
From: "Rakib Mullick" <rakib.mullick@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] kernel/freezer.c : Removing extra checking.
Cc: "Linux-kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <200812061441.15772.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b9df5fa10812060020i40373ed3rdc97812ed46ba959@mail.gmail.com>
	 <200812061441.15772.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/6/08, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Saturday, 6 of December 2008, Rakib Mullick wrote:
>  > Impact: Reduces an extra checking.
>  >
>  > Following patch removes an extra checking. We can remove it since, the
>  > current task is frozen. If the current task is not frozen, then it
>  > will return from __else__ condition of freezing(current) check. So,
>  > the check becames unnecessary. It also reduces 32 bytes of text space
>  > on my x86  (32 bit) system.
>
>
> What will happen with this patch applied when a task is woken up for some
>  reason other than thawing?
thawing is usually used for woken up a frozzen process. Would you
please tell me what are the other ways to woken up a frozzen process?
Am I missing anything ?
Thanks,

>
>  > Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
>  >
>  > --- linux-2.6-orig/kernel/freezer.c   2008-12-05 19:53:45.000000000 +0600
>  > +++ linux-2.6/kernel/freezer.c        2008-12-05 19:55:40.000000000 +0600
>  > @@ -46,8 +46,6 @@ void refrigerator(void)
>  >
>  >       for (;;) {
>  >               set_current_state(TASK_UNINTERRUPTIBLE);
>  > -             if (!frozen(current))
>  > -                     break;
>  >               schedule();
>  >       }
>  >       pr_debug("%s left refrigerator\n", current->comm);
>
> > --
>
