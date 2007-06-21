Return-Path: <linux-kernel-owner+w=401wt.eu-S1754085AbXFUQJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbXFUQJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 12:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753069AbXFUQJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 12:09:03 -0400
Received: from gate.in-addr.de ([212.8.193.158]:46770 "EHLO mx.in-addr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755524AbXFUQJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 12:09:00 -0400
Date: Thu, 21 Jun 2007 18:08:40 +0200
From: Lars Marowsky-Bree <lmb@suse.de>
To: Pavel Machek <pavel@ucw.cz>, Crispin Cowan <crispin@novell.com>
Cc: Greg KH <greg@kroah.com>, Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation, pathname matching
Message-ID: <20070621160840.GA20105@marowsky-bree.de>
References: <20070514110607.549397248@suse.de> <200706090003.57722.agruen@suse.de> <20070609001703.GA17644@kroah.com> <466C303E.5010304@novell.com> <20070615165054.GA11345@kroah.com> <20070615200623.GA2616@elf.ucw.cz> <20070615211157.GB7337@kroah.com> <46732124.80509@novell.com> <20070616000251.GG2616@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070616000251.GG2616@elf.ucw.cz>
X-Ctuhulu: HASTUR
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've caught up on this thread with growing disbelief while reading the
mails, so much that I've found it hard to decide where to reply to.

So people are claiming that AA is ugly, because it introduces pathnames
and possibly a regex interpreter. Ok, taste differs. We've got many
different flavours of filesystems in the kernel because of that.

However, the suggested cure makes me cringe.

You're saying that relabeling file(s) from user-space after a rename is
a possible solution.

This breaks POSIX - renames must be atomic. It is possibly insecure; if
this is fixed by making a rename automatically default to restrictive
permissions, it'll be even more inconvenient. It will break applications
which expect to be able to access the file(s) immediately after a
rename. It is slow, and can possibly cause a lot of disk access.
Possibly over NFS or via slow disks. By going through user-space - which
could block and introduce all sorts of memory deadlocks (compared to
that deadlock, a regex is harmless.) (I also wonder how you propose to
relabel files on a r/o mount if the policy changes, btw; or if the NFS
mount is made available on several nodes w/different permissions.) AA
only enforces user-space defined policy - the argument that policy
doesn't belong into the kernel is bull. Adding a wrapper to glibc to
block until relabeling is complete?

"Let's first do the implementation and later worry about performance."?
"The timing window is neglible."? "30 minutes during installation does
not seem silly."?

You _must_ be kidding. The cure is worse than the problem.

If that is the only way to implement AA on top of SELinux - and so far,
noone has made a better suggestion - I'm convinced that AA has technical
merit: it does something the on-disk label based approach cannot handle,
and for which there is demand.

The code has improved, and continues to improve, to meet all the coding
style feedback except the bits which are essential to AA's function
(like the pathname lookup and the regex parser; though I'm sure that in
particular the later one could be swapped for a less complex matcher as
well). It certainly isn't worse than many other areas of the kernel.

You're pointing to each other's opposition to the features - that, my
dear gentlemen, is a circular argument. One of you could readily break
the chain.

This is trying to get rid of AA for the sake of it, masquerading as
technical reasons. At least fucking admit it. Don't lie. This is
distasteful.


Regards,
    Lars

-- 
Teamlead Kernel, SuSE Labs, Research and Development
SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG Nürnberg)
"Experience is the name everyone gives to their mistakes." -- Oscar Wilde

