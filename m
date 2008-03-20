Return-Path: <linux-kernel-owner+w=401wt.eu-S1755903AbYCTB52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903AbYCTB52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 21:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754278AbYCTB5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 21:57:11 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:35634 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699AbYCTB5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 21:57:10 -0400
Date: Wed, 19 Mar 2008 19:56:50 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       bugme-daemon@bugzilla.kernel.org, joe@fruitfly.org
Subject: Re: [Bugme-new] [Bug 10284] New: executables with read bit 'off' cannot open /dev/stdin
Message-ID: <20080320015650.GG424@parisc-linux.org>
References: <bug-10284-10286@http.bugzilla.kernel.org/> <20080319143108.c8f8a544.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080319143108.c8f8a544.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2008 at 02:31:08PM -0700, Andrew Morton wrote:
> (switched to email.  Please respond via emailed reply-to-all, not via the
> bugzilla web interface).

Unfortunately, Joe seems not to be able to follow that instruction.
He's left two comments in bugzilla which are not reflected in this email
thread.

> >      KernelVersion: 2.6.16.27-0.9-smp
> > A short program that calls open on /dev/stdin:
> > 
> > cat open_stdin.c
> > #include <stdio.h>
> > #include <stdlib.h>
> > #include <sys/types.h>
> > #include <sys/stat.h>
> > #include <fcntl.h>
> > 
> > int main(int argc, char **argv) {
> >   open("/dev/stdin",O_RDONLY);
> >   return 0;
> > }

I've tried this program on 2.6.25-rc3-00093-g59e1338-dirty and it does
not fail.

> > open("/dev/stdin", O_RDONLY)            = -1 EACCES (Permission denied)

Specifically, my tests show:

open-stdin-readable:open("/dev/stdin", O_RDONLY)            = 3
open-stdin-unreadable:open("/dev/stdin", O_RDONLY)            = 3

Joe, can you try a more recent kernel?

Another thing to try would be opening /proc/self/fd/0 or /dev/pts/0
in your program and seeing whether those fail.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
