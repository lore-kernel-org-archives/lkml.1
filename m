Return-Path: <linux-kernel-owner+w=401wt.eu-S1757818AbYEEIab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757818AbYEEIab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 04:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754203AbYEEIaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 04:30:23 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:45086 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014AbYEEIaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 04:30:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BlZwLZDhJ5raNDFiSkTgDB/awo0JiLN32gBHWuJQe3aT3Y9IDI28CKeeb5iFJZ0+Qo0d82CJr1Jy55dYyWaBhYUlWppdyTfT/11R1T28fXMf/Pzb8hp6TTPbd+cljYrson/oULp/4V4fmo8n81+vA/Aay08Hg1bx44tYIJLGuH0=
Message-ID: <5eeb9ad90805050130i39ae791dwe599c12fc08fb8ec@mail.gmail.com>
Date: Mon, 5 May 2008 10:30:09 +0200
From: DM <dm.n9107@gmail.com>
To: "Ulrich Drepper" <drepper@redhat.com>
Subject: Re: [PATCH v2] unify sys_pipe implementation
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-mips@linux-mips.org, sparclinux@vger.kernel.org,
       torvalds@linux-foundation.org
In-Reply-To: <200805031801.m43I109q032242@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805031801.m43I109q032242@devserv.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 3, 2008 at 8:01 PM, Ulrich Drepper <drepper@redhat.com> wrote:
[...]
>   /*
>  + * sys_pipe() is the normal C calling standard for creating
>  + * a pipe. It's not the way Unix traditionally does this, though.
>  + */
>  +asmlinkage long sys_pipe(int __user *fildes)
>  +{
>  +       int fd[2];
>  +       int error;
>  +
>  +       error = do_pipe(fd);
>  +       if (!error) {
>  +               if (copy_to_user(fildes, fd, sizeof(fd)))
>  +                       error = -EFAULT;
>  +       }
>  +       return error;
>  +}
>  +
[...]

I realize this code is old, but wouldn't file descriptors leak if
copy_to_user fails?

BR,
dm.n9107
