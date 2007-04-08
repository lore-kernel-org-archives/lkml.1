Return-Path: <linux-kernel-owner+w=401wt.eu-S1752795AbXDHFDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbXDHFDT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 01:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689AbXDHFDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 01:03:19 -0400
Received: from 2-1-3-15a.ens.sth.bostream.se ([82.182.31.214]:50412 "EHLO
	zoo.weinigel.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbXDHFDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 01:03:05 -0400
X-Greylist: delayed 1837 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Apr 2007 01:03:04 EDT
To: johnrobertbanks@fastmail.fm
Cc: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>,
       "H. Peter Anvin" <hpa@zytor.com>, "Ignatich" <ignatich@gmail.com>,
       reiserfs-list@namesys.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: Reiser4. BEST FILESYSTEM EVER.
References: <46157B5B.5000602@gmail.com>
	<1175817921.18400.1183285196@webmail.messagingengine.com>
	<461592FB.5060507@zytor.com>
	<1175819681.20754.1183287946@webmail.messagingengine.com>
	<461596DE.2020802@zytor.com>
	<1175823288.25662.1183293506@webmail.messagingengine.com>
	<4615C780.5040407@zytor.com>
	<1175833931.8916.1183307802@webmail.messagingengine.com>
	<20070407191715.GG3510@csclub.uwaterloo.ca>
	<1175993097.32498.1183512070@webmail.messagingengine.com>
From: Christer Weinigel <christer@weinigel.se>
Organization: Weinigel Ingenjorsbyra AB
Date: 08 Apr 2007 06:32:26 +0200
In-Reply-To: <1175993097.32498.1183512070@webmail.messagingengine.com>
Message-ID: <m3zm5jebad.fsf@zoo.weinigel.se>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

johnrobertbanks@fastmail.fm writes:

> Lennart. Tell me again that these results from 
> 
> http://linuxhelp.150m.com/resources/fs-benchmarks.htm and
> http://m.domaindlx.com/LinuxHelp/resources/fs-benchmarks.htm
> 
> are not of interest to you. I still don't understand why you have your
> head in the sand.

Oh, for fucks sake, stop sounding like a broken record.  You have
repeated the same totally meaningless statistics more times than I
care to count.  Please shut the fuck up.

As you discovered yourself (even though you seem to fail to understand
the significance of your discovery), bonnie writes files that consist
of mostly zeroes.  If your normal use cases consist of creating a
bunch of files containing zeroes, reiser4 with compression will do
great.  Just lovely.  Except that nobody sane would store a lot of
files containing zeroes, except an an excercize in mental
masturbation.  So the two bonnie benchmarks with lzo and gzip are
totally meaningless for any real life usages.

As for the amount of disk needed to store three kernel trees, the
figures you quote show that Reiser4 does tail combining where the tail
of multiple files are stored in one disk block.  A nice trick that
seems save you about 15% disk space compared to ext3.  Now you have to
realise what that means, it means that if the disk block containing
those tails (or any metadata pointing at that block) gets corrupted,
instead of just losing one disk block for one file, you will have lost
the tail for all the files sharing that disk block.  Depending on your
personal prioritites, saving 15% of the space may be worth the risk to
you, or maybe not.  Personally, for the only disk I'm short on space
on, I mostly store flac encoded images of my CD collection, and saving
2kByte out of every 300MByte disk simply doesn't make any difference,
and I much prefer a stable file system that I can trust not to lose my
data.  You might make different choices.

The same goes for just about every feature that you tout, it has its
advantages, and it has its disadvantages.  Doing compression on data
is great if the data you store is compressible, and sucks if it isn't.
Doing compression on each disk block and then packing multiple
compressed blocks into each physical disk block will probably save
some space if the data is compressible, but at the same time it means
that you will spend a lot of CPU (and cache footprint) compressing and
uncompressing that data.  On a single user system where the CPU is
mostly idle it might not make much of a difference, on a heavily
loaded multiuser system it might do.

Logs can be compressed quite well using a block based compression
scheme, but the logs can be compressed even better by doing
compression on the whole file with gzip.  So what's the best choice,
to do transparent compression on the fly giving ok compression or
teaching the userspace tools to do compression of old logs and get
really good compression?  Or maybe disk space really isn't that
important anyway and the best thing is to just leave the logs
uncompressed.

Another example: one of the things Reiser3 is supposed to be really
good for is storing an INN news spool, doing tail merging of lots of
individual files containing articles gives a great space saving, and
since it's just a news spool, reliability in face of a system crashes
really don't matter all that much.  On the other hand, INN's Cyclic
News File System running on top of ext2 is probably an even better
choice in that case.  What do you want to use?

What I want to get at is that you can troll the mailing lists (and
crossposting stupid inflammatory material with an inane subject to a
bunch of mailing lists the way you have done definitely is trolling)
trying to say that whatever you're trying to sell is the best, but at
the end, if a file system is better or not is a lot more complex than
quoting just one benchmark (which, once again, is meaningless,
compressing a lot of zeroes is simple and really does not tell you
anything about real world usages).  And there are other considerations
too, even if Reiser4 would be the best thing since sliced breadd, can
I trust Hans Reiser to support Reiser4 for the next five years?  Or
will he drop support for Reiser4 the same way he dropped support for
the old Reiser3 when Reiser4 came along?  Or will he drop Reiser4 when
the grant to do Reiser 4 development expires?

  /Christer

-- 
"Just how much can I get away with and still go to heaven?"

Christer Weinigel <christer@weinigel.se>  http://www.weinigel.se
