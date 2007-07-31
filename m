Return-Path: <linux-kernel-owner+w=401wt.eu-S1760445AbXGaN4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760445AbXGaN4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 09:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754256AbXGaN4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 09:56:36 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:34156 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343AbXGaN4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 09:56:35 -0400
Date: Tue, 31 Jul 2007 19:26:42 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
To: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, dgc@sgi.com
Subject: Re: fallocate() man page
Message-ID: <20070731135642.GA11550@amitarora.in.ibm.com>
References: <20070713123816.GA18000@amitarora.in.ibm.com> <20070713124601.GA22961@amitarora.in.ibm.com> <20070714082342.174830@gmx.net> <20070716053235.GA10945@amitarora.in.ibm.com> <46A44629.3090107@gmx.net> <20070723131039.GA29198@amitarora.in.ibm.com> <46AE3F4C.3050505@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46AE3F4C.3050505@gmx.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Mon, Jul 30, 2007 at 09:43:08PM +0200, Michael Kerrisk wrote:
> Hello Amit.
> 
> > On Mon, Jul 23, 2007 at 08:09:45AM +0200, Michael Kerrisk wrote:
> >> Amit,
> >>
> >> I've taken the page that you sent and made various minor formatting and
> >> wording fixes.  I've also added various FIXMEs to the page.  Some of these
> >> ("FIXME .") are things that I need to check up later.  Some others are
> >> questions for which I need input from you, David, or someone else with the
> >> relevant info (I've marked these "FIXME Amit:").  Could you please review,
> >> and send a new draft of the page back to me.
> > 
> > Thanks for going through the manpage and improving it!
> > 
> > My comments are below in between <Amit> ... </Amit> tags.
> > 
> > Thanks!
> [...]
> 
> > The
> > .I mode
> > argument determines the operation to be performed on the given range.
> > Currently only one flag is supported for
> > .IR mode :
> > .TP
> > .B FALLOC_FL_KEEP_SIZE
> > allocates and initializes to zero the disk space within the given range.
> > .\" FIXME Amit: The next two sentences seem to contradict
> > .\" each other somewhat.  On the one hand, later writes
> > .\" are guaranteed not to fail for lack of space; on the other
> > .\" hand, the file size id not changed even if it is currently
> > .\" smaller than offset+len bytes.
> > .\" Could you explain this a little further.  (E.g., how does
> > .\" the kernel guarantee space without changing the size
> > .\" of the file?)
> > .\" <Amit>
> > .\"     Well, this is a feature where you can allocate/reserve space for
> > .\" a file without changing the file size. This is done by allocating blocks
> > .\" to the file, but still not changing the size. As mentioned below, this
> > .\" helps applications that use append mode a lot. These can open
> > .\" a file in append mode and start writing to "preallocated" space.
> > .\" So, if someone does a stat on a file after fallocate() with this mode (where
> > .\" file size is not changed), he/she will see that the st_blocks
> > .\" increased, but st_size did not change.
> > .\" </Amit>
> 
> Okay -- I tried rewording the text here a little to make this clearer.  Can
> you review the new version to see that it's okay.
> 
> [...]
<Amit>
Ok. Will review the draft version soon and will get back to you.
</Amit>
 
> > .\" FIXME Amit: Which other flags are likely to appear
> > .\" for mode, and in which kernel version are they likely?
> > .\" <Amit>
> > .\"    There were few more flags which were discussed, but none of
> > .\" them have been finalized upon. Here are these flags:
> > .\" FA_FL_DEALLOC, FA_FL_DEL_DATA, FA_FL_ERR_FREE, FA_FL_NO_MTIME, FA_FL_NO_CTIME
> > .\" All of the above flags were debated upon and we can not say if any/which one
> > .\" of these flags will make it to the later kernels.
> > .\" </Amit>
> 
> Thanks for the info.
> 
> [...]
> 
> > .\" FIXME Amit: is it worth adding a few words to the following
> > .\" sentence to say why fallocate() may allocate a larger range
> > .\" than specified?
> > .\" <Amit>
> > .\"     The preallocation is done in block size chunks. Thus, if the last
> > .\" few bytes in the range falls in a new block, this entire block gets
> > .\" allocated to the file. Hence we may have slightly larger range allocated.
> > .\" I have tried to add one line to explain this below. Please see if it
> > .\" makes sense and is understandable. Thanks!
> > .\" </Amit>
> 
> Thanks.
> 
> > .PP
> > .BR fallocate ()
> > may allocate a larger range than that was specified.
> > .\" <Amit>
> > .\" This is because allocation is done in block size chunks and hence
> > .\" the allocation will automatically get block aligned.
> > .\" </Amit>
> 
> I made the sentence:
> 
>     Because allocation is done in block size chunks, fallocate()
>     may allocate a larger range than that which was specified.
> 
> okay?
> 
> [...]

<Amit>
Ok.
</Amit>
 
> > .TP
> > .B ENODEV
> > .I fd
> > does not refer to a regular file or a directory.
> > .TP
> > .B ENOSPC
> > There is not enough space left on the device containing the file
> > referred to by
> > .IR fd .
> > .TP
> > .B ESPIPE
> > .I fd
> > refers to a pipe of file descriptor.
> > .\" FIXME Amit: ENODEV says "fd is not a file or a directory";
> > .\" ESPIPE says (I had to fix the text a little) "refers to a pipe".
> > .\" This doesn't make sense: if fd is a pipe, then either one
> > .\" of these errors could occur.  Which is it supposed to be?
> > .\" <Amit>
> > .\"    This is inline with posix_fallocate manpage. If it is a pipe,
> > .\" user will get ESPIPE.
> > .\" </Amit>
> 
> Okay -- thanks.  I reworded the text for the ESNODEV error to make this
> clearer.  (Please check the wording in the next draft.)

<Amit>
Sure.
</Amit>
 
> By the way in fs/open.c I see the comment:
> 
>         /*
>          * Let individual file system decide if it supports preallocation
>          * for directories or not.
>          */
>         if (!S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode))
>                 goto out_fput;
> 
> But that comment doesn't seem to accord with the line of code immediately
> below it (S_ISDIR() check is doene regardles of file system type).  Do I
> misunderstand something -- or is the comment wrong?
> 
> [...]

<Amit>
I think it is correct. We are failing ("goto out_fput;") _only_ if it is
not a regular file AND also not a directory. In the case when the
concerned object is a directory, the above "if" condition won't be true
and thus the "goto" won't get called. Hence, the individual file
system's ->fallocate() inode op will be called, which will decide if it
wants to support directories or not.
</Amit>
 
> > .TP
> > .B EOPNOTSUPP
> > .\" FIXME Amit: can you say a little more about the following error
> > .\" <Amit>
> > .\" How does following sound ?
> > .\" 'The specified mode is not supported on the object by the file system.'
> > .\" </Amit>
> 
> I made it:
> 
>     The mode is not supported by the file system containing the file
>     referred to by fd.
> 
> Okay?
> 
> [...]

<Amit>
Ok.
</Amit>
 
> New version of the page on its way soon.

<Amit>
I have received it. Will review it soon (maybe by tomorrow) and get
back. Thanks!
</Amit>

--
Regards,
Amit Arora
 
> Cheers,
> 
> Michael
