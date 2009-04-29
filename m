Return-Path: <linux-kernel-owner+w=401wt.eu-S1759639AbZD2Rvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759639AbZD2Rvp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 13:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbZD2Rvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 13:51:36 -0400
Received: from web32607.mail.mud.yahoo.com ([68.142.207.234]:43906 "HELO
	web32607.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751604AbZD2Rvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 13:51:35 -0400
Message-ID: <225539.25847.qm@web32607.mail.mud.yahoo.com>
X-YMail-OSG: wnGbpPoVM1lbKCcpaAlGRl_FBsRdFsciaPg.VcpuwN84sJ0kFoL_C6nDMvGr9YrIb.7468k0jYb2f1oTRWL79xxpScXSMPZPBKuZqUGCoF74UcBXHJuqjSxEwM0jCUWtpz2yKFppYO23QAgwaDTqAPkaPkQrLFM0m6dZhcTGL0YgtUSmGYMrDBEzAt4d0xq4FDMsNWQ1qHI56Pk_kQInUaE9KM1ON.HGaNfHqKCncDr1Fy7Za2dYpWRvt9prT5m5SxjQi.Zycho_24e30H4i2WU61Z.jC7pDoKAfoF8DVqWrga5oL_e6
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/1277.35 YahooMailWebService/0.7.289.1
References: <409142.83316.qm@web32605.mail.mud.yahoo.com> <20090428182837.62c51f26.akpm@linux-foundation.org> <1240977096.5478.3.camel@marge.simson.net> <20090429011755.c141c599.akpm@linux-foundation.org> <20090429120827.GI8633@ZenIV.linux.org.uk> <884894.99151.qm@web32602.mail.mud.yahoo.com> <20090429174154.GK8633@ZenIV.linux.org.uk>
Date: Wed, 29 Apr 2009 10:51:35 -0700 (PDT)
From: Martin Knoblauch <knobi@knobisoft.de>
Subject: Re: Analyzed/Solved: Booting 2.6.30-rc2-git7 very slow
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mike Galbraith <efault@gmx.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       tigran aivazian <tigran@aivazian.fsnet.co.uk>
In-Reply-To: <20090429174154.GK8633@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




 ------------------------------------------------------
Martin Knoblauch
email: k n o b i AT knobisoft DOT de
www:   http://www.knobisoft.de



----- Original Message ----
> From: Al Viro <viro@ZenIV.linux.org.uk>
> To: Martin Knoblauch <knobi@knobisoft.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>; Mike Galbraith <efault@gmx.de>; Rafael J. Wysocki <rjw@sisk.pl>; linux-kernel@vger.kernel.org; tigran aivazian <tigran@aivazian.fsnet.co.uk>
> Sent: Wednesday, April 29, 2009 7:41:54 PM
> Subject: Re: Analyzed/Solved: Booting 2.6.30-rc2-git7 very slow
> 
> On Wed, Apr 29, 2009 at 10:24:20AM -0700, Martin Knoblauch wrote:
> 
> > > Er...  Somebody mounting sysfs twice?  From some init script and from
> > > /etc/fstab, perhaps?  That definitely looks like two mount(2) had to
> > > have been done to cause that...
> > 
> >  One definitely comes from /etc/fstab, but I am not aware of any other script 
> mounting sysfs in my userspace.
> 
> Check in /etc/init.d; e.g. on debian it's mountkernfs.  More interesting
> question is what else is mounted on /sys; how about the entire /proc/mounts
> contents?

2.6.30-rc3-git2:

rootfs / rootfs rw 0 0
/proc /proc proc rw,relatime 0 0
none /sys sysfs rw,relatime 0 0
none /dev tmpfs rw,relatime,mode=755 0 0
/dev/root / ext3 rw,relatime,errors=continue,data=writeback 0 0
none /dev tmpfs rw,relatime,mode=755 0 0
/proc /proc proc rw,relatime 0 0
/proc/bus/usb /proc/bus/usb usbfs rw,relatime 0 0
/sys /sys sysfs rw,relatime 0 0
none /dev/pts devpts rw,relatime,gid=5,mode=620 0 0
/dev/cciss/c0d0p1 /boot ext3 rw,relatime,errors=continue,data=writeback 0 0
none /dev/shm tmpfs rw,relatime 0 0
/dev/cciss/c0d0p4 /scratch ext2 rw,noatime,errors=continue 0 0
none /proc/sys/fs/binfmt_misc binfmt_misc rw,relatime 0 0
sunrpc /var/lib/nfs/rpc_pipefs rpc_pipefs rw,relatime 0 0


2.6.19.2

rootfs / rootfs rw 0 0
/proc /proc proc rw 0 0
none /dev tmpfs rw 0 0
/dev/root / ext3 rw,data=ordered 0 0
none /dev tmpfs rw 0 0
/proc /proc proc rw 0 0
/proc/bus/usb /proc/bus/usb usbfs rw 0 0
/sys /sys sysfs rw 0 0
none /dev/pts devpts rw 0 0
/dev/cciss/c0d0p1 /boot ext3 rw,data=ordered 0 0
none /dev/shm tmpfs rw 0 0
/dev/VolGroup00/LogVol02 /scratch ext2 rw,noatime 0 0
none /proc/sys/fs/binfmt_misc binfmt_misc rw 0 0
sunrpc /var/lib/nfs/rpc_pipefs rpc_pipefs rw 0 0


Cheers
Martin

