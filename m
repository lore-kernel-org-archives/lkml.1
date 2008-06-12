Return-Path: <linux-kernel-owner+w=401wt.eu-S1757150AbYFLVFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150AbYFLVFq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 17:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754211AbYFLVFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 17:05:36 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:37512 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395AbYFLVFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 17:05:35 -0400
Date: Thu, 12 Jun 2008 23:06:15 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeff Dike <jdike@addtoit.com>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kbuild breaks um - fails to find util when linking
Message-ID: <20080612210615.GA7558@uranus.ravnborg.org>
References: <20080610190307.GA15983@uranus.ravnborg.org> <20080611154816.GA8167@c2.user-mode-linux.org> <20080612180859.GA2271@uranus.ravnborg.org> <20080612201315.GA10879@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080612201315.GA10879@c2.user-mode-linux.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 04:13:15PM -0400, Jeff Dike wrote:
> On Thu, Jun 12, 2008 at 08:08:59PM +0200, Sam Ravnborg wrote:
> > Following patch will result in a building ARCH=um kernel.
> > If it works I dunno.
> 
> You can just try running it.  Given its behavior with this patch so
> far, it would be an excellent sign for it to figure out that it has no
> root filesystem and panic.
> 
> Anyway, I can't get it to give me a UML binary.  I see this in the
> build output (and V=3 doesn't make it any more verbose):
> 
> 
> 	  CHK     include/linux/compile.h
> 	  LINK linux
> 
> 	Compilation finished at Thu Jun 12 16:11:15
> 
> but no linux or vmlinux in my output directory.

So appearantly kbuild thinks you have a vmlinux
so no need to relink.
And the line "LINK linux" implies this as well.

Please double check that you do not have a vmlinux,
and try V=2" to see where LINK picks up the vmlinux.

My build finised:
$ ./linux
 ./linux: /usr/lib/libc.so.1: bad ELF interpreter: No such file or directory

So I will take an additional look tomorrow.

	Sam
