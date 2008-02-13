Return-Path: <linux-kernel-owner+w=401wt.eu-S933730AbYBMRqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933730AbYBMRqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 12:46:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932332AbYBMRqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 12:46:17 -0500
Received: from cadalboia.ferrara.linux.it ([195.110.122.101]:60892 "EHLO
	cadalboia.ferrara.linux.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932089AbYBMRqQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 12:46:16 -0500
From: Fabio Coatti <cova@ferrara.linux.it>
Organization: FerraraLUG
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: stuck with 2.6.23.14 on x86_64
Date: Wed, 13 Feb 2008 18:46:12 +0100
User-Agent: KMail/1.9.7
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       len.brown@intel.com
References: <200802121503.41328.cova@ferrara.linux.it> <200802131021.23974.cova@ferrara.linux.it> <20080213091642.b484a7ba.randy.dunlap@oracle.com>
In-Reply-To: <20080213091642.b484a7ba.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802131846.13320.cova@ferrara.linux.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alle mercoledì 13 febbraio 2008, Randy Dunlap ha scritto:

> > >
> > > You're not supposed to have CONFIG_PM unset and CONFIG_ACPI set at the
> > > same time.  The oldconfig generation must have gone wrong at one point.
> >
> > Maybe it's not supposed to have this situation, but maybe you should tell
> > this to the kernel itself :)
> >
> > # zcat /proc/config.gz | egrep "PM|ACPI"
> > CONFIG_X86_64_ACPI_NUMA=y
> > # CONFIG_PM is not set
> > CONFIG_ACPI=y
> > # CONFIG_ACPI_PROCFS is not set
> >
> > # uname -rv
> > 2.6.23.12 #3 SMP Tue Feb 12 11:22:16 CET 2008
> >
> > And you can easily get this situation from menuconfig: just fire up make
> > menuconfig without any .config, go to power management options and turn
> > off "Power Management support". exit and look at .config:
> >
> > # CONFIG_PM is not set
> > CONFIG_SUSPEND_SMP_POSSIBLE=y
> > CONFIG_HIBERNATION_SMP_POSSIBLE=y
> > CONFIG_ACPI=y
> >
> > Maybe if this is not supposed to be the right situation, some
> > dependencies are not respected... (tested on .16)
>
> Yes, this is yet another select problem.  X86_64_NUMA_ACPI
> selects ACPI, even though PM is not enabled.  :(
>
> So you have a manual fix:  just enable CONFIG_PM.
>
> Is this specific config important to you?  I.e., do you want/need
> NUMA support?  If so, you'll just need to continue enabling CONFIG_PM.

Well, I suppose that I need to activate NUMA, as I'm running a dual 
processor/dual core AMD 2216HE box... so I will go for CONFIG_PM option 
enabled, I suppose :)



-- 
Fabio "Cova" Coatti    http://members.ferrara.linux.it/cova     
Ferrara Linux Users Group           http://ferrara.linux.it
GnuPG fp:9765 A5B6 6843 17BC A646  BE8C FA56 373A 5374 C703
Old SysOps never die... they simply forget their password.
