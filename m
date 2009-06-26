Return-Path: <linux-kernel-owner+w=401wt.eu-S1756622AbZFZW7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622AbZFZW7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 18:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753279AbZFZW7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 18:59:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46926 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbZFZW7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 18:59:08 -0400
Message-ID: <4A4550FD.7020806@zytor.com>
Date: Fri, 26 Jun 2009 15:51:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>, benh@kernel.crashing.org,
       paulus@samba.org
Subject: Re: [PATCH] gitignore: add *.bz2 and *.cpio to top-level; clean up
 usr/
References: <200906202056.n5KKuc9o013960@tazenda.hos.anvin.org> <1245569547.2480.18.camel@ht.satnam> <20090626222112.GB27048@uranus.ravnborg.org> <4A454A69.4050301@zytor.com> <20090626224321.GA27310@uranus.ravnborg.org>
In-Reply-To: <20090626224321.GA27310@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> 
> My concern is that we may decide to carry files in certain formats
> in the kernel source.
> And I see a tendency to add more and more file extensions to the
> top-level .gitignore file.
> 
> It is fine as long as this is files that are:
> 1) either generated in a lot of places
> 2) or generated in the top-level directory
> 
> But files that we generate in a few arch/*/boot/ directories
> does not belong in the top-level .gitignore file.
> We should keep the ignore rules close to where they apply,
> even if this may cause us to add a few more lines
> to the relevant .gitignore files.
> 

Honestly, I think this is ridiculous.  A single well-maintained
.gitignore file is a *service* to the whole tree, and the last thing we
want is git to behave differently in different subdirectories.

It is *much better* to have global rules, and add exceptions out in the
leaves of the tree where they apply.  The question that the global
.gitignore should answer is:

"If I have a file of type X, is the user *likely* to want to actually
want it in the tree?"

In the case of *.gz *.bz2 *.lzma or *.cpio, I think the answer is a
resounding "no".  Almost every architecture uses compressed files at
some stage of its boot, and it's *always* a generated file.  A
non-generated file is probably a patch being handled by a developer, not
something that is meant to be in the tree.

I'm not saying we wouldn't *ever* want to have compressed binary blobs
in the tree -- there are actually a handful of reasons to do so -- but
*those are the exceptions*, and therefore should be using !-rules in
their respective .gitignores, instead of requiring that the entire tree
suffers from less sensible defaults.

	-hpa
