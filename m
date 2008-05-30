Return-Path: <linux-kernel-owner+w=401wt.eu-S1754695AbYE3VBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbYE3VBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 17:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753131AbYE3VBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 17:01:11 -0400
Received: from xenotime.net ([66.160.160.81]:41976 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753123AbYE3VBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 17:01:10 -0400
Date: Fri, 30 May 2008 14:14:47 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Paul Jackson <pj@sgi.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Randy Dunlap" <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] doc: document the kernel-doc conventions for kernel
 hackers
Message-Id: <20080530141447.6147d66c.rdunlap@xenotime.net>
In-Reply-To: <20080530203442.29524.9752.sendpatchset@polaris-admin.engr.sgi.com>
References: <20080530203442.29524.9752.sendpatchset@polaris-admin.engr.sgi.com>
Organization: YPO4
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 May 2008 13:34:42 -0700 Paul Jackson wrote:

> From: Paul Jackson <pj@sgi.com>
> 
> Provide documentation of the kernel-doc documentation conventions
> oriented to kernel hackers.
> 
> Since I figure that there will be more people reading this
> kernel-doc-nano-HOWTO.txt file who are kernel developers focused
> on the rest of the kernel, than there will be readers of this
> file who are documentation developers extracting that embedded
> kernel-doc documentation, I have taken the liberty of making
> the new section added here:
> 
>   How to format kernel-doc comments
> 
> the first section of the kernel-doc-nano-HOWTO.txt file.
> 
> This first section is intended to introduce, motivate and
> provide basic usage of the kernel-doc mechanism for kernel
> hackers developing other portions of the kernel.
> 
> Signed-off-by: Paul Jackson <pj@sgi.com>
> Cc: Randy Dunlap <rdunlap@xenotime.net>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> 
> ---
>  Documentation/kernel-doc-nano-HOWTO.txt |   99 ++++++++++++++++++++++++++++++++
>  1 file changed, 99 insertions(+)
> 
> --- linux-2.6.orig/Documentation/kernel-doc-nano-HOWTO.txt	2008-05-30 08:47:13.000000000 -0700
> +++ linux-2.6/Documentation/kernel-doc-nano-HOWTO.txt	2008-05-30 13:31:07.111325343 -0700
> @@ -1,6 +1,105 @@
>  kernel-doc nano-HOWTO
>  =====================
>  
> +How to format kernel-doc comments
> +---------------------------------
> +
> +In order to provide an embedded, 'C' friendly, easy to maintain,
> +but consistent and extractable documentation of the functions and
> +data structures in the Linux kernel, the Linux kernel has adopted
> +a consistent style for documenting functions and their parameters,
> +and structures and their members.
> +
> +The format for this documentation is called the kernel-doc format.
> +It as documented in this Documentation/kernel-doc-nano-HOWTO.txt file.
> +
> +This style embeds the documentation within the source files, using
> +a few simple conventions.  The scripts/kernel-doc perl script, some
> +SGML templates in Documentation/DocBook, and other tools understand
> +these conventions, and are used to extract this embedded documentation
> +into various documents.
> +
> +In order to provide good documentation of kernel functions and data
> +structures, please use the following conventions to format your
> +kernel-doc comments in Linux kernel source.
> +
> +We definitely need kernel-doc formatted documentation for functions
> +that are exported to loadable modules using EXPORT_SYMBOL.
> +
> +We also look to provide kernel-doc formatted documentation for
> +functions externally visible to other kernel files (not marked
> +"static").
> +
> +We also recommend providing kernel-doc formatted documentation
> +for private (file "static") routines, for consistency of kernel
> +source code layout.  But this is lower priority and at the
> +discretion of the MAINTAINER of that kernel source file.
> +
> +Data structures visible in kernel include files should also be
> +documented using kernel-doc formatted comments.
> +
> +The opening comment mark "/**" is reserved for kernel-doc comments.
> +Only comments so marked will be considered by the kernel-doc scripts,
> +and any comment so marked must be in kernel-doc format.  Do not use
> +"/**" to be begin a comment block unless the comment block contains
> +kernel-doc formatted comments.  The closing comment marker for
> +kernel-doc comments can be either "*/" or "**/".
> +
> +Kernel-doc comments should be placed just before the function
> +or data structure being describe.

                           described.

> +
> +Example kernel-doc function comment:
> +
> +/**
> + * foobar() - short function description of foobar
> + * @arg1:	Describe the first argument to foobar.
> + * @arg2:	Describe the second argument to foobar.
> + *              One can provide multiple line descriptions
> + *              for arguments.
> + *
> + * A longer description, with more discussion of the function foobar()
> + * that might be useful to those using or modifying it.  Begins with
> + * empty comment line, and may include additional embedded empty
> + * comment lines.
> + *
> + * The longer description can have multiple paragraphs.
> + **/
> +
> +The first line, with the short description, must be on a single line.
> +
> +The @argument descriptions must begin on the very next line following
> +this opening short function description line, with no intervening
> +empty comment lines.
> +
> +Example kernel-doc data structure comment.
> +
> +/**
> + * struct blah - the basic blah structure
> + * @mem1:       describe the first member of struct blah

Use tab or space(s) after @memN: consistently, please.

> + * @mem2:	describe the second member of struct blah,
> + *		perhaps with more lines and words.
> + *
> + * Longer description of this structure.
> + **/
> +
> +The kernel-doc function comments describe each parameter to the
> +function, in order, with the @name lines.
> +
> +The kernel-doc data structure comments describe each structure member
> +in the data structure, with the @name lines.
> +
> +The longer description formatting is "reflowed", loosing your line

                                                    losing

> +breaks.  So presenting carefully formatted lists within these
> +descriptions won't work so well; derived documentation will loose

                                                               lose

> +the formatting.

Yes, that comment is correct.  And unfortunate.  We need some way to provide
a simple formatted list.

> +
> +See the section below "How to add extractable documentation to your
> +source files" for more details and notes on how to format kernel-doc
> +comments.
> +
> +Components of the kernel-doc system
> +-----------------------------------
> +
>  Many places in the source tree have extractable documentation in the
>  form of block comments above functions.  The components of this system
>  are:


Please fix the few typos and add Acked-by: Randy Dunlap <rdunlap@xenotime.net>.

Thanks, Paul.

---
~Randy
"He closes his eyes and drops the goggles.  You can't get hurt
by looking at a bitmap.  Or can you?"
