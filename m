Return-Path: <linux-kernel-owner+w=401wt.eu-S1422962AbXBHM1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422962AbXBHM1M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 07:27:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422964AbXBHM1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 07:27:12 -0500
Received: from raven.upol.cz ([158.194.120.4]:34140 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422962AbXBHM1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 07:27:10 -0500
Date: Thu, 8 Feb 2007 13:35:40 +0100
To: David Miller <davem@davemloft.net>
Cc: paulus@samba.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: Kbuild change breaks the ppc64 build
Message-ID: <20070208123540.GT22699@flower.upol.cz>
References: <17867.1342.763881.188430@cargo.ozlabs.ibm.com> <20070208.040003.112623191.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070208.040003.112623191.davem@davemloft.net>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 08, 2007 at 04:00:03AM -0800, David Miller wrote:
> From: Paul Mackerras <paulus@samba.org>
> Date: Thu, 8 Feb 2007 22:10:54 +1100
[]
> Linus and Oleg tried to fix it with various subsequent changes
> to scripts/Kbuild.include, but it's still broken.

And Roland McGrath, but it turned to be very bad.

Maybe you have older set of fixes. I have x86-64 and i386 built,
though with make 3.81(debian).

But it may be ppc specific, as

        CFLAGS += $(call cc-option,-mcpu=970)
	else
	CFLAGS += $(call cc-option,-mcpu=power4)

may be turned to be options without spaces (make V=1)!

> For some reason $(call ...) invocations add spaces.  I tried
> another test case:
> 
> define test
>  $(shell echo -n)
> endef
> 
> VAR:=$(call test)
> 
> all:
> 	@echo "\'$(VAR)\'"
> 
> And this always prints:
> 
> ' TEST'
> 
> even with GNU Make version 3.81
> 
> If I put a $(strip ...) around the define, the space is
> still there.  If I put the $(strip ...) around VAR's
> $(call), the space goes away.

____
