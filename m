Return-Path: <linux-kernel-owner+w=401wt.eu-S1751899AbZHAQtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899AbZHAQtm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 12:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbZHAQtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 12:49:41 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:52244 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbZHAQtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 12:49:41 -0400
Date: Sat, 1 Aug 2009 09:49:24 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: Greg KH <gregkh@suse.de>, lkml <linux-kernel@vger.kernel.org>,
       Lucian Adrian Grijincu <lgrijincu@ixiacom.com>
Subject: Re: [PATCH] documentation: make it clear that sysfs is optional
Message-Id: <20090801094924.ba245b4c.randy.dunlap@oracle.com>
In-Reply-To: <alpine.DEB.2.01.0908010157150.5831@bogon.housecafe.de>
References: <20090727090642.0e495919.randy.dunlap@oracle.com>
	<20090727161031.GA15328@suse.de>
	<20090727091824.38d55ea1.randy.dunlap@oracle.com>
	<20090727162601.GA3632@suse.de>
	<alpine.DEB.2.01.0908010157150.5831@bogon.housecafe.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt009.oracle.com [141.146.116.18]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4A74721D.0144:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Aug 2009 02:14:47 -0700 (PDT) Christian Kujau wrote:

> On Mon, 27 Jul 2009 at 09:26, Greg KH wrote:
> > Probably the same reason /proc is configurable.  No one ever turns it
> > off, but hey, it's possible :)
> 
> Hm, it seems as we cannot turn off PROC_FS or SYSFS any more. At least on 
> my system a "make allnoconfig" still selects both. While PROC_FS still 
> shows up under Filesystems->Pseudo-Filesystem (but cannot be turned off), 
> I don't see a menuconfig knob to turn off SYSFS.
> However, "make allnoconfig" still selects quite a few options anyway:
> 
> # uname -m
> x86_64
> # make allnoconfig
> # grep -c =y .config
> 175
> 
> (manually editing .config gets reverted on another "make config").
> 
> So, it loks like SYSFS is just one of the things needed to build a kernel, 
> along with the ~170 other things, at least on x86_64. Is this "make it 
> clear that sysfs is optional" patch still valid? :-)


It's no problem to disable PROC_FS and SYSFS if you first enable
CONFIG_EMBEDDED>


> sid$ find . -name Kconfig | xargs grep SYSFS  | egrep -v 'drivers/|fs/|net/'
> ./arch/arm/mach-pxa/Kconfig:    select GPIO_SYSFS
> ./arch/powerpc/kvm/Kconfig:     depends on KVM && MARKERS && SYSFS
> ./arch/x86/kvm/Kconfig: depends on KVM && SYSFS
> ./init/Kconfig:config SYSFS_DEPRECATED
> ./init/Kconfig:config SYSFS_DEPRECATED_V2
> ./init/Kconfig: depends on SYSFS
> ./init/Kconfig: select SYSFS_DEPRECATED
> ./init/Kconfig: depends on SLUB && SYSFS
> ./kernel/trace/Kconfig: depends on SYSFS
> ./security/Kconfig:     depends on SYSFS


---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
