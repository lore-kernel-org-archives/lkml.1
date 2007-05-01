Return-Path: <linux-kernel-owner+w=401wt.eu-S1754035AbXEAFYD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035AbXEAFYD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 01:24:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754368AbXEAFYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 01:24:03 -0400
Received: from mail.suse.de ([195.135.220.2]:37840 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754035AbXEAFYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 01:24:00 -0400
Date: Tue, 1 May 2007 08:21:32 +0200
From: Andi Kleen <ak@suse.de>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Andi Kleen <ak@suse.de>, ebiederm@xmission.com, patches@x86-64.org,
       linux-kernel@vger.kernel.org, bill.irwin@oracle.com
Subject: Re: [PATCH] [30/30] x86_64: Add missing !X86_PAE dependincy to the 2G/2G split.
Message-ID: <20070501062132.GQ25929@bingen.suse.de>
References: <20070501557.815359000@suse.de> <20070501035829.1C93D13CAF@wotan.suse.de> <4636C16F.204@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4636C16F.204@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 06:26:23AM +0200, Eric Dumazet wrote:
> Andi Kleen a ?crit :
> >From: ebiederm@xmission.com
> >
> >When in PAE mode we require that the user kernel divide to be
> >on a 1G boundary.  The 2G/2G split does not have that property
> >so require !X86_PAE
> >
> >Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> >---
> > arch/i386/Kconfig |    1 +
> > 1 files changed, 1 insertions(+), 0 deletions(-)
> >
> >diff --git a/arch/i386/Kconfig b/arch/i386/Kconfig
> >index 1a94a73..80003de 100644
> >--- a/arch/i386/Kconfig
> >+++ b/arch/i386/Kconfig
> >@@ -570,6 +570,7 @@ choice
> > 		depends on !HIGHMEM
> > 		bool "3G/1G user/kernel split (for full 1G low memory)"
> > 	config VMSPLIT_2G
> >+		depends on !X86_PAE
> > 		bool "2G/2G user/kernel split"
> > 	config VMSPLIT_1G
> > 		bool "1G/3G user/kernel split"
> 
> Hum... We lose a usefull 2G/2G split. Should'nt we use a patch to change 
> PAGE_OFFSET to 0x8000000 instead of 0x78000000 and keep 2G/2G split ?

I dropped the patch for now.

> [PATCH] i386 : Adjust CONFIG_PAGE_OFFSET in case of 2G/2G split and X86_PAE
> 
> When in PAE mode we require that the user kernel divide to be
> on a 1G boundary.  We must therefore make sure PAGE_OFFSET is correctlty 
> defined in the 2G/2G split and PAE mode.

Looks reasonable. Did you test both cases? wli, ok for you too?

-Andi
