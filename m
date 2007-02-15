Return-Path: <linux-kernel-owner+w=401wt.eu-S932290AbXBOJh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290AbXBOJh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 04:37:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932311AbXBOJh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 04:37:26 -0500
Received: from styx.suse.cz ([82.119.242.94]:45598 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932290AbXBOJhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 04:37:25 -0500
Date: Thu, 15 Feb 2007 10:40:53 +0100
From: Jan Kara <jack@suse.cz>
To: Frank Hartmann <soundart@gmx.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: 2.6.19.1 Oops while doing Disk IO + playing sound, 2.6.20 too
Message-ID: <20070215094053.GA28205@duck.suse.cz>
References: <877ivr6t0k.fsf@fantasio.hh.de> <20070207091841.GE24590@atrey.karlin.mff.cuni.cz> <87wt2thhux.fsf@fantasio.hh.de> <20070208093930.GB10973@duck.suse.cz> <87bqk06bhi.fsf_-_@fantasio.hh.de> <20070214143249.GE23203@duck.suse.cz> <87r6ssl3g4.fsf@fantasio.hh.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r6ssl3g4.fsf@fantasio.hh.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 15-02-07 00:33:31, Frank Hartmann wrote:
> Jan Kara <jack@suse.cz> writes:
> 
> >   Yes I see some correlation. Again it seems there is a problem with buffers
> > attached to a page which got truncated but Private flag of the page stayed.
> > It's probably not important but just out of curiosity - do you have
> > CONFIG_LBD (large block device) set? I'd just like to verify that page_bufs
> > was NULL when it was passed to walk_page_buffers().
> 
> fantasio:~/tmp/linux-2.6.20$ fgrep CONFIG_LBD .config
> # CONFIG_LBD is not set
  OK, thanks. Then I'm slightly confused as the offset 0x2d in struct
buffer_head is somewhere in b_assoc_buffers which is never dereferenced.
Can you run gdb on vmlinux from the 2.6.20 kernel and send me the output
of 'disass walk_page_buffers'? Thanks.

> >   You said 2.6.17 worked for you, didn't you? How long does it take to
> > reproduce the problem? If it is reasonably easy (e.g. a few hours), could
> > you trace back when the problem started happening? If you could narrow that
> > problem down to a single patch (using git-bisect), that would be great.
> 
> Yes I said that. At least I did not notice it happen:) 
> Reproduction seems easy. So I will try. 
   Great.

> I have some problem: I am not sufficiently familar with git!
> 
> I found http://www.kernel.org/pub/software/scm/git/docs/howto/isolate-bugs-with-bisect.txt
> Is this the way to do a git-bisect?
  Yes, that's it.

> From where do I get the 'labels' for good(2.6.17) and bad(2.6.20)?
  git bisect bad v2.6.20
  git bisect good v2.6.17

(or maybe you could start with 'git bisect bad v2.6.19' if that was also
failing for you). Git will spit out something like:

Bisecting: 9467 revisions left to test after this
[ebdea46fecae40c4d7effcd33f40918a37a1df4b] Merge branch 'devel' of master.kernel.org:/home/rmk/linux-2.6-arm

After you test kernel from the revision
'ebdea46fecae40c4d7effcd33f40918a37a1df4b', you do
  git bisect good/bad ebdea46fecae40c4d7effcd33f40918a37a1df4
and you'll get next revision to check. I hope it's clearer now.

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
