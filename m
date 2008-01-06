Return-Path: <linux-kernel-owner+w=401wt.eu-S1758973AbYAFQMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758973AbYAFQMg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 11:12:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755759AbYAFQM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 11:12:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34310 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755600AbYAFQM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 11:12:28 -0500
Date: Sun, 6 Jan 2008 17:12:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Peter Osterlund <petero2@telia.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
Message-ID: <20080106161207.GB27863@elte.hu>
References: <alpine.LFD.1.00.0801021113150.32517@woody.linux-foundation.org> <20080102194030.GC11638@parisc-linux.org> <1199304735.3258.53.camel@localhost.localdomain> <alpine.LFD.1.00.0801021227140.32517@woody.linux-foundation.org> <1199316785.3258.85.camel@localhost.localdomain> <alpine.LFD.1.00.0801021756310.3010@woody.linux-foundation.org> <m3ir27oe7f.fsf@telia.com> <1199627875.5205.1.camel@localhost.localdomain> <20080106144706.GA25419@elte.hu> <1199632845.5205.31.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199632845.5205.31.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> > The reproducer came to you via Peter Osterlund who has never 
> > authored a single drivers/scsi/ commit before (according to git-log) 
> > and who (and here i'm out on a limb guessing it) does not even 
> > follow linux-scsi@vger.kernel.org.
> > 
> > this bug was obscure and hidden on linux-scsi@vger.kernel.org for 
> > _months_, (it is a rarely visited and rarely read mailing list) and 
> > there was just not enough "critical mass" to get this issue fixed.
> 
> If I were you, I'd actually make a cursory effort to get my facts 
> straight before spouting off.
> 
> This bug was actually hidden in bugzilla for ages, where Matthew 
> Wilcox was trying to deal with it on his own. [...]

Huh? The bugzilla just tracked a bug reported to lkml. The very
description of the bugzilla says:

 Subject         : v2.6.24-rc2-409-g9418d5d: attempt to access beyond end of device
 Submitter       : Thomas Meyer <thomas@m3y3r.de>
 References      : http://lkml.org/lkml/2007/11/13/250

so no, it was evidently not "hidden in bugzilla for ages" - all the 
important action happened on lkml.

> The whole problem with this bug was generated precisely because it was 
> kept in bugzilla where too few people actually looked at it.  You're 
> the one who annotated the bugzilla entries with trite little homilies 
> asking why there was no action *without* ever notifying any mailing 
> list, I might add.

again, this bugzilla entry originated from lkml. I did ping the bugzilla 
because i saw that the suspected commit's author was Cc:-ed already. Why 
should every bug reporter and debugger be fully aware of the absolutely 
SILLY little details and preferences of maintainers about how and whom 
to report bugs?

YOU made the workflow fragile in the first place, by going away to 
linux-scsi and ignoring lkml reports. Or in your own words, in the 
bugzilla, comment #9:

  http://bugzilla.kernel.org/show_bug.cgi?id=9370#c9

  Reply-To: James.Bottomley@HansenPartnership.com

  [...]
  Erm, actually no ... this is the first I've heard of it, except as a 
  passing question from matthew.  It's usually safe to assume if it's 
                                  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  not on linux-scsi I haven't seen it.
  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

that's fundamentally flawed. For testers there should be only one, 
simple as possible rule:

  "if you have a problem with the Linux kernel, then report it to lkml"

[ or report it to your distro or bugzilla.kernel.org, where it will be
  propagated towards lkml by others. ]

not to "report it to one of the 100+ lists listed here - good luck 
getting it right":

L:	accessrunner-general@lists.sourceforge.net
L:	acpi4asus-user@lists.sourceforge.net
L:	alsa-devel@alsa-project.org (subscribers-only)
L:	atl1-devel@lists.sourceforge.net
L:	autofs@linux.kernel.org
L:	blinux-list@redhat.com
L:	bluesmoke-devel@lists.sourceforge.net
L:	bluez-devel@lists.sf.net
L:	bonding-devel@lists.sourceforge.net
L:	bridge@lists.linux-foundation.org
L:	cbe-oss-dev@ozlabs.org
L:	cluster-devel@redhat.com
L:	codalist@coda.cs.cmu.edu
L:	coreteam@netfilter.org
L:	cpufreq@lists.linux.org.uk
L:	dc395x@twibble.org
L:	dccp@vger.kernel.org
L:	dev-etrax@axis.com
L:	discuss@x86-64.org
L:	DL-MPTFusionLinux@lsi.com
L:	dm-devel@redhat.com
L:	dri-devel@lists.sourceforge.net
L:	e1000-devel@lists.sourceforge.net
L:	ebtables-devel@lists.sourceforge.net
L:	ebtables-user@lists.sourceforge.net
L:	ecryptfs-devel@lists.sourceforge.net
L:	Eng.Linux@digi.com
L:	fuse-devel@lists.sourceforge.net
L:	general@lists.openfabrics.org
L:	gigaset307x-common@lists.sourceforge.net
L:	hostap@shmoo.com (subscribers-only)
L:	http://lists.twibble.org/mailman/listinfo/dc395x/
L:	i2c@lm-sensors.org
L:	ibm-acpi-devel@lists.sourceforge.net
L:	info-linux@geode.amd.com
L:	ipw2100-devel@lists.sourceforge.net
L:	ipw3945-devel@lists.sourceforge.net
L:	irda-users@lists.sourceforge.net (subscribers-only)
L:	isdn4linux@listserv.isdn4linux.de
L:	iss_storagedev@hp.com
L:	jfs-discussion@lists.sourceforge.net
L:	kernel@avr32linux.org
L:	kernel-discuss@handhelds.org
L:	kernel-janitors@vger.kernel.org
L:	kexec@lists.infradead.org
L:	kpreempt-tech@lists.sourceforge.net
L:	kvm-devel@lists.sourceforge.net
L:	legousb-devel@lists.sourceforge.net
L:	lguest@ozlabs.org
L:	libertas-dev@lists.infradead.org
L:	linux1394-devel@lists.sourceforge.net
L:	linux-abi-devel@lists.sourceforge.net
L:	linux-acenic@sunsite.dk
L:	linux-acpi@vger.kernel.org
L:	linux-aio@kvack.org
L:	linux-altix@sgi.com
L:      linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
L:	linux-atm-general@lists.sourceforge.net (subscribers-only)
L:	linux-audit@redhat.com (subscribers-only)
L:	linux-cifs-client@lists.samba.org
L:	linux-crypto@vger.kernel.org
L:	linux-decnet-user@lists.sourceforge.net
L: 	linux-dvb@linuxtv.org (subscription required)
L:	linux-eata@i-connect.net, linux-scsi@vger.kernel.org
L:	linux-ext4@vger.kernel.org
L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
L:	linux-fsdevel@vger.kernel.org
L:	linux-hams@vger.kernel.org
L:	linux-hippi@sunsite.dk
L:	linux-ia64@vger.kernel.org
L:	linux-ide@vger.kernel.org
L:	linux-input@vger.kernel.org
L:	linux-kbuild@vger.kernel.org
L:	linux-kernel@vger.kernel.org
L:	linux-laptop@vger.kernel.org
L:	linux-m32r-ja@ml.linux-m32r.org (in Japanese)
L:	linux-m32r@ml.linux-m32r.org
L:	linux-m68k@lists.linux-m68k.org
L:	linux-mips@linux-mips.org
L:	linux-mm@kvack.org
L:	linux-mtd@lists.infradead.org
L:	linux-nfs@vger.kernel.org
L:	linux-ntfs-dev@lists.sourceforge.net
L:	linux-nvidia@lists.surfsouth.com
L:	linux-parisc@vger.kernel.org
L:	linux-parport@lists.infradead.org (subscribers-only)
L:	linux-pci@atrey.karlin.mff.cuni.cz
L:	linux-pcmcia@lists.infradead.org
L:	linux-pm@lists.linux-foundation.org
L:	linuxppc-dev@ozlabs.org
L:	linux-ppp@vger.kernel.org
L:	linux-raid@vger.kernel.org
L:	linux-s390@vger.kernel.org
L:	linux-scsi@vger.kernel.org
L:	linux-security-module@vger.kernel.org
L:	linux-serial@vger.kernel.org
L:	linux-sh@vger.kernel.org
L:	linux-tr@linuxtr.net
L:      linux-usb@vger.kernel.org
L:	linux-usb@vger.kernel.org
L:	linux-video@atrey.karlin.mff.cuni.cz
L:	linux-visws-devel@lists.sf.net
L:	linux-wireless@vger.kernel.org
L:	linux-x25@vger.kernel.org
L:	linware@sh.cvut.cz
L:	lksctp-developers@lists.sourceforge.net
L:	lm-sensors@lm-sensors.org
L:	mactel-linux-devel@lists.sourceforge.net
L:	mjpeg-users@lists.sourceforge.net
L:	netdev@vger.kernel.org
L:	netem@lists.linux-foundation.org
L:	netfilter-devel@vger.kernel.org
L:	netfilter@vger.kernel.org
L:	nfs@lists.sourceforge.net
L:	ocfs2-devel@oss.oracle.com
L:	openipmi-developer@lists.sourceforge.net
L:	open-iscsi@googlegroups.com
L:	oprofile-list@lists.sf.net
L:	orinoco-devel@lists.sourceforge.net
L:	orinoco-users@lists.sourceforge.net
L:	osst-users@lists.sourceforge.net
L:	pcihpd-discuss@lists.sourceforge.net
L:	pvrusb2@isely.net	(subscribers-only)
L:	reiserfs-devel@vger.kernel.org
L:	rio500-users@lists.sourceforge.net
L:	rt2400-devel@lists.sourceforge.net
L:	rtc-linux@googlegroups.com
L:	samba-technical@lists.samba.org
L:	sdhci-devel@list.drzeus.cx
L: 	selinux@tycho.nsa.gov (subscribers-only, general discussion)
L:	sparclinux@vger.kernel.org
L:	spi-devel-general@lists.sourceforge.net
L:	stable@kernel.org
L:	tipc-discussion@lists.sourceforge.net
L:	tlan-devel@lists.sourceforge.net (subscribers-only)
L:	tlinux-users@tce.toshiba-dme.co.jp
L:	tpmdd-devel@lists.sourceforge.net
L:	tulip-users@lists.sourceforge.net
L:	uclinux-dev@uclinux.org  (subscribers-only)
L:	uclinux-dist-devel@blackfin.uclinux.org (subscribers-only)
L:	usbb2k-api-dev@nongnu.org
L:	usb-storage@lists.one-eyed-alien.net
L:	user-mode-linux-devel@lists.sourceforge.net
L:	user-mode-linux-user@lists.sourceforge.net
L:	v9fs-developer@lists.sourceforge.net
L:	video4linux-list@redhat.com
L:	virtualization@lists.osdl.org
L:	vtun@office.satix.net
L:	xen-devel@lists.xensource.com
L:	xfs@oss.sgi.com
L:	zd1211-devs@lists.sourceforge.net (subscribers-only)

yes, there can be other lists and mails, so this isnt a rigid rule in 
any way, but the _default_ is for maintainers of major subsystems to be 
aware of all bugs related (or suspected to be related) to their 
subsystems reported to lkml. Not to be dragged on to lkml kicking and 
screaming ;-) lkml isnt just for the core kernel, it's for the _whole_ 
kernel.

	Ingo
