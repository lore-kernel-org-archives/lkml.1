Return-Path: <linux-kernel-owner+w=401wt.eu-S1030302AbXDCPF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030302AbXDCPF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 11:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030308AbXDCPF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 11:05:28 -0400
Received: from styx.suse.cz ([82.119.242.94]:32788 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030302AbXDCPF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 11:05:27 -0400
Subject: Re: Recursive ->i_mutex lockdep complaint
From: Miklos Szeredi <mszeredi@suse.cz>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20070403142143.GA6535@localhost.sw.ru>
References: <200703270735.l2R7Zg9t010611@shell0.pdx.osdl.net>
	 <20070403142143.GA6535@localhost.sw.ru>
Content-Type: text/plain
Date: Tue, 03 Apr 2007 17:05:20 +0200
Message-Id: <1175612720.9736.7.camel@tucsk.pomaz.szeredi.hu>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-03 at 18:21 +0400, Alexey Dobriyan wrote:
> On Mon, Mar 26, 2007 at 11:35:42PM -0800, akpm@linux-foundation.org wrote:
> > The patch titled
> >      add file position info to proc
> > has been added to the -mm tree.  Its filename is
> >      add-file-position-info-to-proc.patch
> 
> I tried to stress-test it with the following program and script and
> lockdep barfs on me reasonably quickly:

Ugh.  As I see it, this is independent from the above patch, as the same
can happen with /proc/PID/fd.  Or did I miss something?

And it seems quite benign, one of the mutexes is for the proc inode, the
other is for the pipe inode, and hopefully they haven't got anything
else to do with each other.

> It seems that lockdep is unhappy about ->i_mutex taken in
> ->release/pipe_read_release()/pipe_read_fasync()
> which is triggered from put_files_struct() in proc_readfd_common()
> 
> Now checking if giving pipe's i_mutex its own lockdep class with fix
> things.

Should help.  Although I'm wondering if it's worth bothering with, as it
doesn't seem to happen in real life for lockdep users.

Thanks,
Miklos

