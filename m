Return-Path: <linux-kernel-owner+w=401wt.eu-S1752507AbZH0Mil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507AbZH0Mil (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 08:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752444AbZH0Mil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 08:38:41 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:37682 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbZH0Mik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 08:38:40 -0400
Date: Thu, 27 Aug 2009 14:38:40 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@uclinux.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] m68k: avoid pgprot_noncached redefinition
Message-ID: <20090827123840.GA13962@osiris.boeblingen.de.ibm.com>
References: <20090827114157.GA8678@osiris.boeblingen.de.ibm.com>
 <10f740e80908270518u3812b96ew574eabff21f369e5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <10f740e80908270518u3812b96ew574eabff21f369e5@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27, 2009 at 02:18:05PM +0200, Geert Uytterhoeven wrote:
> On Thu, Aug 27, 2009 at 13:41, Heiko Carstens<heiko.carstens@de.ibm.com> wrote:
> > From: Heiko Carstens <heiko.carstens@de.ibm.com>
> >
> > While compiling m68k with defconfig I get tons if these warnings:
> >
> > /home2/heicarst/linux-2.6/arch/m68k/include/asm/pgtable_mm.h:148:1: warning: "pgprot_noncached" redefined
> > In file included from /home2/heicarst/linux-2.6/arch/m68k/include/asm/pgtable_mm.h:138,
> >  from /home2/heicarst/linux-2.6/arch/m68k/include/asm/pgtable.h:4,
> >  from include/linux/mm.h:38,
> >  from /home2/heicarst/linux-2.6/arch/m68k/include/asm/atarihw.h:134,
> >  from arch/m68k/atari/debug.c:20:
> > include/asm-generic/pgtable.h:133:1: warning: this is the location of the previous definition
> >
> > Reason for this is that asm-generic/pgtable.h gets included in pgtable_mm.h
> > before pgprot_noncached gets defined.
> > So the check "#ifndef pgprot_noncached" in the generic header file is too early.
> > Solve this by including the generic header file after the arch define.
> 
> Thanks, but Linus has just pulled the fix last night.

Ah, good! Just stumbled across these when trying to cross compile the
spinlock inline patches on m68k.
To get spinlock inline patches running on m68k some more patches are
needed. I'm going to post them when I've (build) tested more architectures.
