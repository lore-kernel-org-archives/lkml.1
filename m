Return-Path: <linux-kernel-owner+w=401wt.eu-S1762010AbXIZTcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762010AbXIZTcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 15:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757055AbXIZTcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 15:32:07 -0400
Received: from 2-1-3-15a.ens.sth.bostream.se ([82.182.31.214]:49575 "EHLO
	zoo.weinigel.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756947AbXIZTcF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 15:32:05 -0400
X-Greylist: delayed 474 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Sep 2007 15:32:05 EDT
Date: Wed, 26 Sep 2007 21:24:08 +0200
From: Christer Weinigel <christer@weinigel.se>
To: David Newall <david@davidnewall.com>
Cc: Al Viro <viro@ftp.linux.org.uk>, Phillip Susi <psusi@cfl.rr.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Bill Davidsen <davidsen@tmr.com>,
       majkls <majkls@prepere.com>, bunk@fs.tum.de,
       linux-kernel@vger.kernel.org
Subject: Re: sys_chroot+sys_fchdir Fix
Message-ID: <20070926212408.6662231a@zoo.weinigel.se>
In-Reply-To: <46FA35A6.1070400@davidnewall.com>
References: <46F0CD96.9030807@prepere.com>
	<20070919104018.3a6bcfb1@the-village.bc.nu>
	<46F16A0A.3070402@tmr.com>
	<20070919194559.36015307@the-village.bc.nu>
	<46F1A196.8060108@davidnewall.com>
	<46F401D6.6060609@cfl.rr.com>
	<20070921191012.15a0b51b@the-village.bc.nu>
	<46F9752C.5080807@cfl.rr.com>
	<20070926002340.GL8181@ftp.linux.org.uk>
	<46FA35A6.1070400@davidnewall.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Sep 2007 20:04:14 +0930
David Newall <david@davidnewall.com> wrote:

> Al Viro wrote:
> > Oh, for fsck sake...  Folks, it's standard-required behaviour.
> > Ability to chroot() implies the ability to break out of it.  Could
> > we please add that (along with reference to SuS) to l-k FAQ and be
> > done with that nonsense?
> 
> I'm pretty confident that it's only standard behavior for Linux.
> Every other unix says it's not allowed.

So how about reading up on the subject instead?  

*spends five minutes with Google*

>From the OpenBSD FAQ (an operating system most know for being really,
really focused on security):

    http://www.openbsd.org/faq/faq10.html

    Any application which has to assume root privileges to operate is
    pointless to attempt to chroot(2), as root can generally escape a
    chroot(2).

Solaris:

    http://www.softpanorama.org/Solaris/Security/solaris_privilege_sets.shtml

    You must be root to make the chroot() call, and you should quickly
    change to non-root (a root user can escape a chroot environment,
    so if it's to be effective, you need to drop that privilege).

A chroot FAQ:

    http://www.unixwiz.net/techtips/chroot-practices.html

    There are well-known techniques used to escape from jail, but the
    most common one requires root privileges inside the jail.

Another chroot FAT one linked to from the previous one:

    http://www.bpfh.net/simes/computing/chroot-break.html

    This page details how the chroot() system call can be used to
    provide an additional layer of security when running untrusted
    programs. It also details how this additional layer of security
    can be circumvented.

    Whilst chroot() is reasonably secure, a program can escape from
    its trap.

Yet Another FAQ, this time about secure Unix Programming:

    http://www.faqs.org/faqs/unix-faq/programmer/secure-programming/

    chroot() only limits the file system scope and nothing else.

    [further descriptions of how to break out of chroot, with and
    without root privileges]

Convinced?

  /Christer

-- 
"Just how much can I get away with and still go to heaven?"

Christer Weinigel <christer@weinigel.se>  http://www.weinigel.se
