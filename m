Return-Path: <linux-kernel-owner+w=401wt.eu-S1755557AbZBOTh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557AbZBOTh1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 14:37:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751649AbZBOThO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 14:37:14 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36896 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbZBOThN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 14:37:13 -0500
Date: Sun, 15 Feb 2009 20:36:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>, Yinghai Lu <yinghai@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: state of some x86 acpi patches
Message-ID: <20090215193655.GA18674@elte.hu>
References: <20081216192534.GB843@elte.hu> <alpine.LFD.2.00.0812311821110.3854@localhost.localdomain> <495C677F.6080707@goop.org> <20090102153957.GA1180@elte.hu> <4980EE0C.4070308@goop.org> <49810211.9030808@kernel.org> <498CF8DA.30004@goop.org> <498CFD95.5070004@kernel.org> <498E229C.5030205@goop.org> <20090209123711.GK17782@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090209123711.GK17782@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> > Yinghai Lu wrote:
> >> Ingo is too busy...
> >> It seems Len already agreed those patches can go through tip.
> >>   
> >
> > OK, I have them prepared as a branch off tip/git pullable from:
> >
> > The following changes since commit 82eda818f26cbef2b0a6bf6580e52645af62e4fd:
> >  Ingo Molnar (1):
> >        Merge branch 'core/locking'
> >
> > are available in the git repository at:
> >
> >  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git acpi/map
> >
> > Jeremy Fitzhardinge (3):
> >      x86: use early_ioremap in __acpi_map_table
> >      x86: always explicitly map acpi memory
> >      acpi: remove final __acpi_map_table mapping before setting acpi_gbl_permanent_mmap
> >
> > Yinghai Lu (2):
> >      acpi/x86: introduce __apci_map_table, v4
> >      revert_fix_es7000_compiling
> >
> > arch/ia64/kernel/acpi.c          |    4 ++++
> > arch/x86/include/asm/acpi.h      |    3 ---
> > arch/x86/include/asm/fixmap_32.h |    4 ----
> > arch/x86/include/asm/fixmap_64.h |    4 ----
> > arch/x86/kernel/acpi/boot.c      |   33 ++++++++-------------------------
> > arch/x86/kernel/es7000_32.c      |    9 ++++++++-
> > drivers/acpi/acpica/tbxface.c    |   17 ++++++++++++++---
> > drivers/acpi/osl.c               |   11 +++++++++--
> > drivers/acpi/tables.c            |   20 ++++++++++++++------
> > include/acpi/acpiosxf.h          |    1 +
> > include/acpi/acpixf.h            |    4 ++++
> > include/linux/acpi.h             |    1 +
> > 12 files changed, 63 insertions(+), 48 deletions(-)
> 
> Ok, pulled into tip:x86/acpi, thanks guys!

Note, there's a new ia64 build failure due to these patches:

/home/mingo/tip/arch/ia64/kernel/acpi.c:203: error: conflicting types for '__acpi_unmap_table'
/home/mingo/tip/include/linux/acpi.h:82: error: previous declaration of '__acpi_unmap_table' was here
/home/mingo/tip/arch/ia64/kernel/acpi.c:203: error: conflicting types for '__acpi_unmap_table'
/home/mingo/tip/include/linux/acpi.h:82: error: previous declaration of '__acpi_unmap_table' was here
make[2]: *** [arch/ia64/kernel/acpi.o] Error 1
make[2]: *** Waiting for unfinished jobs....
/home/mingo/tip/arch/ia64/kernel/ivt.S: Assembler messages:

	Ingo
