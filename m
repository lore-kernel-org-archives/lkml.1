Return-Path: <linux-kernel-owner+w=401wt.eu-S1753499AbZDUIDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbZDUIDQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 04:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbZDUICw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 04:02:52 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:54287 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbZDUICu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 04:02:50 -0400
Date: Tue, 21 Apr 2009 16:57:39 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Michal Simek <michal.simek@petalogix.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-arch@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Microblaze noMMU/MMU merge
Message-ID: <20090421075738.GC15167@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Michal Simek <michal.simek@petalogix.com>,
	Ingo Molnar <mingo@elte.hu>, lkml <linux-arch@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Linux Kernel list <linux-kernel@vger.kernel.org>
References: <49ED79AB.10004@petalogix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49ED79AB.10004@petalogix.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 09:45:47AM +0200, Michal Simek wrote:
> I would like to say your opinion about putting together Microblaze MMU
> arch to noMMU version.
> 
> In C code will be #ifdef CONFIG_MMU ... #endif  or #ifndef.
> 
> Here is proposal for headers. The similar style is used in m68k but I
> would like to have the same code
> for both archs in main file.
> 
> #ifndef _ASM_MICROBLAZE_PAGE_H
> #define _ASM_MICROBLAZE_PAGE_H
> 
> code for noMMU and MMU which is the same for both.
> 
> #ifdef __uClinux__
> #include "page_no.h" -> noMMU specific
> #else
> #include "page_mm.h"-> MMU specific
> #endif
> #endif /* _ASM_MICROBLAZE_PAGE_H */
> 
There's really not that much code that you need to change in order to
support nommu, as long as you designed your architecture port to be
fairly compartmentalized. Take a look at some of the other architectures
in-tree that support both in the same architecture backend. sh was the
first to support a configurable CONFIG_MMU during the 2.5 days, but there
are others now as well (though I don't know how actively the others are
maintained -- nommu people tend to be even worse (!) than general
embedded people at hanging around).

In addition to sh, at least frv, m32r, and arm support a configurable
CONFIG_MMU these days. xtensa seems to have just recently joined the
club, too.
