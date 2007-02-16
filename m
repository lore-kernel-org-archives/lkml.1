Return-Path: <linux-kernel-owner+w=401wt.eu-S966253AbXBPJZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966253AbXBPJZh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 04:25:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751129AbXBPJZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 04:25:37 -0500
Received: from styx.suse.cz ([82.119.242.94]:49942 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750745AbXBPJZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 04:25:36 -0500
Date: Fri, 16 Feb 2007 10:29:09 +0100
From: Jan Kara <jack@suse.cz>
To: Frank Hartmann <soundart@gmx.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: 2.6.19.1 Oops while doing Disk IO + playing sound, 2.6.20 too
Message-ID: <20070216092909.GA1711@duck.suse.cz>
References: <877ivr6t0k.fsf@fantasio.hh.de> <20070207091841.GE24590@atrey.karlin.mff.cuni.cz> <87wt2thhux.fsf@fantasio.hh.de> <20070208093930.GB10973@duck.suse.cz> <87bqk06bhi.fsf_-_@fantasio.hh.de> <20070214143249.GE23203@duck.suse.cz> <87r6ssl3g4.fsf@fantasio.hh.de> <20070215094053.GA28205@duck.suse.cz> <87mz3f9gab.fsf@fantasio.hh.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mz3f9gab.fsf@fantasio.hh.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 16-02-07 00:01:32, Frank Hartmann wrote:
> Jan Kara <jack@suse.cz> writes:
> 
> > On Thu 15-02-07 00:33:31, Frank Hartmann wrote:
> >> Jan Kara <jack@suse.cz> writes:
> >> 
> >> >   Yes I see some correlation. Again it seems there is a problem with buffers
> >> > attached to a page which got truncated but Private flag of the page stayed.
> >> > It's probably not important but just out of curiosity - do you have
> >> > CONFIG_LBD (large block device) set? I'd just like to verify that page_bufs
> >> > was NULL when it was passed to walk_page_buffers().
> >> 
> >> fantasio:~/tmp/linux-2.6.20$ fgrep CONFIG_LBD .config
> >> # CONFIG_LBD is not set
> >   OK, thanks. Then I'm slightly confused as the offset 0x2d in struct
> > buffer_head is somewhere in b_assoc_buffers which is never dereferenced.
> > Can you run gdb on vmlinux from the 2.6.20 kernel and send me the output
> > of 'disass walk_page_buffers'? Thanks.
> 
> 
> I seem to missunderstand you.
> I am running now 2.6.19., so do not wonder. 
  In your mail from February 11, you sent an oops from 2.6.20 kernel.
That's why I was interested in the 2.6.20 kernel's vmlinux. But 2.6.19.2
would be interesting too.

> Could you help out, what I do wrong?
> 
> fantasio:/home/frank/tmp/linux-2.6.19.2#   gdb vmlinux                   
> GNU gdb 6.4.90-debian
> Copyright (C) 2006 Free Software Foundation, Inc.
> GDB is free software, covered by the GNU General Public License, and you are
> welcome to change it and/or distribute copies of it under certain conditions.
> Type "show copying" to see the conditions.
> There is absolutely no warranty for GDB.  Type "show warranty" for details.
> This GDB was configured as "i486-linux-gnu"...(no debugging symbols found)
> Using host libthread_db library "/lib/tls/libthread_db.so.1".
> 
> (gdb) disass walk_page_buffers
> No symbol table is loaded.  Use the "file" command.
  Sorry, I forgot you have to have the kernel compiled with the
CONFIG_DEBUG_INFO option (in the kernel hacking section) for the above to work.
It is enough to get the vmlinux file from such compilation. You don't have
to actually run the kernel...

								Honza

-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
