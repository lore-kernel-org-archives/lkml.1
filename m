Return-Path: <linux-kernel-owner+w=401wt.eu-S1752298AbXLaQKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298AbXLaQKl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 11:10:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755473AbXLaQK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 11:10:27 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755083AbXLaQKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 11:10:25 -0500
Date: Mon, 31 Dec 2007 11:10:21 -0500
From: Dave Jones <davej@redhat.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Recursive variable `KBUILD_CFLAGS' references itself
	(eventually).
Message-ID: <20071231161021.GC27655@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Sam Ravnborg <sam@ravnborg.org>,
	lkml <linux-kernel@vger.kernel.org>
References: <20071120001445.GA9243@redhat.com> <20071231131619.GE21871@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071231131619.GE21871@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 31, 2007 at 02:16:19PM +0100, Sam Ravnborg wrote:

 > > Trying to do a 32bit build on a 64bit machine.
 > > I did..
 > >   make ARCH=i386 oldconfig
 > >   make ARCH=i386 arch/x86/
 > 
 > Walking through my mailbox I found this one.
 > I did not get similar reports and I cannot reproduce it.
 > Do you continue to see this or had it been fixed somehow?

Still happens for me with the latest tree from git.

$ make ARCH=i386 arch/x86/
  HOSTCC  scripts/kconfig/conf.o
  HOSTLD  scripts/kconfig/conf
scripts/kconfig/conf -s arch/x86/Kconfig
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  UPD     include/linux/utsrelease.h
  CALL    scripts/checksyscalls.sh
/mnt/raid0/src/linux-2.6/arch/x86/Makefile_32:43: *** Recursive variable `KBUILD_CFLAGS' references itself (eventually).  Stop.
make: *** [arch/x86/] Error 2

 > The only way I can see it heppen is that you have lost
 > the initial assignmnet in top-level Makefile so
 > make see this as an '=' assinment and not a ':='
 > assignment.

$ git diff Makefile
$

(This tree is completely pristine, no changes at all)

	Dave

-- 
http://www.codemonkey.org.uk
