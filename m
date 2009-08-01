Return-Path: <linux-kernel-owner+w=401wt.eu-S1752592AbZHAJOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592AbZHAJOw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 05:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbZHAJOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 05:14:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:62719 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbZHAJOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 05:14:51 -0400
Date: Sat, 1 Aug 2009 02:14:47 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Greg KH <gregkh@suse.de>
cc: Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Lucian Adrian Grijincu <lgrijincu@ixiacom.com>
Subject: Re: [PATCH] documentation: make it clear that sysfs is optional
In-Reply-To: <20090727162601.GA3632@suse.de>
Message-ID: <alpine.DEB.2.01.0908010157150.5831@bogon.housecafe.de>
References: <20090727090642.0e495919.randy.dunlap@oracle.com> <20090727161031.GA15328@suse.de> <20090727091824.38d55ea1.randy.dunlap@oracle.com> <20090727162601.GA3632@suse.de>
User-Agent: Alpine 2.01 (DEB 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1+vsE26n8SvLPCZLGmGT+ASs8lz8ov7AyaOwZ3
 TuJR8JtOVps8psQQ8smXM/rapD9cnrvGocTyhPs714wVlfWNP1
 qSp114c2ZxyvLFSXpC8Bw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jul 2009 at 09:26, Greg KH wrote:
> Probably the same reason /proc is configurable.  No one ever turns it
> off, but hey, it's possible :)

Hm, it seems as we cannot turn off PROC_FS or SYSFS any more. At least on 
my system a "make allnoconfig" still selects both. While PROC_FS still 
shows up under Filesystems->Pseudo-Filesystem (but cannot be turned off), 
I don't see a menuconfig knob to turn off SYSFS.
However, "make allnoconfig" still selects quite a few options anyway:

# uname -m
x86_64
# make allnoconfig
# grep -c =y .config
175

(manually editing .config gets reverted on another "make config").

So, it loks like SYSFS is just one of the things needed to build a kernel, 
along with the ~170 other things, at least on x86_64. Is this "make it 
clear that sysfs is optional" patch still valid? :-)

Christian.

sid$ find . -name Kconfig | xargs grep SYSFS  | egrep -v 'drivers/|fs/|net/'
./arch/arm/mach-pxa/Kconfig:    select GPIO_SYSFS
./arch/powerpc/kvm/Kconfig:     depends on KVM && MARKERS && SYSFS
./arch/x86/kvm/Kconfig: depends on KVM && SYSFS
./init/Kconfig:config SYSFS_DEPRECATED
./init/Kconfig:config SYSFS_DEPRECATED_V2
./init/Kconfig: depends on SYSFS
./init/Kconfig: select SYSFS_DEPRECATED
./init/Kconfig: depends on SLUB && SYSFS
./kernel/trace/Kconfig: depends on SYSFS
./security/Kconfig:     depends on SYSFS


-- 
BOFH excuse #228:

That function is not currently supported, but Bill Gates assures us it will be featured in the next upgrade.
