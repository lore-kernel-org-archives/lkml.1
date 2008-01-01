Return-Path: <linux-kernel-owner+w=401wt.eu-S1756758AbYAARhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758AbYAARhl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 12:37:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756131AbYAARhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 12:37:31 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:40197 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754648AbYAARha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 12:37:30 -0500
Date: Tue, 1 Jan 2008 18:37:29 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-masters@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       viro@zeniv.linux.org.uk
Subject: Re: [xfs-masters] [Patch 7/8] FS: Remove 'TOPDIR' from Makefiles
Message-ID: <20080101173729.GA31575@uranus.ravnborg.org>
References: <20080101071311.GA2496@hacking> <20080101074105.GH2496@hacking> <477A7809.5000106@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <477A7809.5000106@sandeen.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 01, 2008 at 11:27:37AM -0600, Eric Sandeen wrote:
> WANG Cong wrote:
> > TOPDIR is obsolete, use objtree instead.
> > This patch removes TOPDIR from all fs/ Makefiles.
> 
> > diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> > index 49e3e7e..d1d3d49 100644
> > --- a/fs/xfs/Makefile
> > +++ b/fs/xfs/Makefile
> > @@ -1 +1 @@
> > -include $(TOPDIR)/fs/xfs/Makefile-linux-$(VERSION).$(PATCHLEVEL)
> > +include $(objtree)/fs/xfs/Makefile-linux-$(VERSION).$(PATCHLEVEL)
> 
> FWIW $(TOPDIR) is already banished from the latest xfs build code:
> 
Good - I will ignore the xfs bits.

> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/Makefile
> 
> and the patch is in -mm too via git:
> 
> http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc6/2.6.24-rc6-mm1/broken-out/git-xfs.patch

You can do this simpler:
+EXTRA_CFLAGS +=	 -I$(src) -I$(src)/linux-2.6 -funsigned-char
+
+XFS_LINUX := linux-2.6
+
+ifeq ($(CONFIG_XFS_DEBUG),y)
+	EXTRA_CFLAGS += -g
+endif
+

like this:

ccflags-y := -I$(src) -I$(src)/linux-2.6 -funsigned-char
ccflags-$(CONFIG_XFS_DEBUG) += -g

XFS_LINUX := linux-2.6

> p.s. what is $(objtree) exactly?  I don't see it mentioned in
> Documentation/kbuild except as one line in an example... I thought
> $(obj) and $(src) should be used outside of the core kbuild
> infrastructure, and in this case wouldn't it be $(src) anyway?

$(objtree) specify the build directory and is only rarely used.
Half of the current users are buggy and I should fix it one day.

	Sam 
