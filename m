Return-Path: <linux-kernel-owner+w=401wt.eu-S1759602AbXGMMp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759602AbXGMMp7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 08:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755217AbXGMMpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 08:45:49 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:34561 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753820AbXGMMpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 08:45:47 -0400
Date: Fri, 13 Jul 2007 18:16:01 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Cc: xfs@oss.sgi.com, michael.kerrisk@gmx.net, tytso@mit.edu, cmm@us.ibm.com,
       suparna@in.ibm.com, adilger@clusterfs.com, dgc@sgi.com
Subject: [PATCH 1/6][TAKE7] manpage for fallocate
Message-ID: <20070713124601.GA22961@amitarora.in.ibm.com>
References: <20070713123816.GA18000@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070713123816.GA18000@amitarora.in.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Following is the modified version of the manpage originally submitted by
David Chinner. Please use `nroff -man fallocate.2 | less` to view.

This includes changes suggested by Heikki Orsila and Barry Naujok.


.TH fallocate 2
.SH NAME
fallocate \- allocate or remove file space
.SH SYNOPSIS
.nf
.B #include <fcntl.h>
.PP
.BI "long fallocate(int " fd ", int " mode ", loff_t " offset ", loff_t " len);
.SH DESCRIPTION
The
.B fallocate
syscall allows a user to directly manipulate the allocated disk space
for the file referred to by
.I fd
for the byte range starting at
.I offset
and continuing for
.I len
bytes.
The
.I mode
parameter determines the operation to be performed on the given range.
Currently there are two modes:
.TP
.B FALLOC_ALLOCATE
allocates and initialises to zero the disk space within the given range.
After a successful call, subsequent writes are guaranteed not to fail because
of lack of disk space.  If the size of the file is less than
.IR offset + len ,
then the file is increased to this size; otherwise the file size is left
unchanged.
.B FALLOC_ALLOCATE
closely resembles
.BR posix_fallocate (3)
and is intended as a method of optimally implementing this function.
.B FALLOC_ALLOCATE
may allocate a larger range than that was specified.
.TP
.B FALLOC_RESV_SPACE
provides the same functionality as
.B FALLOC_ALLOCATE
except it does not ever change the file size. This allows allocation
of zero blocks beyond the end of file and is useful for optimising
append workloads.
.SH RETURN VALUE
.B fallocate
returns zero on success, or an error number on failure.
Note that
.I errno
is not set.
.SH ERRORS
.TP
.B EBADF
.I fd
is not a valid file descriptor, or is not opened for writing.
.TP
.B EFBIG
.IR offset + len
exceeds the maximum file size.
.TP
.B EINVAL
.I offset
was less than 0, or
.I len
was less than or equal to 0.
.TP
.B ENODEV
.I fd
does not refer to a regular file or a directory.
.TP
.B ENOSPC
There is not enough space left on the device containing the file
referred to by
.IR fd .
.TP
.B ESPIPE
.I fd
refers to a pipe of file descriptor.
.TP
.B ENOSYS
The filesystem underlying the file descriptor does not support this
operation.
.TP
.B EINTR
A signal was caught during execution
.TP
.B EIO
An I/O error occurred while reading from or writing to a file system.
.TP
.B EOPNOTSUPP
The mode is not supported on the file descriptor.
.SH AVAILABILITY
The
.B fallocate
system call is available since 2.6.XX
.SH SEE ALSO
.BR syscall (2),
.BR posix_fadvise (3),
.BR ftruncate (3).
