Return-Path: <linux-kernel-owner+w=401wt.eu-S1751550AbZKEIoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550AbZKEIoW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 03:44:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751172AbZKEIoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 03:44:21 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:58272 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbZKEIoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 03:44:20 -0500
Date: Thu, 5 Nov 2009 09:45:37 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: Arnaud Patard <apatard@mandriva.com>, linux-mips@linux-mips.org,
       LKML <linux-kernel@vger.kernel.org>, huhb@lemote.com, yanh@lemote.com,
       Zhang Le <r0bertz@gentoo.org>, Thomas Gleixner <tglx@linutronix.de>,
       Nicholas Mc Guire <der.herr@hofr.at>, zhangfx@lemote.com,
       liujl@lemote.com
Subject: Re: [PATCH -queue v0 1/6] [loongson] add basic loongson-2f support
Message-ID: <20091105084537.GA12582@linux-mips.org>
References: <cover.1257325319.git.wuzhangjin@gmail.com> <a1bd2470bc465e505281c761adca8c2287d102b3.1257325319.git.wuzhangjin@gmail.com> <m3iqdqtwgk.fsf@anduin.mandriva.com> <1257332652.8716.5.camel@falcon.domain.org> <20091104111957.GA13549@linux-mips.org> <1257348226.16033.4.camel@falcon.domain.org> <20091104201520.GA26504@linux-mips.org> <1257385176.16033.17.camel@falcon.domain.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257385176.16033.17.camel@falcon.domain.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 05, 2009 at 09:39:36AM +0800, Wu Zhangjin wrote:

> > > > We have other systems where 32-bit kernel support is just remarkably ugly.
> > > > We've dropped 32-bit support for the SGI IP32 aka O2 - nobody seems to even
> > > > have really noticed that.  The Sibyte systems would be good candidates to do
> > > > the same as accesses to outside the 32-bit address space are needed very
> > > > frequently.
> > > > 
> > > 
> > > So, we really remove the 32bit support?
> > > 
> > > 1312 config CPU_LOONGSON2
> > > 1313         bool
> > > 1314         select CPU_SUPPORTS_32BIT_KERNEL  --> remove it?
> > > 1315         select CPU_SUPPORTS_64BIT_KERNEL
> > > 1316         select CPU_SUPPORTS_HIGHMEM
> > > 
> > > If you all agree, I will send a new patch to remove the above line and
> > > resend the corresponding patches without 32bit support, and removed the
> > > relative CONFIG_64BIT lines in the patches too.
> > 
> > If you need highmem with 32-bit (and with Loongson systems I assume that
> > virtually all systems will have enough RAM to require that) then you're
> > almost certainly better off going 64-bit.  Highmem takes a performance toll
> > which for some workloads can be very significant.  And while highmem won't
> > go away any time soon it's nothing kernel performance is being tuned for,
> > so it's only going to get worse into the future so I'd not waste time on
> > highmem unless I have to.
> > 
> 
> What I have mentioned: "perhaps some guys need the 32bit version" here
> means, perhaps some embedded systems without enough memory and enough
> storage space may need the 32bit version, they not need highmem and
> also, the 32bit version will save some storage space for them. and I
> have used the 32bit version on my box and notebook(of course, only for
> experiments), no obvious problems.
> 
> Reserve the 32bit version as an choice and select 64bit by default in
> the default config file?

No problem - I was just expressing my expressing my experiences on the
usefulness of supporting both settings.  One usually tends up favored, the
other little used.

  Ralf
