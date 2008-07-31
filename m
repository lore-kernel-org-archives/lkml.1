Return-Path: <linux-kernel-owner+w=401wt.eu-S1762740AbYGaDZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762740AbYGaDZI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 23:25:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758647AbYGaDYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 23:24:40 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:57932 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762229AbYGaDYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 23:24:37 -0400
Date: Thu, 31 Jul 2008 12:23:38 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Howells <dhowells@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
       Greg Ungerer <gerg@snapgear.com>, Sam Ravnborg <sam@ravnborg.org>,
       linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       uClinux list <uclinux-dev@uclinux.org>
Subject: Re: kbuild now support arch/$ARCH/include - time for ARCHs to convert
Message-ID: <20080731032338.GA14296@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	David Howells <dhowells@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
	Greg Ungerer <gerg@snapgear.com>, Sam Ravnborg <sam@ravnborg.org>,
	linux arch <linux-arch@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Linux/m68k <linux-m68k@vger.kernel.org>,
	uClinux list <uclinux-dev@uclinux.org>
References: <200807300907.25186.arnd@arndb.de> <20080728200500.GA14284@uranus.ravnborg.org> <48900EE4.8030606@snapgear.com> <3995.1217410495@redhat.com> <Pine.LNX.4.64.0807301422380.3316@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0807301422380.3316@anakin>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2008 at 02:26:04PM +0200, Geert Uytterhoeven wrote:
> On Wed, 30 Jul 2008, David Howells wrote:
> > Arnd Bergmann <arnd@arndb.de> wrote:
> > 
> > > I think the more interesting aspect in m68knommu is what happens
> > > when asm-m68k gets moved. Does that work as well?
> > 
> > Can m68knommu be merged into m68k and be made contingent on CONFIG_MMU?  This
> > is what FRV does.
> 
> Sure it can ;-)
> 
> Actually I did a bit of work to add nommu support to m68k to make it
> boot on old MMU-less Amigas, but it dates back to the 2.6.8.1 era...
> 
> The bigger issue is in those parts that are done differently by m68k and
> m68knommu (esp. head.S).
> 
> Who's gonna take the work? :-)
> 
This sort of merging is fairly easy to do incrementally, at least by
someone that has both platforms available. An easy first step would be to
move the m68knommu stuff that are implemented differently over as _nommu
files, similar to how the _32/_64 renames happened, and then set about
converging the two little by little. This is what I've been doing with
sh64->sh integration for example, despite fundamental differences like
having a totally different register layout and instruction set.
