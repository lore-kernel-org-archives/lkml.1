Return-Path: <linux-kernel-owner+w=401wt.eu-S1751929AbZGVUds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929AbZGVUds (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 16:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752282AbZGVUds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 16:33:48 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:54675 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbZGVUdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 16:33:47 -0400
Date: Wed, 22 Jul 2009 22:33:45 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       linux arch <linux-arch@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH/RFC] Move generated files to include/generated
Message-ID: <20090722203345.GA8643@merkur.ravnborg.org>
References: <20090721211040.GA7688@merkur.ravnborg.org> <20090722095818.GH6281@cr0.nay.redhat.com> <200907221550.15280.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907221550.15280.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 03:50:15PM +0200, Arnd Bergmann wrote:
> On Wednesday 22 July 2009, Amerigo Wang wrote:
> > On Tue, Jul 21, 2009 at 11:10:40PM +0200, Sam Ravnborg wrote:
> > >In 2.6.30 we introduced support for adding generated
> > >files to a dedicated directory named "include/generated".
> >
> > Personally, I don't like this, I hate to see
> > #include <generated/foo.h>
> 
> I think that moving the generated files to a common location
> makes a lot of sense, but it seems easier to move them
> to include/generated/linux/ or even to (generated/linux/) and
> then add -Iinclude/generated/ to the gcc command line so
> you don't need to actually change all the users.

To put some numbers on this..
utsrelease.h - incuded in 19 files
autoconf.h - included in 0 files
bounds.h - included in 2 files
compile.h - included in 1 file
asm-offsets.h - included in 240 files
version.h - included in 184 files

So the only relevant files to discuss here is asm-offsets.h
and version.h.

We cannot break "#include <linux/version.h>" because
that would break each and every external module.

The solution to this is a simple file:
cat include/linux/version.h
#include <generated.version.h>


For asm-offsets.h the patch-set create an architecture
specific asm-offsets.h that include the generated version.
But I would prefer to see this redone so they include
the generated version directly.
This would also document that asm-offsets.h is a generated file.

The amount of includes pr arch is listed below - not a huge deal to fix up.

alpha      5
arm        30
avr32      3
blackfin   9
cris       3
frv        5
h8300      2
ia64       15
m32r       0
m68k       6
m68knommu  5
microblaze 5
mips       25
mn10300    6
parisc     14
powerpc    43
s390       13
sh         8
sparc      6
um         2
x86        24
xtensa     8


	Sam
