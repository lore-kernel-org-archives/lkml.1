Return-Path: <linux-kernel-owner+w=401wt.eu-S1765576AbXHDSyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765576AbXHDSyd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 14:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765083AbXHDSyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 14:54:25 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:38123
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759337AbXHDSyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 14:54:24 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Greg KH <gregkh@suse.de>
Subject: Re: Documentation of kernel messages (Summary)
Date: Sat, 4 Aug 2007 14:54:15 -0400
User-Agent: KMail/1.9.6
Cc: Randy Dunlap <rdunlap@xenotime.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Theodore Tso <tytso@mit.edu>, leoli@freescale.com,
       Gerrit Huizenga <gh@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Kunai, Takashi" <kunai@linux-foundation.jp>,
       holzheu@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, lf_kernel_messages@linux-foundation.org,
       mtk-manpages@gmx.net, jack@suse.cz, pavel@ucw.cz, tim.bird@am.sony.com,
       arjan@infradead.org, sam@ravnborg.org, jengelh@computergmbh.de,
       joe@perches.com, auke-jan.h.kok@intel.com, hansendc@us.ibm.com,
       davem@davemloft.net, Valdis.Kletnieks@vt.edu, kenistoj@us.ibm.com,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       linux-doc@vger.kernel.org
References: <E1I7wsz-0007oJ-DE@w-gerrit.beaverton.ibm.com> <200708031432.05714.rob@landley.net> <20070804035206.GB23330@suse.de>
In-Reply-To: <20070804035206.GB23330@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708041354.17653.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 August 2007 10:52:06 pm Greg KH wrote:
> On Fri, Aug 03, 2007 at 03:32:04PM -0400, Rob Landley wrote:
> > These days I'm trying to create an html index that links into
> > Documentation in a coherent order (with categories and everything), and
> > using automated tools to detect files that aren't linked to, or links
> > that point to a file that isn't there anymore.  This is obviously still a
> > work in progress, but I think it's a better approach.
>
> Better than cleaning up what we have in the kernel source tree?

Yes, I just said that.

> Why not work on that first, then the "automated" type stuff would be much
> easier to do later, right?

How does an automated 404 checker that identifies files nothing's linking to 
get easier if the source files are in a different order?  They could be 
alphabetical in one big directory and that would work the same.

Moving Documentation around is pointless churn that does nothing to prevent 
you from adding language directories to the top level on a whim, as if there 
were only two instead of (as I pointed out last message), several dozen.  
(While Randy Dunlap's poking me to resubmit my patch to group the 
architecture documentation into an architecture subdirectory, you're adding 
language directories to the top level instead of in their own subdirectory.)

Documentation doesn't even cross-link to the output of make htmldocs (which 
has its own structure imposed on it due to being extracted from the kernel 
sources).  The kernel tarball has _two_ documentation sources that don't 
significantly cross-reference each other, and Rusty just submitted "make 
Preparation!" for lguest that's totally unrelated to either of them (and 
starts from a README file buried in the source code).  None of this links to 
the menuconfig help entries, and the only reference in Documentation/ 
to "make help" is in Documentation/kbuild/makefiles.txt which explains that 
its purpose is to list the available architecture targets (something it does 
not, in my experience, actually do).

The idea that the kernel Documentation directory is the master repository of 
kernel documentation is an unworkable fantasy.  The Documentation directory 
cannot index for all the kernel documentation resources out on the web, 
because it's in text not html.  Documentation was created on the assumption 
that it would contain all interesting resources, as text files, but that 
doesn't match reality.  Documentation is merely one resource among many, and 
to link _out_ you need HTML.

Some of the resources out there are organized chronologically, such as the 
Linux Journal archives http://www.linuxjournal.com/xstatic/magazine/archives, 
the Ottawa Linux Symposium papers (http://kernel.org/doc/ols), or the 
kernel-traffic archives 
http://www.kernel-traffic.org/kernel-traffic/archives.html.  Some have their 
own indexes, such as the Linux Weekly News kernel articles 
http://lwn.net/Kernel/Index/ and the Linux Device Drivers book 
http://lwn.net/Kernel/LDD3/.  Some are random bits picked out of developer 
blogs, found with google, reasonably coherent articles on wikipedia.  Some 
are huge self-contained lumps on specific topics such as Mel Gorman's mm 
documentation or lots of the embedded stuff.

So no matter what reorganization I do to Documentation, its structure (or lack 
thereof) is incidental to coherently indexing most of the kernel 
documentation that's out there.  (Right now the best index is "google" but 
that's only useful if you know what questions to ask.  But getting up-to-date 
versions of Documentation and the output of make htmldocs on the web lets 
google find it.  (Last year, back when I was still working on BusyBox, I did 
a google trawl for ext2 documentation to replace the horrible mke2fs busybox 
used to have, and the first three pages of hits did _NOT_ include a copy of 
Documentation/filesystems/ext2.txt.  Ironically, if you google for "ext2 
documentation" today the sixth hit is the unfinished ext2 documentation I'd 
just started to write before I found Documentation/filesystems/ext2.txt.)

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
