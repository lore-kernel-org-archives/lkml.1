Return-Path: <linux-kernel-owner+w=401wt.eu-S1761078AbZEGWNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761078AbZEGWNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 18:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbZEGWNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 18:13:10 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56644 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbZEGWNI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 18:13:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Wright <chrisw@sous-sol.org>
Subject: Re: [RFC PATCH 0/3] generic hypercall support
Date: Fri, 8 May 2009 00:11:52 +0200
User-Agent: KMail/1.9.9
Cc: Gregory Haskins <gregory.haskins@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>, Avi Kivity <avi@redhat.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Anthony Liguori <anthony@codemonkey.ws>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <4A031471.7000406@novell.com> <4A034F0E.6010603@gmail.com> <20090507215712.GI3036@sequoia.sous-sol.org>
In-Reply-To: <20090507215712.GI3036@sequoia.sous-sol.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905080011.52958.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/HELiXjT+v+vhAFRV3muWAKo7/hYBD5ULm70W
 eaUQiYIRAKC98pPhg9jkD9hhASgXft94G6uRbTK74eo3dSIEF6
 ugDLGnld8A+oteEOSmgYA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 May 2009, Chris Wright wrote:
> 
> > Chris, is that issue with the non ioread/iowrite access of a mangled
> > pointer still an issue here?  I would think so, but I am a bit fuzzy on
> > whether there is still an issue of non-wrapped MMIO ever occuring.
> 
> Arnd was saying it's a bug for other reasons, so perhaps it would work
> out fine.

Well, maybe. I only said that __raw_writel and pointer dereference is
bad, but not writel.

IIRC when we had that discussion about io-workarounds on powerpc,
the outcome was that passing an IORESOURCE_MEM resource into pci_iomap
must still result in something that can be passed into writel in addition
to iowrite32, while an IORESOURCE_IO resource may or may not be valid for
writel and/or outl.

Unfortunately, this means that either readl/writel needs to be adapted
in some way (e.g. the address also ioremapped to the mangled pointer)
or the mechanism will be limited to I/O space accesses.

Maybe BenH remembers the details better than me.

	Arnd <><
