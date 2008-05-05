Return-Path: <linux-kernel-owner+w=401wt.eu-S1757990AbYEEJQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990AbYEEJQL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 05:16:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754770AbYEEJP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 05:15:56 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:47682 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597AbYEEJPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 05:15:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=kMGZpkyX+ewQQ2eYahy7WrEm2zS69ON+UQRxAa7Y7S/2hmm7yz5qF15E7eJKJOyRVJi1Y5tZMRIlt6O/WLtPa48g3w1iL0Bj64i6WvydC9kOmR8R7O0MIZFne6HJvzYzr2eDx14ePQBYc6DypZiRRFHfhF+PG/7U9Lx4yZoqGQI=
Message-ID: <517f3f820805050215s689ae274yf8a4ad270cb5981c@mail.gmail.com>
Date: Mon, 5 May 2008 11:15:53 +0200
From: "Michael Kerrisk" <mtk.manpages@gmail.com>
To: DM <dm.n9107@gmail.com>
Subject: Re: [PATCH v2] unify sys_pipe implementation
Cc: "Ulrich Drepper" <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, linux-mips@linux-mips.org,
       sparclinux@vger.kernel.org, torvalds@linux-foundation.org
In-Reply-To: <5eeb9ad90805050130i39ae791dwe599c12fc08fb8ec@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805031801.m43I109q032242@devserv.devel.redhat.com>
	 <5eeb9ad90805050130i39ae791dwe599c12fc08fb8ec@mail.gmail.com>
X-Google-Sender-Auth: 4e80ca2b3fe2a603
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/5/08, DM <dm.n9107@gmail.com> wrote:
> On Sat, May 3, 2008 at 8:01 PM, Ulrich Drepper <drepper@redhat.com> wrote:
>  [...]
>
> >   /*
>  >  + * sys_pipe() is the normal C calling standard for creating
>  >  + * a pipe. It's not the way Unix traditionally does this, though.
>  >  + */
>  >  +asmlinkage long sys_pipe(int __user *fildes)
>  >  +{
>  >  +       int fd[2];
>  >  +       int error;
>  >  +
>  >  +       error = do_pipe(fd);
>  >  +       if (!error) {
>  >  +               if (copy_to_user(fildes, fd, sizeof(fd)))
>  >  +                       error = -EFAULT;
>  >  +       }
>  >  +       return error;
>  >  +}
>  >  +
>
> [...]
>
>  I realize this code is old, but wouldn't file descriptors leak if
>  copy_to_user fails?

Yes, it does -- I just tested this.

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
