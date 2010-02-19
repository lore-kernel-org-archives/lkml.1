Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab0BSRX2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:23:28 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:53711 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916Ab0BSRX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:23:26 -0500
Message-ID: <4B7EC8AE.60200@oracle.com>
Date: Fri, 19 Feb 2010 09:21:50 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       scsi <linux-scsi@vger.kernel.org>,
       "James E.J. Bottomley" <James.Bottomley@suse.de>
Subject: Re: linux-next: Tree for February 19 (scsi/mpt2sas/raid_class)
References: <20100219174711.5e7cc7be.sfr@canb.auug.org.au>
In-Reply-To: <20100219174711.5e7cc7be.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4B7EC8FB.01EC:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/10 22:47, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20100218:
> 
> 
> The scsi tree lost its build failure.


(caused by a one-line patch to scsi/mpt2sas/Kconfig:
	select RAID_ATTRS
)


When CONFIG_SCSI=m, CONFIG_RAID_ATTRS can still be =y, causing build errors
like:

ERROR: "raid_class_release" [drivers/scsi/mpt2sas/mpt2sas.ko] undefined!
ERROR: "raid_class_attach" [drivers/scsi/mpt2sas/mpt2sas.ko] undefined!

drivers/scsi/built-in.o does contain raid_class_* code (according to 'nm'),
but drivers/built-in.o does not, so I guess that drivers/Makefile:

obj-$(CONFIG_SCSI)		+= scsi/

is preventing drivers/scsi/built-in.o from being added to drivers/built-in.o.

We can:

a/  change drivers/Makefile to say:

obj-y				+= scsi/

(test: that still had a build error:
drivers/built-in.o: In function `raid_match':
raid_class.c:(.text+0x9de7c): undefined reference to `scsi_is_sdev_device'
)

b/  change drivers/scsi/Kconfig to make RAID_ATTRS depend on SCSI, so that raid_class
would be built as a module

That one does work.


Do something else?
Preferences?

-- 
~Randy
