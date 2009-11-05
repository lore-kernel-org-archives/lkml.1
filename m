Return-Path: <linux-kernel-owner+w=401wt.eu-S1753368AbZKEBp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbZKEBp4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 20:45:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbZKEBp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 20:45:56 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:47146 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbZKEBpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 20:45:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=rxiAZKtTD6LxFrsjtCifOuAOsT4SXlRvrVoFzpAr0NPbTgHe5L4MLWThEdHd8gy7WD
         NhCi//8v36UVOP5qQRP2j8hxUMvw/+B90IL4qNrcHCH8qQtLcT+DywKILO4nv2smUUwk
         g4AP7FTW/xWDI4u+/lLIblUWfMgIShp9Xw+Ws=
Subject: Re: [PATCH -queue v0 1/6] [loongson] add basic loongson-2f support
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Arnaud Patard <apatard@mandriva.com>, linux-mips@linux-mips.org,
       LKML <linux-kernel@vger.kernel.org>, huhb@lemote.com, yanh@lemote.com,
       Zhang Le <r0bertz@gentoo.org>, Thomas Gleixner <tglx@linutronix.de>,
       Nicholas Mc Guire <der.herr@hofr.at>, zhangfx@lemote.com,
       liujl@lemote.com
In-Reply-To: <20091104201520.GA26504@linux-mips.org>
References: <cover.1257325319.git.wuzhangjin@gmail.com>
	 <a1bd2470bc465e505281c761adca8c2287d102b3.1257325319.git.wuzhangjin@gmail.com>
	 <m3iqdqtwgk.fsf@anduin.mandriva.com>
	 <1257332652.8716.5.camel@falcon.domain.org>
	 <20091104111957.GA13549@linux-mips.org>
	 <1257348226.16033.4.camel@falcon.domain.org>
	 <20091104201520.GA26504@linux-mips.org>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Thu, 05 Nov 2009 09:39:36 +0800
Message-ID: <1257385176.16033.17.camel@falcon.domain.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-04 at 21:15 +0100, Ralf Baechle wrote:
> On Wed, Nov 04, 2009 at 11:23:46PM +0800, Wu Zhangjin wrote:
> 
> > > We have other systems where 32-bit kernel support is just remarkably ugly.
> > > We've dropped 32-bit support for the SGI IP32 aka O2 - nobody seems to even
> > > have really noticed that.  The Sibyte systems would be good candidates to do
> > > the same as accesses to outside the 32-bit address space are needed very
> > > frequently.
> > > 
> > 
> > So, we really remove the 32bit support?
> > 
> > 1312 config CPU_LOONGSON2
> > 1313         bool
> > 1314         select CPU_SUPPORTS_32BIT_KERNEL  --> remove it?
> > 1315         select CPU_SUPPORTS_64BIT_KERNEL
> > 1316         select CPU_SUPPORTS_HIGHMEM
> > 
> > If you all agree, I will send a new patch to remove the above line and
> > resend the corresponding patches without 32bit support, and removed the
> > relative CONFIG_64BIT lines in the patches too.
> 
> If you need highmem with 32-bit (and with Loongson systems I assume that
> virtually all systems will have enough RAM to require that) then you're
> almost certainly better off going 64-bit.  Highmem takes a performance toll
> which for some workloads can be very significant.  And while highmem won't
> go away any time soon it's nothing kernel performance is being tuned for,
> so it's only going to get worse into the future so I'd not waste time on
> highmem unless I have to.
> 

What I have mentioned: "perhaps some guys need the 32bit version" here
means, perhaps some embedded systems without enough memory and enough
storage space may need the 32bit version, they not need highmem and
also, the 32bit version will save some storage space for them. and I
have used the 32bit version on my box and notebook(of course, only for
experiments), no obvious problems.

Reserve the 32bit version as an choice and select 64bit by default in
the default config file?

Regards,
	Wu Zhangjin

