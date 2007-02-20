Return-Path: <linux-kernel-owner+w=401wt.eu-S964892AbXBTNni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964892AbXBTNni (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 08:43:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964885AbXBTNni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 08:43:38 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:59417 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964879AbXBTNnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 08:43:37 -0500
Subject: Re: Accessing file-offset info for fds in /proc?
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Hank Leininger <hlein@korelogic.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20070220073130.GV5752@timmy.spinoli.org>
References: <20070220073130.GV5752@timmy.spinoli.org>
Content-Type: text/plain
Date: Tue, 20 Feb 2007 07:43:33 -0600
Message-Id: <1171979013.28491.16.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-20 at 02:31 -0500, Hank Leininger wrote:
> Is there anything provided by the kernel that would let you see the
> current offset of an existing filehandle?
> 
> Sometimes when processing a very large file (grepping a log, bzip2'ing
> or gpg'ing a file, or whatever), I'd really like to know how far along
> it is, because I'm impatient.  lsof has an -o flag to show offsets for
> file descriptors it lists, but it appears that's not supported under
> Linux.  It looks like all of the information lsof and fuser print about 
> files in use, etc can be gotten from /proc/*/fd/* (and /proc/*/maps, but
> I'm not really concerned with mmap'ed files, just positions on fds).
> Sometimes I'll resort to strace -s4096'ing the process to see what chunk
> of text it's currently reading, and try to guess from that.  Silly.
> 
> Has anybody ever developed a patch to implement this?  I realize this
> could create a variety of information-leakage problems; the information
> probably would need to be restricted, such as by the same rules as
> dumpable.  Are there any horribly painful reasons why this couldn't be
> done?

It shouldn't be too painful.  The code to populate /proc/*/fd/ has the
file struct.  It just doesn't have a place pass the offset to user-space
since it's basically creating a symlink.  In proc_fd_link(), it has the
file struct.  The offset is file->f_pos.

One could create something like /proc/*/fd_offsets, whose read method
could list the file descriptor, path, and offset for each open file.

Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

