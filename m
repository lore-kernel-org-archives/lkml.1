Return-Path: <linux-kernel-owner+w=401wt.eu-S1765554AbXFRTy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765554AbXFRTy0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 15:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760841AbXFRTyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 15:54:20 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:26658 "EHLO
	viefep33-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762186AbXFRTyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 15:54:18 -0400
Date: Mon, 18 Jun 2007 21:54:15 +0200
From: Carlo Wood <carlo@alinoe.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       eric@anholt.net, zhenyu.z.wang@intel.com, lethal@linux-sh.org,
       y-goto@jp.fujitsu.com
Subject: Re: 2.6.22-rc5 regression
Message-ID: <20070618195415.GA7481@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
	eric@anholt.net, zhenyu.z.wang@intel.com, lethal@linux-sh.org,
	y-goto@jp.fujitsu.com
References: <20070617182254.GA17595@alinoe.com> <20070617195805.GA6125@alinoe.com> <20070617214905.GA6207@alinoe.com> <alpine.LFD.0.98.0706180950130.14121@woody.linux-foundation.org> <20070618181225.GB8054@alinoe.com> <alpine.LFD.0.98.0706181127380.14121@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706181127380.14121@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 11:35:03AM -0700, Linus Torvalds wrote:
> I can follow along, but I get *totally*different* git bisection points!
> 
> > hikaru:/usr/src/kernel/git/linux-2.6>git bisect start
> > hikaru:/usr/src/kernel/git/linux-2.6>git bisect bad v2.6.22-rc5
> > hikaru:/usr/src/kernel/git/linux-2.6>git bisect good 99f9f3d49cbc7d944476f6fde53a77ec789ab2aa
> > Bisecting: 128 revisions left to test after this
> > D       include/asm-blackfin/macros.h
> > M       scripts/package/Makefile
> > D       scripts/package/builddeb
> 
> You seem to have a modified tree! What are those modifications to the 
> blackfin macros.h etc files?

I never (manually) changed anything - so, this should be the result
of the fact that I use the same directory tree to (re)build the kernel
every time.

That 'D' means they are deleted I'd think - so the changes are clear.

I am sorry, but I am totally new to git - I know cvs and svn (and even
then I never used branches :(), but I don't know how to find out what
those differences are with git.
I could start looking on the web - but it's a fact that I don't even
know what I would look for: in order to create a diff one needs two
points. No doubt one point is the current state of my local copy,
but what would that other point be to compare with?
If you would be so kind to ask things like: What is the result of
this or that command, when it comes to git, then I will be faster
and more accurate to tell you :).  I added the result of 'git diff'
below.

> You *should* have gotten this:
> 
> 	[torvalds@woody linux]$ git bisect start
> 	[torvalds@woody linux]$ git bisect bad v2.6.22-rc5
> 	[torvalds@woody linux]$ git bisect good 99f9f3d49cbc7d944476f6fde53a77ec789ab2aa
> 	Bisecting: 127 revisions left to test after this
> 	[9808901b6c63a1c850b072e624c228901a9eaf10] Blackfin serial driver: ignore framing and parity errors
> 
> but those are just off by one, at least (127 vs 128 commits left).
> 
> > [cf68676222e54cd0a31efd968da00e65f9a0963f] Blackfin serial driver: actually implement the break_ctl() function
> > hikaru:/usr/src/kernel/git/linux-2.6>git bisect good
> > Bisecting: 111 revisions left to test after this
> 
> And that's totally broken. Even if I don't use the "9808901b6" commit, and 
> use your "cf686762" commit, I get:
> 
> 	[torvalds@woody linux]$ git bisect good cf68676222e54cd0a31efd968da00e65f9a0963f
> 	Bisecting: 63 revisions left to test after this
> 	[aba297927d1d558c7a94548135133bdf9172708a] Merge master.kernel.org:/pub/scm/linux/kernel/git/kyle/parisc-2.6
> 
> Notice? The "127 revisions left to test after this" has become "63 
> revisions left to test after this".

Well,... when, and because, it's not a linear thing as you mentioned
before - it's not necessarily precisely a cut into half... so I thought,
seeing those weird (not half) numbers that that was the cause.

> That number should be cut in half each time. And you shouldn't get some 
> strange dirty tree indications.
> 
> It might be worth it just making sure your git is ok. It really is acting 
> oddly. What version is it?

git version 1.4.4.4

I am using Debian (suite 'testing') and trying to be a debian purist -
so it isn't like I can easily upgrade to 1.5.x : there is no debian
package for that version in 'testing'.

Nevertheless, if you think it's important - then I can download and
compile a tar ball of course - certainly when I don't have to install
it to test it.

-- 
Carlo Wood <carlo@alinoe.com>

PS The result of 'git diff' is:

diff --git a/include/asm-blackfin/macros.h b/include/asm-blackfin/macros.h
deleted file mode 100644
index e69de29..0000000
diff --git a/scripts/package/Makefile b/scripts/package/Makefile
index 7c434e0..f758b75 100644
--- a/scripts/package/Makefile
+++ b/scripts/package/Makefile
@@ -1,99 +1,2 @@
-# Makefile for the different targets used to generate full packages of a kernel
-# It uses the generic clean infrastructure of kbuild
-
-# Ignore the following files/directories during tar operation
-TAR_IGNORE := --exclude SCCS --exclude BitKeeper --exclude .svn --exclude CVS
-
-
-# RPM target
-# ---------------------------------------------------------------------------
-# The rpm target generates two rpm files:
-# /usr/src/packages/SRPMS/kernel-2.6.7rc2-1.src.rpm
-# /usr/src/packages/RPMS/i386/kernel-2.6.7rc2-1.<arch>.rpm
-# The src.rpm files includes all source for the kernel being built
-# The <arch>.rpm includes kernel configuration, modules etc.
-#
-# Process to create the rpm files
-# a) clean the kernel
-# b) Generate .spec file
-# c) Build a tar ball, using symlink to make kernel version
-#    first entry in the path
-# d) and pack the result to a tar.gz file
-# e) generate the rpm files, based on kernel.spec
-# - Use /. to avoid tar packing just the symlink
-
-# Do we have rpmbuild, otherwise fall back to the older rpm
-RPM := $(shell if [ -x "/usr/bin/rpmbuild" ]; then echo rpmbuild; \
-	           else echo rpm; fi)
-
-# Remove hyphens since they have special meaning in RPM filenames
-KERNELPATH := kernel-$(subst -,,$(KERNELRELEASE))
-MKSPEC     := $(srctree)/scripts/package/mkspec
-PREV       := set -e; cd ..;
-
-# rpm-pkg
-# ---------------------------------------------------------------------------
-$(objtree)/kernel.spec: $(MKSPEC) $(srctree)/Makefile
-	$(CONFIG_SHELL) $(MKSPEC) > $@
-
-rpm-pkg rpm: $(objtree)/kernel.spec FORCE
-	$(MAKE) clean
-	$(PREV) ln -sf $(srctree) $(KERNELPATH)
-	$(PREV) tar -cz $(RCS_TAR_IGNORE) -f $(KERNELPATH).tar.gz $(KERNELPATH)/.
-	$(PREV) rm $(KERNELPATH)
-
-	set -e; \
-	$(CONFIG_SHELL) $(srctree)/scripts/mkversion > $(objtree)/.tmp_version
-	set -e; \
-	mv -f $(objtree)/.tmp_version $(objtree)/.version
-
-	$(RPM) --target $(UTS_MACHINE) -ta ../$(KERNELPATH).tar.gz
-	rm ../$(KERNELPATH).tar.gz
-
-clean-files := $(objtree)/kernel.spec
-
-# binrpm-pkg
-# ---------------------------------------------------------------------------
-$(objtree)/binkernel.spec: $(MKSPEC) $(srctree)/Makefile
-	$(CONFIG_SHELL) $(MKSPEC) prebuilt > $@
-
-binrpm-pkg: $(objtree)/binkernel.spec FORCE
-	$(MAKE) KBUILD_SRC=
-	set -e; \
-	$(CONFIG_SHELL) $(srctree)/scripts/mkversion > $(objtree)/.tmp_version
-	set -e; \
-	mv -f $(objtree)/.tmp_version $(objtree)/.version
-
-	$(RPM) --define "_builddir $(srctree)" --target $(UTS_MACHINE) -bb $<
-
-clean-files += $(objtree)/binkernel.spec
-
-# Deb target
-# ---------------------------------------------------------------------------
-deb-pkg: FORCE
-	$(MAKE) KBUILD_SRC=
-	$(CONFIG_SHELL) $(srctree)/scripts/package/builddeb
-
-clean-dirs += $(objtree)/debian/
-
-
-# tarball targets
-# ---------------------------------------------------------------------------
-tar%pkg: FORCE
-	$(MAKE) KBUILD_SRC=
-	$(CONFIG_SHELL) $(srctree)/scripts/package/buildtar $@
-
-clean-dirs += $(objtree)/tar-install/
-
-
-# Help text displayed when executing 'make help'
-# ---------------------------------------------------------------------------
-help: FORCE
-	@echo '  rpm-pkg         - Build the kernel as an RPM package'
-	@echo '  binrpm-pkg      - Build an rpm package containing the compiled kernel'
-	@echo '                    and modules'
-	@echo '  deb-pkg         - Build the kernel as an deb package'
-	@echo '  tar-pkg         - Build the kernel as an uncompressed tarball'
-	@echo '  targz-pkg       - Build the kernel as a gzip compressed tarball'
-	@echo '  tarbz2-pkg      - Build the kernel as a bzip2 compressed tarball'
-
+# Dummy file 
+help:
diff --git a/scripts/package/builddeb b/scripts/package/builddeb
deleted file mode 100644
index 6edb29f..0000000
--- a/scripts/package/builddeb
+++ /dev/null
@@ -1,123 +0,0 @@
-#!/bin/sh
-#
-# builddeb 1.2
-# Copyright 2003 Wichert Akkerman <wichert@wiggy.net>
-#
-# Simple script to generate a deb package for a Linux kernel. All the
-# complexity of what to do with a kernel after it is installer or removed
-# is left to other scripts and packages: they can install scripts in the
-# /etc/kernel/{pre,post}{inst,rm}.d/ directories that will be called on
-# package install and removal.
-
-set -e
-
-# Some variables and settings used throughout the script
-version=$KERNELRELEASE
-tmpdir="$objtree/debian/tmp"
-packagename=linux-$version
-
-if [ "$ARCH" == "um" ] ; then
-	packagename=user-mode-linux-$version
-fi
-
-# Setup the directory structure
-rm -rf "$tmpdir"
-mkdir -p "$tmpdir/DEBIAN" "$tmpdir/lib" "$tmpdir/boot"
-if [ "$ARCH" == "um" ] ; then
-	mkdir -p "$tmpdir/usr/lib/uml/modules/$version" "$tmpdir/usr/share/doc/$packagename" "$tmpdir/usr/bin"
-fi
-
-# Build and install the kernel
-if [ "$ARCH" == "um" ] ; then
-	$MAKE linux
-	cp System.map "$tmpdir/usr/lib/uml/modules/$version/System.map"
-	cp .config "$tmpdir/usr/share/doc/$packagename/config"
-	gzip "$tmpdir/usr/share/doc/$packagename/config"
-	cp $KBUILD_IMAGE "$tmpdir/usr/bin/linux-$version"
-else 
-	cp System.map "$tmpdir/boot/System.map-$version"
-	cp .config "$tmpdir/boot/config-$version"
-	cp $KBUILD_IMAGE "$tmpdir/boot/vmlinuz-$version"
-fi
-
-if grep -q '^CONFIG_MODULES=y' .config ; then
-	INSTALL_MOD_PATH="$tmpdir" make KBUILD_SRC= modules_install
-	if [ "$ARCH" == "um" ] ; then
-		mv "$tmpdir/lib/modules/$version"/* "$tmpdir/usr/lib/uml/modules/$version/"
-		rmdir "$tmpdir/lib/modules/$version"
-	fi
-fi
-
-# Install the maintainer scripts
-for script in postinst postrm preinst prerm ; do
-	mkdir -p "$tmpdir/etc/kernel/$script.d"
-	cat <<EOF > "$tmpdir/DEBIAN/$script"
-#!/bin/sh
-
-set -e
-
-test -d /etc/kernel/$script.d && run-parts --arg="$version" /etc/kernel/$script.d
-exit 0
-EOF
-	chmod 755 "$tmpdir/DEBIAN/$script"
-done
-
-name="Kernel Compiler <$(id -nu)@$(hostname -f)>"
-# Generate a simple changelog template
-cat <<EOF > debian/changelog
-linux ($version) unstable; urgency=low
-
-  * A standard release
-
- -- $name  $(date -R)
-EOF
-
-# Generate a control file
-if [ "$ARCH" == "um" ]; then
-
-cat <<EOF > debian/control
-Source: linux
-Section: base
-Priority: optional
-Maintainer: $name
-Standards-Version: 3.6.1
-
-Package: $packagename
-Architecture: any
-Description: User Mode Linux kernel, version $version
- User-mode Linux is a port of the Linux kernel to its own system call
- interface.  It provides a kind of virtual machine, which runs Linux
- as a user process under another Linux kernel.  This is useful for
- kernel development, sandboxes, jails, experimentation, and
- many other things.
- .
- This package contains the Linux kernel, modules and corresponding other
- files version $version
-EOF
-
-else
-cat <<EOF > debian/control
-Source: linux
-Section: base
-Priority: optional
-Maintainer: $name
-Standards-Version: 3.6.1
-
-Package: $packagename
-Architecture: any
-Description: Linux kernel, version $version
- This package contains the Linux kernel, modules and corresponding other
- files version $version
-EOF
-fi
-
-# Fix some ownership and permissions
-chown -R root:root "$tmpdir"
-chmod -R go-w "$tmpdir"
-
-# Perform the final magic
-dpkg-gencontrol -isp
-dpkg --build "$tmpdir" ..
-
-exit 0
-
