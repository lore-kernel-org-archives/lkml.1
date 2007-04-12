Return-Path: <linux-kernel-owner+w=401wt.eu-S1751451AbXDLTDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451AbXDLTDb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 15:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbXDLTDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 15:03:31 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:55091 "HELO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751451AbXDLTDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 15:03:30 -0400
Date: Thu, 12 Apr 2007 20:56:39 +0200
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Helge Hafting <helge.hafting@aitel.hist.no>, Jiri Kosina <jikos@jikos.cz>,
       linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: 2.6.21-rc6-mm1 USB related boot hang
Message-ID: <20070412185639.GB12676@aitel.hist.no>
References: <20070408143559.f5014629.akpm@linux-foundation.org> <20070411194227.GA31286@aitel.hist.no> <20070411134346.d10765da.akpm@linux-foundation.org> <20070411230700.GA4023@aitel.hist.no> <Pine.LNX.4.64.0704120947230.12991@twin.jikos.cz> <Pine.LNX.4.64.0704121001400.12991@twin.jikos.cz> <461E1B41.90000@aitel.hist.no> <20070412094747.e2b46b7a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070412094747.e2b46b7a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Helge Hafting <helgehaf@aitel.hist.no>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 09:47:47AM -0700, Andrew Morton wrote:
> On Thu, 12 Apr 2007 13:42:57 +0200 Helge Hafting <helge.hafting@aitel.hist.no> wrote:
> 
> > Jiri Kosina wrote:
> > > On Thu, 12 Apr 2007, Jiri Kosina wrote:
> > >
> > >   
> > >> Could you please
> > >> - try booting without any HID devices plugged in (i.e. usb mice, usb 
> > >>   keyboards) if the problem persists?
> > >> - recompile 2.6.21-rc6-mm1 with git-hid.patch reverted to see if it helps?
> > >>     
> > >
> > > Do you compile with CONFIG_HIDRAW?
> > >   
> > No, that one is not set. 
> > 
> > I did use the new SLUB thing - could that possibly be the cause?
> 
> yup.

Went back to SLAB, got a compile error. Did a make clean
and compiled again. Got some warnings:

  LD      vmlinux
  SYSMAP  System.map
  SYSMAP  .tmp_System.map
  MODPOST vmlinux
WARNING: init/built-in.o - Section mismatch: reference to
.init.text:kernel_init
 from .text.rest_init after 'rest_init' (at offset 0xe)
WARNING: mm/built-in.o - Section mismatch: reference to .init.text: from
.text.k
mem_cache_create after 'kmem_cache_create' (at offset 0x40b)
WARNING: mm/built-in.o - Section mismatch: reference to .init.text: from
.text.k
mem_cache_create after 'kmem_cache_create' (at offset 0x568)
  AS      arch/x86_64/boot/bootsect.o
  LD      arch/x86_64/boot/bootsect
  AS      arch/x86_64/boot/setup.o
  LD      arch/x86_64/boot/setup
  AS      arch/x86_64/boot/compressed/head.o
  CC      arch/x86_64/boot/compressed/misc.o
  OBJCOPY arch/x86_64/boot/compressed/vmlinux.bin
  GZIP    arch/x86_64/boot/compressed/vmlinux.bin.gz
  LD      arch/x86_64/boot/compressed/piggy.o
  LD      arch/x86_64/boot/compressed/vmlinux
  OBJCOPY arch/x86_64/boot/vmlinux.bin
  HOSTCC  arch/x86_64/boot/tools/build
  BUILD   arch/x86_64/boot/bzImage
Root device is (8, 49)
Boot sector 512 bytes.
Setup is 7302 bytes.
System is 3075 kB
Kernel: arch/x86_64/boot/bzImage is ready  (#11)


Then I booted this - and it hung exactly the same way.

I thought SLUB was reasonbably safe, it is new but not marked experimental.

Helge Hafting
