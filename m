Return-Path: <linux-kernel-owner+w=401wt.eu-S1753992AbZCIQsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbZCIQsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 12:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbZCIQsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 12:48:11 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:29018 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbZCIQsK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 12:48:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pfOq+mUHzSzdx5MaymBzJkb1B3mnJ59sSFDmGmjr2S1e7Rfgd+Qh8+pd+0kfX3WeLb
         9NvKhByUELxxnkLphV59POPFl1IRnEXXpYREv+WgTSK6QqbduJBprkYd2CO4rDVPi4l2
         NEhxl10+H2F1ttXBxfvoAdI1BLiZz2CXz7U5s=
MIME-Version: 1.0
In-Reply-To: <x49zlfud6w7.fsf@segfault.boston.devel.redhat.com>
References: <x49bpsaelwa.fsf@segfault.boston.devel.redhat.com>
	 <x49zlfud6w7.fsf@segfault.boston.devel.redhat.com>
Date: Tue, 10 Mar 2009 05:48:07 +1300
Message-ID: <c49095e30903090948n2d015516t480e917c36943001@mail.gmail.com>
Subject: Re: [patch] man-pages: add documentation about the memlock 
	implications of io_setup
From: Michael Kerrisk <michael.kerrisk@googlemail.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-aio <linux-aio@kvack.org>, michael.kerrisk@gmail.com,
       zach.brown@oracle.com, bcrl@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[RESEND: Really CC+=Vegard Nossum, this time, and += mtk.manpages@, as well]

Hi Jeff,

Note that my address for man-pages is mtk.manpages@gmail.com.

On Tue, Mar 10, 2009 at 4:59 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Hi,
>
> This patch, against man-pages-3.19, adds verbiage surrounding the newly
> proposed accounting of pinned aio completion ring pages against the
> memlock rlimit.  It also fixes up a few references to aio_context_t
> (which should be io_context_t).  Sorry for conflating the two, I can
> break it apart if needed.

Breaking apart really would be better.  Could you resubmit (to
mtk.manpages@, and CC linux-man@vger) please?

When you resubmit, could you please clarify the following:

1. For the "proposed accounting of pinned aio completion ring pages
against the memlock rlimit", can you tell me which mainline kernel
version this change (will) appear(s) in.  (You say "proposed", so that
it's not clear when/if the change will be merged into mainline.  A git
commit reference could be useful to me here.)

2. Regarding  aio_context_t vs io_context_t, Vegard Nossum also raised
this issue a while back, and I replied that the aio_context_t type is
used because:

[[
These pages attempt to document the bare syscall API.
Take a look at the kernel sources: there the type *is*
aio_context_t.
]]

Perhaps I am/was being muddle-headed here, since, after all, the pages
do say "Link with -laio."  (Once upon a time the pages actually *did*
use "io_context_t", but I changed that during a big clean-up of the
io_*.2 pages a year or two back.)  Your thoughts?  (Why do we even
have aio_context_t in the kernel versus io_context_t in libaio?)

Cheers,

Michael

> diff -up man-pages-3.19/man2/io_cancel.2.orig man-pages-3.19/man2/io_cancel.2
> --- man-pages-3.19/man2/io_cancel.2.orig        2009-03-08 11:57:50.000000000 -0400
> +++ man-pages-3.19/man2/io_cancel.2     2009-03-08 11:58:01.000000000 -0400
> @@ -32,7 +32,7 @@ io_cancel \- cancel an outstanding async
>  .\"#include <linux/aio.h>
>  .sp
>  .\" .HP 16
> -.BI "int io_cancel(aio_context_t " ctx_id ", struct iocb *" iocb ,
> +.BI "int io_cancel(io_context_t " ctx_id ", struct iocb *" iocb ,
>  .BI "              struct io_event *" result );
>  .\" .ad
>  .\" .hy
> diff -up man-pages-3.19/man2/io_destroy.2.orig man-pages-3.19/man2/io_destroy.2
> --- man-pages-3.19/man2/io_destroy.2.orig       2009-03-08 11:58:08.000000000 -0400
> +++ man-pages-3.19/man2/io_destroy.2    2009-03-08 11:58:16.000000000 -0400
> @@ -31,7 +31,7 @@ io_destroy \- destroy an asynchronous I/
>  .\" #include <linux/aio.h>
>  .sp
>  .\" .HP 17
> -.BI "int io_destroy(aio_context_t " ctx );
> +.BI "int io_destroy(io_context_t " ctx );
>  .\" .ad
>  .\" .hy
>  .sp
> diff -up man-pages-3.19/man2/io_setup.2.orig man-pages-3.19/man2/io_setup.2
> --- man-pages-3.19/man2/io_setup.2.orig 2009-03-08 11:53:39.000000000 -0400
> +++ man-pages-3.19/man2/io_setup.2      2009-03-08 11:57:09.000000000 -0400
> @@ -31,7 +31,7 @@ io_setup \- create an asynchronous I/O c
>  .\" #include <linux/aio.h>
>  .sp
>  .\" .HP 15
> -.BI "int io_setup(unsigned " nr_events ", aio_context_t *" ctxp );
> +.BI "int io_setup(unsigned " nr_events ", io_context_t *" ctxp );
>  .\" .ad
>  .\" .hy
>  .sp
> @@ -45,7 +45,9 @@ at least \fInr_events\fP.
>  \fIctxp\fP must not point to an AIO context that already exists, and must
>  be initialized to 0 prior to the call.
>  On successful creation of the AIO context, \fI*ctxp\fP is filled in
> -with the resulting handle.
> +with the resulting handle.  Memory is reserved by the kernel for the completion
> +ring and, because this memory is pinned, it will be charged against the
> +process's memlock rlimit.
>  .SH "RETURN VALUE"
>  On success,
>  .BR io_setup ()
> @@ -54,7 +56,8 @@ For the failure return, see NOTES.
>  .SH "ERRORS"
>  .TP
>  .B EAGAIN
> -The specified \fInr_events\fP exceeds the user's limit of available events.
> +The specified \fInr_events\fP exceeds the process's limit of available events.
> +Try increasing the memlock rlimit for the process.
>  .TP
>  .B EFAULT
>  An invalid pointer is passed for \fIctxp\fP.
> diff -up man-pages-3.19/man2/io_submit.2.orig man-pages-3.19/man2/io_submit.2
> --- man-pages-3.19/man2/io_submit.2.orig        2009-03-08 11:58:26.000000000 -0400
> +++ man-pages-3.19/man2/io_submit.2     2009-03-08 11:58:34.000000000 -0400
> @@ -31,7 +31,7 @@ io_submit \- submit asynchronous I/O blo
>  .\" #include <linux/aio.h>
>  .sp
>  .\" .HP 16
> -.BI "int io_submit(aio_context_t " ctx_id ", long " nr \
> +.BI "int io_submit(io_context_t " ctx_id ", long " nr \
>  ", struct iocb **" iocbpp );
>  .\" .ad
>  .\" .hy
> @@ -63,7 +63,7 @@ The file descriptor specified in the fir
>  One of the data structures points to invalid data.
>  .TP
>  .B EINVAL
> -The \fIaio_context\fP specified by \fIctx_id\fP is invalid.
> +The \fIio_context\fP specified by \fIctx_id\fP is invalid.
>  \fInr\fP is less than 0.
>  The \fIiocb\fP at *iocbpp[0] is not properly initialized,
>  or the operation specified is invalid for the file descriptor
> diff -up man-pages-3.19/man7/capabilities.7.orig man-pages-3.19/man7/capabilities.7
> --- man-pages-3.19/man7/capabilities.7.orig     2009-03-08 11:52:56.000000000 -0400
> +++ man-pages-3.19/man7/capabilities.7  2009-03-08 11:53:14.000000000 -0400
> @@ -129,7 +129,8 @@ Lock memory
>  .RB ( mlock (2),
>  .BR mlockall (2),
>  .BR mmap (2),
> -.BR shmctl (2)).
> +.BR shmctl (2),
> +.BR io_setup (2)).
>  .TP
>  .B CAP_IPC_OWNER
>  Bypass permission checks for operations on System V IPC objects.
>
