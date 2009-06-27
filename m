Return-Path: <linux-kernel-owner+w=401wt.eu-S1754819AbZF0Ho6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbZF0Ho6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 03:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbZF0Hot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 03:44:49 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:52032 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbZF0Hos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 03:44:48 -0400
Date: Sat, 27 Jun 2009 09:47:06 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "H. Peter Anvin" <hpa@zytor.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>, benh@kernel.crashing.org,
       paulus@samba.org
Subject: Re: [PATCH] gitignore: add *.bz2 and *.cpio to top-level; clean up usr/
Message-ID: <20090627074706.GA30839@uranus.ravnborg.org>
References: <200906202056.n5KKuc9o013960@tazenda.hos.anvin.org> <1245569547.2480.18.camel@ht.satnam> <20090626222112.GB27048@uranus.ravnborg.org> <4A454A69.4050301@zytor.com> <20090626224321.GA27310@uranus.ravnborg.org> <4A4550FD.7020806@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4550FD.7020806@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 26, 2009 at 03:51:41PM -0700, H. Peter Anvin wrote:
> Sam Ravnborg wrote:
> > 
> > My concern is that we may decide to carry files in certain formats
> > in the kernel source.
> > And I see a tendency to add more and more file extensions to the
> > top-level .gitignore file.
> > 
> > It is fine as long as this is files that are:
> > 1) either generated in a lot of places
> > 2) or generated in the top-level directory
> > 
> > But files that we generate in a few arch/*/boot/ directories
> > does not belong in the top-level .gitignore file.
> > We should keep the ignore rules close to where they apply,
> > even if this may cause us to add a few more lines
> > to the relevant .gitignore files.
> > 
> 
> Honestly, I think this is ridiculous.  A single well-maintained
> .gitignore file is a *service* to the whole tree, and the last thing we
> want is git to behave differently in different subdirectories.
> 
> It is *much better* to have global rules, and add exceptions out in the
> leaves of the tree where they apply.  The question that the global
> .gitignore should answer is:
> 
> "If I have a file of type X, is the user *likely* to want to actually
> want it in the tree?"
> 
> In the case of *.gz *.bz2 *.lzma or *.cpio, I think the answer is a
> resounding "no".  Almost every architecture uses compressed files at
> some stage of its boot, and it's *always* a generated file.  A
> non-generated file is probably a patch being handled by a developer, not
> something that is meant to be in the tree.

Convinced with respect to the *.gz *.bz2 *.lzma or *.cpio extensions.
But I will continue to be reluctant to adding global entries,
as I have been beated from time to time by something
that was ignored but should not have been so.

Jaswinder - please resend your patch that
add these 4 extensions to the top-level .gitignore
and remove them from .gitignore in the rest of the tree.

Thanks,
	Sam
