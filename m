Return-Path: <linux-kernel-owner+w=401wt.eu-S933518AbXIKMcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933518AbXIKMcU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 08:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762875AbXIKMcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 08:32:12 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:33928 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762770AbXIKMcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 08:32:11 -0400
Date: Tue, 11 Sep 2007 21:31:59 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Paulo Marques <pmarques@grupopie.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Michal Januszewski <spock@gentoo.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] video: uvesafb: Add X86 dependency.
Message-ID: <20070911123159.GA23692@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Paulo Marques <pmarques@grupopie.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Januszewski <spock@gentoo.org>, linux-kernel@vger.kernel.org
References: <20070911081752.GA19495@linux-sh.org> <46E67EFD.2040902@grupopie.com> <20070911115346.GA23493@linux-sh.org> <46E687ED.9000802@grupopie.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46E687ED.9000802@grupopie.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2007 at 01:19:57PM +0100, Paulo Marques wrote:
> Paul Mundt wrote:
> >On Tue, Sep 11, 2007 at 12:41:49PM +0100, Paulo Marques wrote:
> >>[...]
> >>Why do you say that it's x86 specific? Am I missing something?
> >>
> >The emulator it uses only runs on x86 and x86_64. Thus, it's x86
> >specific. The v86d and uvesafb pages seem to be in disagremeent, unless
> >by 'non-x86' it's only implying x86_64.
> >
> >Additionally, it needs the vga I/O routines, as per vgacon. Most
> >platforms don't define these.
> 
> I just saw the v86d emulator code, and you're right. It mmaps /dev/mem 
> and assumes the video BIOS is mapped there.
> 
> We should try to change that to mmap something like 
> "/sys/bus/pci/devices/0000:01:00.0/rom" instead so that it can work on 
> any system with a video card plugged on a PCI bus.
> 
> It should also be possible for the emulator to translate in/out 
> instructions to appropriate memory mapped I/O equivalents, no?
> 
> Anyway, I think it is up to Michal to decide if we should remove the 
> kernel support for other archs, or let it stay a bit more while working 
> on solving the v86d side of things. So I'll just step aside now....
> 
Once v86d is fixed up to get at the ROM directly and the driver uses MMIO
directly, I don't see a problem with unrestricting it. For the time being
however, the build is both broken, and the emulator it uses won't run on
anything but x86, so I see no reason not to add a Kconfig dependency that
reflects this until such a time where it's no longer true.

At least if there's a set of restrictions on something fairly generic,
they tend to be visible, and they also tend to get fixed up over time. We
should however not enable something generically which at the moment is
very much tied to a single platform. Later patches can remove the
dependency at such a time that that assertion no longer holds true.
