Return-Path: <linux-kernel-owner+w=401wt.eu-S1758037AbZKGBJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037AbZKGBJm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 20:09:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757049AbZKGBJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 20:09:41 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:41452 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755542AbZKGBJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 20:09:40 -0500
Date: Fri, 6 Nov 2009 17:07:36 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: nir.tzachar@gmail.com
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       sam@ravnborg.org, zippel@linux-m68k.org, andi@firstfloor.org
Subject: Re: [PATCH] nconfig v5
Message-Id: <20091106170736.6ace81f6.randy.dunlap@oracle.com>
In-Reply-To: <20091106111232.9534f9f7.randy.dunlap@oracle.com>
References: <1257496614-12052-1-git-send-email-nir.tzachar@gmail.com>
	<20091106111232.9534f9f7.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4AF4C8C4.0003:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Nov 2009 11:12:32 -0800 Randy Dunlap wrote:

> On Fri,  6 Nov 2009 10:36:54 +0200 nir.tzachar@gmail.com wrote:
> 
> > From: Nir Tzachar <nir.tzachar@gmail.com>
> > 
> > This patch was inspired by the kernel projects page, where an ncurses
> > replacement for menuconfig was mentioned (by Sam Ravnborg).
> > 
> > Building on menuconfig, this patch implements a more modern look interface using
> > ncurses and ncurses' satellite libraries (menu, panel, form). The implementation
> > does not depend on lxdialog, which is currently distributed with the kernel.
> > 
> > Attached is a reworked version of nconfig. The old menuconfig navigation scheme
> > was dropped, and function keys are used for special choices. Arrows are used in
> > a more intuitive fashion for menu navigation.
> > 
> > 1) The old menuconfig bottom menu was dropped in favor of function keys (which
> >    are interchangeable with regular numbers).
> > 2) Arrows are used for navigation, such that <left> always goes back one menu
> >    and <right> enters a sub-menu.
> > 3) The exit sequence has been improved, such that it is possible to cancel the
> >    exit if there are pending changes and resume editing.
> > 4) All dialog boxes have an <OK> button, which is used to exit the dialog.
> > 5) A 'show all symbols' option has been added, similarly to xconfig.
> > 
> > Please condsider this version as a proper replacement for menuconfig.
> > Cheers, Nir.
> > 
> > Signed-off-by: Nir Tzachar <nir.tzachar@gmail.com>


> When I use F7 to exit, the program hangs.  I have to kill it.
> I don't see any error messages.
> (I'm testing this on a 2.6.32-rc6 kernel source tree).
> 
> ncurses-5.6-41
> ncurses-devel-5.6-41


More user/usability/testing comments:

- sometimes nconfig repaints the kconfig menu list, moving it upward or
  downward.  I find this undersirable.

- after F5/Save + filename entered, the OK prompt is difficult to see
  if the entire screen (window) contains kconfig menu items

- make complains with:

 GEN     /local/linsrc/lnx-2632-rc6/zz64/Makefile
scripts/kconfig/conf -s arch/x86/Kconfig
 Using /local/linsrc/lnx-2632-rc6 as source for kernel
 /local/linsrc/lnx-2632-rc6 is not clean, please run 'make mrproper'
 in the '/local/linsrc/lnx-2632-rc6' directory

because
$ make ARCH=x86_64 O=zz64 defconfig
creates an empty include/config/ directory.


---
~Randy
