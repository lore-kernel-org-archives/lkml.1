Return-Path: <linux-kernel-owner+w=401wt.eu-S966425AbXJPVuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966425AbXJPVuc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 17:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966330AbXJPVuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 17:50:09 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:20682 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966329AbXJPVuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 17:50:07 -0400
Date: Tue, 16 Oct 2007 14:45:44 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: sam@ravnborg.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kexec@lists.infradead.org, torvalds <torvalds@linux-foundation.org>
Subject: Re: kexec: Cannot determine the file type of arch/x86/boot/bzImage
Message-Id: <20071016144544.bad9ff3c.randy.dunlap@oracle.com>
In-Reply-To: <47152FE6.3050204@m3y3r.de>
References: <47151631.9000307@m3y3r.de>
	<20071016130657.8cc17011.randy.dunlap@oracle.com>
	<47152FE6.3050204@m3y3r.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2007 23:40:54 +0200 Thomas Meyer wrote:

> Randy Dunlap schrieb:
> > On Tue, 16 Oct 2007 21:51:13 +0200 Thomas Meyer wrote:
> >
> > [adding kexec mailing list]
> >
> >   
> >> Look at this:
> >>
> >> $ file arch/x86/boot/bzImage (tree 821f3eff7cdb9d6c7076effabd46c96c322daed1)
> >> arch/x86/boot/bzImage: Linux kernel x86 boot executable zImage, version
> >> 2.6.23 (thomas@hotzenplotz) #39, RO-rootFS, root_dev 0x803, swap_dev
> >> 0x1, Prompt for Videomode
> >>
> >> $ file /boot/bzImage-2.6.23
> >> /boot/bzImage-2.6.23: Linux kernel x86 boot executable RO-rootFS,
> >> root_dev 0x803, swap_dev 0x1, Normal VGA
> >>
> >> and this:
> >>
> >> # kexec -l arch/x86/boot/bzImage
> >> Cannot determine the file type of arch/x86/boot/bzImage
> >>
> >> How to solve this error?
> >>     
> $ git bisect good
> f77bf01425b11947eeb3b5b54685212c302741b8 is first bad commit
> commit f77bf01425b11947eeb3b5b54685212c302741b8
> Author: Sam Ravnborg <sam@neptun.(none)>
> Date:   Mon Oct 15 22:25:06 2007 +0200
> 
>     kbuild: introduce ccflags-y, asflags-y and ldflags-y
> 
>     Introduce ccflags-y, asflags-y and ldflags-y so we soon can
>     deprecate use of EXTRA_CFLAGS, EXTRA_AFLAGS and EXTRA_LDFLAGS.
>     This patch does not touch any in-tree users - thats next round.
>     Lets get this committed first and then fix the users of the
>     soon to be deprecated variants next.
> 
>     The rationale behind this change is to introduce support for
>     makefile fragments like:
> 
>     ccflags-$(CONFIG_WHATEVER_DEBUG) := -DDEBUG
> 
>     As a replacement for the uglier:
>     ifeq ($(CONFIG_WHATEVER_DEBUG),y)
>             EXTRA_CFLAGS := -DDEBUG
>     endif
> 
>     Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> 
> :040000 040000 03915c7c738eefa31f2327521130df23b7dfe95e
> e2a1677df3709813ff793fdfa77d80fff9b838a7 M      Documentation
> :040000 040000 ff4ad149975df39509a18782341f1f8f6a32f07a
> 663bce3c08a0f2e107cecb0b29edc4fe9d5735a0 M      scripts


This makes 2 big problems with this patch in the last 1 hour.

Probably time to revert it...

---
~Randy
