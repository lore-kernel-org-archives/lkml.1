Return-Path: <linux-kernel-owner+w=401wt.eu-S1755389AbYDHUsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbYDHUsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 16:48:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752972AbYDHUr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 16:47:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33667 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752388AbYDHUrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 16:47:51 -0400
Date: Tue, 8 Apr 2008 13:46:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org,
       samr <sam@ravnborg.org>
Subject: Re: [PATCH] documentation: build source files in Documentation
 sub-dir
Message-Id: <20080408134613.a047a7b6.akpm@linux-foundation.org>
In-Reply-To: <20080403124529.3f2efb79.randy.dunlap@oracle.com>
References: <20080403124529.3f2efb79.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Apr 2008 12:45:29 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:

> Currently source files in the Documentation/ sub-dir can easily bit-rot
> since they are not generally buildable, either because they are hidden
> in text files or because there are no Makefile rules for them.
> This needs to be fixed so that the source files remain usable and good
> examples of code instead of bad examples.
> 
> Add the ability to build source files that are in the Documentation/ dir.
> Add to Kconfig as "BUILD_DOCSRC" config symbol.
> 
> Use "CONFIG_BUILD_DOCSRC=1 make ..." to build objects from the
> Documentation/ sources.  Or enable BUILD_DOCSRC in the *config system.
> 
> The Makefiles use $objdir/usr/include for header files, so doing
> "make headers_install" is required.  This is done for you if you enable
> CONFIG_HEADERS_CHECK=y.
> 
> Note: needs documentation-move-spidev_fdx-example-to-its-own-source-file.patch
> from -mm patchset.

argh, I'm getting several warnings and at least two build errors from this.
One is:

In file included from /usr/src/devel/usr/include/linux/netlink.h:5,
                 from /usr/src/devel/usr/include/linux/genetlink.h:4,
                 from Documentation/accounting/getdelays.c:26:
/usr/src/devel/usr/include/linux/types.h:166: error: expected specifier-qualifier-list before '__kernel_daddr_t'

(i386 allmodconfig).

I think I'll disable this patch for now..
