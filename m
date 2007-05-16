Return-Path: <linux-kernel-owner+w=401wt.eu-S934424AbXEPXh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934424AbXEPXh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 19:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759014AbXEPXhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 19:37:18 -0400
Received: from alnrmhc11.comcast.net ([206.18.177.51]:42402 "EHLO
	alnrmhc11.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758157AbXEPXhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 19:37:16 -0400
Message-ID: <464B95A2.9020509@comcast.net>
Date: Wed, 16 May 2007 19:37:06 -0400
From: Ed Sweetman <safemode2@comcast.net>
User-Agent: Icedove 1.5.0.10 (X11/20070328)
MIME-Version: 1.0
To: jhoblitt@ifa.hawaii.edu
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Kconfig powernow-k8 driver should depend on ACPI P-States
 driver
References: <20070516011711.GE15763@ifa.hawaii.edu> <200705162039.02379.prakash@punnoor.de> <e9e943910705161253i75750876s1789b7844c87e97@mail.gmail.com> <464B63D8.2060501@gentoo.org> <20070516212736.GO15763@ifa.hawaii.edu> <464B8819.3050303@comcast.net> <464B9155.7070705@gentoo.org>
In-Reply-To: <464B9155.7070705@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Drake wrote:
> Ed Sweetman wrote:
>> Like i mentioned off list, the problem here is that cpu freq modules 
>> dont depend (Kconfig) on CONFIG_ACPI_PROCESSOR, yet they do.
>
> Not really. Firstly, some of the cpufreq modules *do* depend on 
> CONFIG_ACPI_PROCESSOR. Secondly, the ones that don't have an existing 
> dependency do not actually depend on ACPI_PROCESSOR in some/most 
> configurations.
>
> I'll send in a patch to fix the real problem soon.
>
> Daniel

The way i patched it was to just include a "select ACPI_PROCESSOR" in
the X86_POWERNOW_K8 Kconfig entry.

Since the "driver" that the user sees in the Kconfig is X86_POWERNOW_K8
is actually not a driver at all, our actual driver behaves differently
since the "pseudo" driver only depends is CPUFREQ.  This is misleading,
as the actual driver beneath it, depends on ACPI_PROCESSOR too.  Now the
driver beneath it responds as you'd think.  It disables itself when it's
depends lines are invalid.  Which is good. But the menu entry that we
see is for X86_POWERNOW_K8, and that isn't disabled or anything when
those depends lines of the driver it actually represents fails.


This is easily fixed with the select line in the "pseudo" driver
...which i find a little more appropriate than a depends line.


As for actual module dependency issues, i haven't bothered looking into
that.   As far as the Kconfig shows it shouldn't be allowed to have
ACPI_PROCESSOR as a module at all. So maybe that's intended.

