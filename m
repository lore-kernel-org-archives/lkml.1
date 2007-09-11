Return-Path: <linux-kernel-owner+w=401wt.eu-S1762353AbXIKG1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762353AbXIKG1e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 02:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966151AbXIKGSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 02:18:31 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:51802 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966382AbXIKGS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 02:18:29 -0400
Date: Tue, 11 Sep 2007 08:19:52 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: pradeep singh rautela <rautelap@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Q]Adding src files to 2.6.18 kernel and build failure query
Message-ID: <20070911061952.GA3429@uranus.ravnborg.org>
References: <6bc632150709100905y7c5c2camaa0044cf6fa09ea2@mail.gmail.com> <20070910163847.GA30699@uranus.ravnborg.org> <6bc632150709102247s3071c60jcddf8f88c8f2bc10@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bc632150709102247s3071c60jcddf8f88c8f2bc10@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2007 at 11:17:48AM +0530, pradeep singh rautela wrote:
> On 9/10/07, Sam Ravnborg <sam@ravnborg.org> wrote:
> [...]
> > > I added some .c files to a new dir under net/foo/ .
> > > Added corresponding .h files to a new dir under include/foo/
> > >
> > > Create a Kconfig and Makefile in net/foo/ directory.
> > > Added corresponding entries to Makefile and Kconfig in the net/ dir.
> > >
> > > I happily executed a make with a beaming face after selecting the foo
> > > option after doing a
> > > $make menuconfig.
> > >
> > > To my surprise i got this error :-
> > >
> > > make[1]: *** No rule to make target `arch/i386/kernel/vmlinux.lds',
> > > needed by `__build'.  Stop
> >
> > Did the kernel build before you started adding your stuff?
> > It looks like you broke something non-obvious when adding your stuff since the
> > above failure should not happen just by adding a new directory under net/
> 
> Went home and tried again. It builds fine in git repo, but again
> whenever i make an archive using git-archive --format=tar
> --prefix=linux-2.6.18/ HEAD | bzip2 > linux-2.6.18.tar.bz2 , i get the
> problem with this bzipped tree.
> 
> I removed .gitignore file from the my git repo and added manually
> rules to .git/info/exclude instead. This did the trick and
> git-archiv'ing did not result in a broken bzipped tree.
> 
> Perhaps i did something silly or may be something to do with git. ??

You where hit by a problem in the top-level .gitignore.
See commit: eaf729c8a8bfc9c7a5ff5659e3b2584bf2ef22e1

Use: git show eaf729c8a8bfc9c7a5ff5659e3b2584bf2ef22e1

This commit is most likely not in your tree.
It just do:
diff --git a/.gitignore b/.gitignore
index 8d15830..a232295 100644
--- a/.gitignore
+++ b/.gitignore
@@ -22,6 +22,7 @@
 tags
 TAGS
 vmlinux*
+!vmlinux.lds.S
 System.map
 Module.symvers


	Sam
