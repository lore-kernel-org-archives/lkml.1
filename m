Return-Path: <linux-kernel-owner+w=401wt.eu-S1762258AbZARDKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762258AbZARDKi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 22:10:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755938AbZARDKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 22:10:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:41342 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671AbZARDKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 22:10:18 -0500
Subject: Re: [GIT PULL -tip] fix 33 make headers_check warnings
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, urs.thuermann@volkswagen.de,
       oliver.hartkopp@volkswagen.de, linux-media@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
       bfields@fieldses.org, neilb@suse.de, linux-nfs@vger.kernel.org,
       linux-raid@vger.kernel.org, dbrownell@users.sourceforge.net,
       spi-devel-general@lists.sourceforge.net, netdev@vger.kernel.org,
       greg@kroah.com, linux-usb@vger.kernel.org,
       linux-mtd@lists.infradead.org, tiwai@suse.de, mchehab@infradead.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090117221932.GA4956@uranus.ravnborg.org>
References: <1232223441.3966.22.camel@localhost.localdomain>
	 <1232228261.27094.0.camel@macbook.infradead.org>
	 <20090117221932.GA4956@uranus.ravnborg.org>
Content-Type: text/plain
Date: Sun, 18 Jan 2009 08:35:01 +0530
Message-Id: <1232247901.3097.12.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-3.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sam, David,

On Sat, 2009-01-17 at 23:19 +0100, Sam Ravnborg wrote:
> On Sun, Jan 18, 2009 at 08:37:41AM +1100, David Woodhouse wrote:
> > On Sun, 2009-01-18 at 01:47 +0530, Jaswinder Singh Rajput wrote:
> > > --- a/include/linux/dvb/audio.h
> > > +++ b/include/linux/dvb/audio.h
> > > @@ -24,9 +24,8 @@
> > >  #ifndef _DVBAUDIO_H_
> > >  #define _DVBAUDIO_H_
> > >  
> > > -#ifdef __KERNEL__
> > >  #include <linux/types.h>
> > > -#else
> > > +#ifndef __KERNEL__
> > >  #include <stdint.h>
> > >  #endif
> > >  
> > 
> > That patch looks wrong, and unnecessary. It was fine before.
> Nope - include/linux/dvb/audio.h failed to include linux/types.h
> despite the fact that is uses __u32 etc.
> 

  CHECK   include/mtd (6 files)
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/mtd/jffs2-user.h:20: extern's make no sense in userspace

--
include/mtd/jffs2-user.h:

extern int target_endian;

#define t16(x) ({ uint16_t __b = (x); (target_endian==__BYTE_ORDER)?__b:bswap_16(__b); })
#define t32(x) ({ uint32_t __b = (x); (target_endian==__BYTE_ORDER)?__b:bswap_32(__b); })
--

In above case extern is OK or not ?

Do we have some better alternative.

Thanks
--
JSR

