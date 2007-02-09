Return-Path: <linux-kernel-owner+w=401wt.eu-S1946009AbXBIWLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946009AbXBIWLr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 17:11:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946120AbXBIWLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 17:11:47 -0500
Received: from smtp.osdl.org ([65.172.181.24]:49980 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946009AbXBIWLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 17:11:46 -0500
Date: Fri, 9 Feb 2007 14:11:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Alon Bar-Lev" <alon.barlev@gmail.com>
Cc: linux-kernel@vger.kernel.org, bwalle@suse.de, rmk+lkml@arm.linux.org.uk
Subject: Re: [PATCH 00/34] __initdata cleanup
Message-Id: <20070209141137.76013fa9.akpm@linux-foundation.org>
In-Reply-To: <9e0cf0bf0702091348v226ea8acra42bcf4463e9cdc9@mail.gmail.com>
References: <200702091711.34441.alon.barlev@gmail.com>
	<20070209170005.GA8500@osiris.ibm.com>
	<Pine.LNX.4.64.0702091831150.14457@scrub.home>
	<20070209133355.d5df1ab5.akpm@linux-foundation.org>
	<9e0cf0bf0702091348v226ea8acra42bcf4463e9cdc9@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Feb 2007 23:48:36 +0200
"Alon Bar-Lev" <alon.barlev@gmail.com> wrote:

> On 2/9/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > If we really do have a problem here it'd be better to fix it in some
> > central and global fashion: either by ensuring that each architecture's
> > startup code will zero this memory or by some compiler/linker option such
> > as -fno-common.
> 
> Great,
> But what about the variables that are not in global scope?
> As I understand from init.h description:
> "Don't forget to initialize data not at file scope, i.e. within a function,
> as gcc otherwise puts the data into the bss section and not into the init
> section."
> 

It could be that this is referring to a toolchain which we don't use any
more.  That comment has been there for at least seven years.

This:

--- a/fs/open.c~a
+++ a/fs/open.c
@@ -223,6 +223,8 @@ static long do_sys_truncate(const char _
 	struct inode * inode;
 	int error;
 
+	static char blobwozzle[100] __initdata;
+
 	error = -EINVAL;
 	if (length < 0)	/* sorry, but loff_t says... */
 		goto out;
_

puts the array in .init.data on my fairly old toolchain.
