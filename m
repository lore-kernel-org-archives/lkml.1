Return-Path: <linux-kernel-owner+w=401wt.eu-S1753781AbXFFRWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781AbXFFRWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 13:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755354AbXFFRWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 13:22:11 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:52586 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755394AbXFFRWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 13:22:10 -0400
Date: Wed, 6 Jun 2007 19:22:49 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Christoph Pleger <Christoph.Pleger@cs.uni-dortmund.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Size of kernel modules
Message-ID: <20070606172249.GB5918@uranus.ravnborg.org>
References: <20070606170534.67b5dea9.Christoph.Pleger@cs.uni-dortmund.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070606170534.67b5dea9.Christoph.Pleger@cs.uni-dortmund.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 05:05:34PM +0200, Christoph Pleger wrote:
> Hello,
> 
> I have a machine here which I installed with Ubuntu 7.04. Immediately
> after the installation had been finished, I installed the Ubuntu package
> which contains the Ubuntu-modified sources of the linux kernel. I
> extracted the resulting tar.bz2-file, copied the configuration of the
> currently running kernel to .config and created a file localversion-irb
> which contains the line "-irb" and then called "make menuconfig". In the
> menu, I changed the CPU type from 586 to Pentium Pro and entered "-686"
> as the localversion. Finally, I used the Ubuntu tool make-kpkg with
> option "--initrd" to create a new kernel. The option "--initrd" causes
> the installation scripts of the kernel package to automatically create
> an initial ramdisk for the kernel.
> 
> After the new kernel package had been created, I installed it. After
> that, I looked into the directory /boot and was very surprised: The
> initial ramdisk of the new kernel was much larger than the initrd of the
> old kernel. To find out the cause for this, I investigated how
> directories /lib/modules/$old and /lib/modules/$new differ. I found out
> that the filenames are the same, but the size of the files differs very
> much. I found a module file in the new directory that was almost five
> times as large as the file with the same name in the old directory.
> 
> So, my question is the follwing: Is it an expected feature that the file
> sizes of modules grow so much only because of a different cpu type and a
> different localversion, or is there probably a bug in my build tools?

My best guess is that the orignally installed modules are stripped.
If you define INSTALL_MOD_STRIP then you would achieve the same.
>From Documentation/kbuild/makefile.txt:

    INSTALL_MOD_STRIP

	If this variable is specified, will cause modules to be stripped
	after they are installed.  If INSTALL_MOD_STRIP is '1', then the
	default option --strip-debug will be used.  Otherwise,
	INSTALL_MOD_STRIP will used as the option(s) to the strip command.


So you could do something like this:
>$ INSTALL_MOD_STRIP=1 make modules_install

	Sam
