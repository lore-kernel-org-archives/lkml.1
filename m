Return-Path: <linux-kernel-owner+w=401wt.eu-S932714AbYBNID2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932714AbYBNID2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 03:03:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760627AbYBNIDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 03:03:19 -0500
Received: from cadalboia.ferrara.linux.it ([195.110.122.101]:58212 "EHLO
	cadalboia.ferrara.linux.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760398AbYBNIDS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 03:03:18 -0500
From: Fabio Coatti <cova@ferrara.linux.it>
Organization: FerraraLUG
To: Len Brown <lenb@kernel.org>
Subject: Re: stuck with 2.6.23.14 on x86_64
Date: Thu, 14 Feb 2008 09:03:15 +0100
User-Agent: KMail/1.9.7
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org
References: <200802121503.41328.cova@ferrara.linux.it> <200802131021.23974.cova@ferrara.linux.it> <200802140048.12258.lenb@kernel.org>
In-Reply-To: <200802140048.12258.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802140903.15961.cova@ferrara.linux.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alle giovedì 14 febbraio 2008, Len Brown ha scritto:

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
> I think this got fixed in 2.6.24 by the X86_64_ACPI_NUMA dependencies.
> (in 2.6.23 it used to select ACPI, in 2.6.24 it depends on ACPI).
>
> So I think in 2.6.24 you should not have this trouble.


That would be great, now I'm only to wait to find a solution for E200i SCSI 
controller: http://bugzilla.kernel.org/show_bug.cgi?id=9859

In fact, I'm able to compile 2.6.24 so it seems that the CONFIG_PM bug is 
solved; now I've only to find why 2.6.24 is not willing to boot on my 
boxes :)







-- 
Fabio "Cova" Coatti    http://members.ferrara.linux.it/cova     
Ferrara Linux Users Group           http://ferrara.linux.it
GnuPG fp:9765 A5B6 6843 17BC A646  BE8C FA56 373A 5374 C703
Old SysOps never die... they simply forget their password.
