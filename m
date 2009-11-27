Return-Path: <linux-kernel-owner+w=401wt.eu-S1753778AbZK0Cqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778AbZK0Cqs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 21:46:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753730AbZK0Cqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 21:46:48 -0500
Received: from mail-qy0-f192.google.com ([209.85.221.192]:63124 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728AbZK0Cqr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 21:46:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wCx3EnGzmmndqa5DaSW5yE874yYRRtZsi86V/jx2Voih4akfMAvqZnOUzmLZr6bf++
         R2KWtodXknbM+B4KGHsJftMIvA8KdzzFOnqp1M2xcXHSOeyVtVhImiNFXoOK5CW1zR3Q
         qz+bot0rBBlLQH/kJ7/ti4ZeZp5pWCvqjsSB4=
MIME-Version: 1.0
In-Reply-To: <20091127022820.GU32182@kryten>
References: <20091127022820.GU32182@kryten>
Date: Fri, 27 Nov 2009 10:46:53 +0800
Message-ID: <2375c9f90911261846i18a828eft391420b13bb3fbb2@mail.gmail.com>
Subject: Re: PATCH: softlockup: Fix hung_task_check_count sysctl
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Anton Blanchard <anton@samba.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, msb@google.com,
       fweisbec@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 27, 2009 at 10:28 AM, Anton Blanchard <anton@samba.org> wrote:
>
> I'm seeing spikes of up to 0.5ms in khungtaskd on a large machine. To reduce
> this source of jitter I tried setting hung_task_check_count to 0:
>
> # echo 0 > /proc/sys/kernel/hung_task_check_count
>
> which didn't have the intended response. Change to a post increment of
> max_count, so a value of 0 means check 0 tasks.
>
> Signed-off-by: Anton Blanchard <anton@samba.org>


Ack.

I would also suggest to make 'max_count' as unsigned long,
since sysctl_hung_task_check_count is.

Thanks.

> ---
>
> Index: linux.trees.git/kernel/hung_task.c
> ===================================================================
> --- linux.trees.git.orig/kernel/hung_task.c     2009-11-27 13:11:46.000000000 +1100
> +++ linux.trees.git/kernel/hung_task.c  2009-11-27 13:11:57.000000000 +1100
> @@ -144,7 +144,7 @@ static void check_hung_uninterruptible_t
>
>        rcu_read_lock();
>        do_each_thread(g, t) {
> -               if (!--max_count)
> +               if (!max_count--)
>                        goto unlock;
>                if (!--batch_count) {
>                        batch_count = HUNG_TASK_BATCHING;
