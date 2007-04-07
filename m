Return-Path: <linux-kernel-owner+w=401wt.eu-S965197AbXDGDyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965197AbXDGDyy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 23:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbXDGDyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 23:54:54 -0400
Received: from DELFT.AURA.CS.CMU.EDU ([128.2.206.88]:39798 "EHLO
	delft.aura.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbXDGDyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 23:54:52 -0400
X-Greylist: delayed 1442 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Apr 2007 23:54:52 EDT
Date: Fri, 6 Apr 2007 23:30:49 -0400
To: johnrobertbanks@fastmail.fm
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Reiser4. BEST FILESYSTEM EVER.
Message-ID: <20070407033049.GI4228@delft.aura.cs.cmu.edu>
Mail-Followup-To: johnrobertbanks@fastmail.fm, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
References: <46157B5B.5000602@gmail.com> <1175817921.18400.1183285196@webmail.messagingengine.com> <461592FB.5060507@zytor.com> <1175819681.20754.1183287946@webmail.messagingengine.com> <461596DE.2020802@zytor.com> <1175823288.25662.1183293506@webmail.messagingengine.com> <4615C780.5040407@zytor.com> <1175833931.8916.1183307802@webmail.messagingengine.com> <20070406152119.GC4228@delft.aura.cs.cmu.edu> <1175914056.9653.1183426876@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1175914056.9653.1183426876@webmail.messagingengine.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Jan Harkes <jaharkes@cs.cmu.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Since you decide to publically respond to a private email, but not only
you did not 'discuss' anything I wrote and in fact cut out most of the
useful information in my reply I guess I will have to repeat my
observations.

Once I send out this email, I'll just add you to my friendly killfile
(as well as this thread's subject/msgids) so don't bother continuing you
one-sided 'discussions' on this topic.

On Fri, Apr 06, 2007 at 07:47:36PM -0700, johnrobertbanks@fastmail.fm wrote:
> > Do you really have to repeat the results in every email you sent?
> 
> Damn, I did it again. WHY DO YOU CARE?

Because I saw them the first time around. And although the performance
difference on those micro benchmarks seems quite impressive, I'm not
convinced.

> Look, its simple, I am (among other things) discussing these results, so
> people need to see them.

However, you do not discuss, you just repeat, and repeat, and repeat.
But for what reason. Do you want an actual discussion, or do you hate
the reiserfs developers so much that you want to antagonize any and all
other Linux file systems developers?

> > > Don't you agree, that "If they are accurate,.... THEN they are obviously
> > > very relevant."
> > 
> > Not everyone does. I care mostly about reliability and availability
> > neither of which are shown by your results.
> 
> Actually, to some extent, bonnie++ tests the reliability of the
> filesystem, eg, NTFS-3g usually fails.
> 
> By the way, I have pulled the plug on my REISER4 system, a number of
> times now, and it recovers without problem.

Very nice for you. I guess you have also not been hit by out of memory
conditions or failing partial writes. So I guess we can ignore the patch
that was just sent a day or two ago to the mailing list because you
succesfully pulled the plug, a number of times at that.

> > > I have set up a Reiser4 partition with gzip compression, here is the
> > > difference in disk usage of a typical Debian installation on two 10GB
> > > partitions, one with Reiser3 and the other with Reiser4.
> > > 
> > > debian:/# df
> > > Filesystem           1K-blocks      Used Available Use% Mounted on
> > > /dev/sda3             10490104   6379164   4110940  61% /3
> > > /dev/sda7              9967960   2632488   7335472  27% /7
> > ...
> > > Partition 3 is Reiser3 -- uses 6.4 GB.
> > > Partition 7 is Reiser4 -- uses 2.6 GB.
> > > 
> > > So Reiser4 uses 2.6 GB to store the (typical) data that it takes Reiser3
> > > 6.4 GB to store (note it would take ext2/3/4 some 7 GB to store the same
> > > info).
> > 
> > Wow, consider me totally and completely, unimpressed.
> > 

Here is the part of my email that you seemed to totally ignore,

    You've just saved yourself $3.80, now go get yourself a latte.
    (see. http://tomayko.com/weblog/2006/09/11/that-dilbert-cartoon)

    Seriously, disk storage is getting less expensive all the time, you can
    already buy a 250GB SATA drive for $70. Also, compression doesn't help
    once you store already compressed data such as jpeg images, mp3 files,
    or mpeg2/4/divx video files. Not only are the savings non-existant, but
    we still end up with the disadvantage that corruption propagates to
    multiple files because of the compression in the file system.

    And if it doesn't propagate across multiple files, the compression can't
    be all that good since it can't benefit as much from similarity between
    files. So if that is the case and you really want to save diskspace you
    almost have to look at read-only compressed filesystems such as cramfs,
    squashfs, zisofs, cloop and various other variants in combination with
    a unionfs overlay to get read/write functionality.

    But in the end everything is a tradeoff. You can save diskspace, but
    increase the cost of corruption. Use a better compression algorithm, but
    that uses more CPU or which is visible in performance of the
    application. This can be offset by caching more, and being lazier with
    writebacks, but that hurts on-disk consistency, creates more memory
    pressure (more swapout/paging) and generally slows down other
    applications that aren't actually accessing the disk. Having a fast
    multi-core cpu and lots of memory helps a lot, but at some point what
    tradeoff did we just make, we saved a couple of dollars not having to
    buy a larger disk, but we spend considerably more on the more expensive
    cpu and memory.

> Wow, consider me totally impressed by your AMAZING BIAS.
> 
> Would you like to tell me why you are SO BIASED against REISER4.

And that is the reponse I get, I thought you wanted discussion, but
clearly you don't care about any meaningful discussion. Your goal seems
to be to make sure that other developers end up ignoring any thread that
has reiser in the subject. And even if they are not biased and welcome a
discussion, you will just call them out on it, because clearly if they
want to discuss something they aren't totally with it, so they have to
be totally BIASED against REISER4.

At least it looks like we agree on something, I think.

Jan

