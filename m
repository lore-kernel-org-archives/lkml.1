Return-Path: <linux-kernel-owner+w=401wt.eu-S1760899AbXKMV2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760899AbXKMV2P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 16:28:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754046AbXKMV2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 16:28:00 -0500
Received: from ns2.g-housing.de ([81.169.133.75]:42887 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753987AbXKMV17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 16:27:59 -0500
Date: Tue, 13 Nov 2007 22:27:49 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: "J. Bruce Fields" <bfields@fieldses.org>
cc: linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca
Subject: Re: stuck nfsd processes with 2.6.24-rc2
In-Reply-To: <20071113194113.GA22590@fieldses.org>
Message-ID: <alpine.DEB.0.99999.0711132219280.3960@sheep.housecafe.de>
References: <alpine.DEB.0.9999.0711131955530.27452@sheep.housecafe.de> <20071113194113.GA22590@fieldses.org>
User-Agent: Alpine 0.99999 (DEB 796 2007-11-08)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007, J. Bruce Fields wrote:
> Could you get a sysrq-T trace?  (First get the [nfsd] processes in [D]

Ah, I forgot about that. Will do as soon as I get a working kernel again. 
I'm in the middle of git-bisecting and I had to mark the last 2 versions 
as "bad" but only because they 1) Oopsed during boot or 2) could not load 
the kernel image:

-------------------------------------
# git-bisect log
git-bisect start
# bad: [6e800af233e0bdf108efb7bd23c11ea6fa34cdeb] ACPI: add documentation for deprecated /proc/acpi/battery in ACPI_PROCFS
git-bisect bad 6e800af233e0bdf108efb7bd23c11ea6fa34cdeb				0)
# good: [bbf25010f1a6b761914430f5fca081ec8c7accd1] Linux 2.6.23
git-bisect good bbf25010f1a6b761914430f5fca081ec8c7accd1			OK
# good: [fba956c46a72f9e7503fd464ffee43c632307e31] Map volume and brightness events on thinkpads
git-bisect good fba956c46a72f9e7503fd464ffee43c632307e31			OK
# bad: [7b1915a989ea4d426d0fd98974ab80f30ef1d779] mm/oom_kill.c: Use list_for_each_entry instead of list_for_each
git-bisect bad 7b1915a989ea4d426d0fd98974ab80f30ef1d779				1)
# bad: [c223701cf6c706f42840631c1ca919a18e6e2800] ide: add "hdx=nodma" kernel parameter
git-bisect bad c223701cf6c706f42840631c1ca919a18e6e2800				2)

0) was at 2.4.24-rc2 or so
1) Oops during bootup, but not NFS related, IIRC
2) Grub could not load the kernel: "linux 'zimage' kernel too big, try
    'make bzImage'". Maybe related to the x86/i386 merge?
-------------------------------------

I've built these kernels like so:

  # make mrproper
  # cp ~/config.2.6.23.1 .config
  # yes '' | make oldconfig
  # make
  # sudo cp arch/i386/boot/bzImage System.map /boot/2.6/
  # sudo make modules_install

Marking versions as "bad" because of unrelated stuff might poison the 
results somehow, or make them unusable again. Hm...

@Mathieu: I'll try LTTng later on, many thanks for the hint!

Christian.
-- 
BOFH excuse #90:

Budget cuts
