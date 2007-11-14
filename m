Return-Path: <linux-kernel-owner+w=401wt.eu-S1758330AbXKNDXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758330AbXKNDXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 22:23:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755158AbXKNDXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 22:23:09 -0500
Received: from mail.fieldses.org ([66.93.2.214]:36660 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755134AbXKNDXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 22:23:08 -0500
Date: Tue, 13 Nov 2007 22:23:05 -0500
To: Christian Kujau <lists@nerdbynature.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: stuck nfsd processes with 2.6.24-rc2
Message-ID: <20071114032305.GA28856@fieldses.org>
References: <alpine.DEB.0.9999.0711131955530.27452@sheep.housecafe.de> <20071113194113.GA22590@fieldses.org> <alpine.DEB.0.99999.0711132219280.3960@sheep.housecafe.de> <alpine.DEB.0.99999.0711140230080.5703@sheep.housecafe.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.99999.0711140230080.5703@sheep.housecafe.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 02:36:18AM +0100, Christian Kujau wrote:
> On Tue, 13 Nov 2007, Christian Kujau wrote:
>> Ah, I forgot about that. Will do as soon as I get a working kernel again. 
>> I'm in the middle of git-bisecting and I had to mark the last 2 versions 
>> as "bad" but only because they 1) Oopsed during boot or 2) could not load 
>> the kernel image:
>
> Same again: after 3 working versions I have to mark yet another one as 
> "bad" - not because the NFS bug showed up, but I was unable to boot again 
> ("linux 'zimage' kernel too big" message again). So now I am at:

Hm, so assuming I got the gitk invocation right.  (I basically just ran
gitk ^goodsha1 ^goodsha2 ...etc... badsha1 badsha2 ... fs/nfsd include/linux/nfsd net/sunrpc /include/linux/sunrpc),
nothing really obvious pops out from that list.  I think the only
nonobvious changes that touch code you're likely to be hitting are the
exportfs rewrite.

Have you checked that the filesystem itself is OK?  (If you 'ls
/path/to/exported/filesystem' on the server does that work?)

Anyway if you get the git-bisect results, that'll be very helpful.  Till
then, yeah, sysrq-T is probably still the first thing to try.

--b.


>
> -------------------------------------
> git-bisect start
> # bad: [6e800af233e0bdf108efb7bd23c11ea6fa34cdeb] ACPI: add documentation for deprecated /proc/acpi/battery in ACPI_PROCFS
> git-bisect bad 6e800af233e0bdf108efb7bd23c11ea6fa34cdeb
> # good: [bbf25010f1a6b761914430f5fca081ec8c7accd1] Linux 2.6.23
> git-bisect good bbf25010f1a6b761914430f5fca081ec8c7accd1
> # good: [fba956c46a72f9e7503fd464ffee43c632307e31] Map volume and brightness events on thinkpads
> git-bisect good fba956c46a72f9e7503fd464ffee43c632307e31
> # bad: [7b1915a989ea4d426d0fd98974ab80f30ef1d779] mm/oom_kill.c: Use list_for_each_entry instead of list_for_each
> git-bisect bad 7b1915a989ea4d426d0fd98974ab80f30ef1d779
> # bad: [c223701cf6c706f42840631c1ca919a18e6e2800] ide: add "hdx=nodma" kernel parameter
> git-bisect bad c223701cf6c706f42840631c1ca919a18e6e2800
> # good: [1d677a6dfaac1d1cf51a7f58847077240985faf2] pm3fb: hardware cursor support
> git-bisect good 1d677a6dfaac1d1cf51a7f58847077240985faf2
> # good: [291702f017efdfe556cb87b8530eb7d1ff08cbae] [ALSA] Support ASUS P701 eeepc [0x1043 0x82a1] support
> git-bisect good 291702f017efdfe556cb87b8530eb7d1ff08cbae
> # good: [92d15c2ccbb3e31a3fc71ad28fdb55e1319383c0] Merge branch 'for-linus' of git://git.kernel.dk/data/git/linux-2.6-block
> git-bisect good 92d15c2ccbb3e31a3fc71ad28fdb55e1319383c0
> # bad: [f77bf01425b11947eeb3b5b54685212c302741b8] kbuild: introduce ccflags-y, asflags-y and ldflags-y
> git-bisect bad f77bf01425b11947eeb3b5b54685212c302741b8
> -------------------------------------
>
> I'm not sure wether it's sane to continue at all ("only 19 revisions 
> left!"); but this has to wait until tomorrow anyway...
>
> @Bruce: sysrq-t will have to wait too, sorry.
>
>
> thanks for any ideas,
> Christian.
> -- 
> BOFH excuse #70:
>
> nesting roaches shorted out the ether cable
