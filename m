Return-Path: <linux-kernel-owner+w=401wt.eu-S1753112AbZKGVO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbZKGVO6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 16:14:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbZKGVO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 16:14:56 -0500
Received: from www.tglx.de ([62.245.132.106]:34267 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016AbZKGVO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 16:14:56 -0500
Date: Sat, 7 Nov 2009 22:14:36 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Arnd Bergmann <arnd@arndb.de>, Pavel Machek <pavel@ucw.cz>,
       LKML <linux-kernel@vger.kernel.org>,
       Thierry Vignaud <tvignaud@mandriva.com>,
       bugzilla-daemon@bugzilla.kernel.org
Subject: Re: [Bug 14537] New: missing compat_ioctl on x86_64
In-Reply-To: <200911072210.55270.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0911072211300.12138@localhost.localdomain>
References: <bug-14537-6666@http.bugzilla.kernel.org/> <200911072006.36904.rjw@sisk.pl> <200911072152.56586.arnd@arndb.de> <200911072210.55270.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Nov 2009, Rafael J. Wysocki wrote:

> On Saturday 07 November 2009, Arnd Bergmann wrote:
> > On Saturday 07 November 2009, Rafael J. Wysocki wrote:
> > > > Actually... it would be nice to fix that one day, if someone submitted
> > > > nice patch... :-).   
> > > 
> > > It must be fixed in s2disk first, but that would probably require us to drop
> > > support for older kernels.  Which is not unthinkable, but might hurt some
> > > users.
> > 
> > You don't need to drop support for older kernels if s2disk simply tries the
> > new interface first and falls back to the current one if that fails.
> 
> Compat ioctls support is not possible with the old interface.

That does not matter.

If you create a new interface which is 32/64bit safe and keep the old
interface around for compability reasons then a new user space will
try the new interface first and if that is not available due to older
kernel version it uses the old interface. If old user space talks to a
newer kernel it will use the old interface with its current
limitations. Over time you can phase out the old interface in the
kernel.

Thanks,

	tglx
