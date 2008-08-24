Return-Path: <linux-kernel-owner+w=401wt.eu-S1756954AbYHXVal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756954AbYHXVal (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 17:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753511AbYHXVaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 17:30:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54067 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753205AbYHXVaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 17:30:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Bug #11355] Regression in 2.6.27-rc2 when cross-building the kernel
Date: Sun, 24 Aug 2008 23:34:04 +0200
User-Agent: KMail/1.9.9
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Larry Finger" <Larry.Finger@lwfinger.net>,
       Sam Ravnborg <sam@ravnborg.org>, David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <VSpL6AnBTS.A.jvH.vaGsIB@albercik>
In-Reply-To: <VSpL6AnBTS.A.jvH.vaGsIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808242334.05993.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 23 of August 2008, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11355
> Subject		: Regression in 2.6.27-rc2 when cross-building the kernel
> Submitter	: Larry Finger <Larry.Finger@lwfinger.net>
> Date		: 2008-08-16 2:38 (8 days old)
> References	: http://marc.info/?l=linux-kernel&m=121885432118368&w=4

As I wrote in the Bugzilla, I'm seeing a related problem.

Namely, I build kernels on one box, with 'make O=<target>', then I mount
<target> on another one over NFS, 'cd' to it and try to install the kernel
modules with 'make modules_install'.  This results in 'HOSTCC firmware/ihex2fw'
and 'fatal error: ...: Read-only file system'.  It's readily reproducible.

Commenting out line 1130 of Makefile
("$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.fwinst obj=firmware __fw_modinst")
obviously helps, so it looks like Makefile.fwinst needs fixing.

Thanks,
Rafael
