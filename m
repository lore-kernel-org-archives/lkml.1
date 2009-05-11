Return-Path: <linux-kernel-owner+w=401wt.eu-S1757214AbZEKR1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214AbZEKR1Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 13:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbZEKR1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 13:27:16 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:44621 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbZEKR1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 13:27:15 -0400
Date: Mon, 11 May 2009 13:25:00 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: Christoph Hellwig <hch@infradead.org>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/asm] x86, 64-bit: ifdef out struct thread_struct::ip
In-Reply-To: <b6fcc0a0905111022g1df0b1c5l95c2a072745578a0@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0905111323470.28914@localhost.localdomain>
References: <20090503233015.GJ16631@x200.localdomain>  <tip-0c23590f00f85467b318ad0c20c36796a5bd4c60@git.kernel.org>  <20090511160324.GA7923@infradead.org> <b6fcc0a0905111022g1df0b1c5l95c2a072745578a0@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1531755699-1242062715=:28914"
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1531755699-1242062715=:28914
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Mon, 11 May 2009, Alexey Dobriyan wrote:

> On Mon, May 11, 2009 at 8:03 PM, Christoph Hellwig <hch@infradead.org> wr=
ote:
> > On Mon, May 11, 2009 at 03:09:40PM +0000, tip-bot for Alexey Dobriyan w=
rote:
> >> +#ifdef CONFIG_X86_32
> >> =A0 =A0 =A0 unsigned long =A0 =A0 =A0 =A0 =A0 ip;
> >> +#endif
> >> =A0#ifdef CONFIG_X86_64
> >> =A0 =A0 =A0 unsigned long =A0 =A0 =A0 =A0 =A0 fs;
> >> =A0#endif
> >
> > What happened to the good old concept of #if #else #endif?
>
> #else suggests alternative which is not the case.
> ->ip and ->fs can be in different parts of thread_struct.

  the arch/x86/Kconfig file certainly suggests that those are
mutually-exclusive alternatives:

=2E..
# Select 32 or 64 bit
config 64BIT
        bool "64-bit kernel" if ARCH =3D "x86"
        default ARCH =3D "x86_64"
        ---help---
          Say yes to build a 64-bit kernel - formerly known as x86_64
          Say no to build a 32-bit kernel - formerly known as i386

config X86_32
        def_bool !64BIT

config X86_64
        def_bool 64BIT
=2E..

unless there's something weird going on underneath.

rday
--

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--8323328-1531755699-1242062715=:28914--
