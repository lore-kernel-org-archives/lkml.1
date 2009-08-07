Return-Path: <linux-kernel-owner+w=401wt.eu-S1757345AbZHGKVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345AbZHGKVa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 06:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755830AbZHGKV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 06:21:29 -0400
Received: from mail.free-electrons.com ([88.191.76.200]:46805 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261AbZHGKV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 06:21:28 -0400
Date: Fri, 7 Aug 2009 12:21:17 +0200
From: Albin Tonnerre <albin.tonnerre@free-electrons.com>
To: Alain Knaff <alain@knaff.lu>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, sam@ravnborg.org,
       hpa@zytor.com, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 4/6] Add support for LZO-compressed kernels for ARM
Message-ID: <20090807102117.GB4455@laptop>
References: <20090731093107.GA29704@merkur.ravnborg.org>
 <1249311501-23102-1-git-send-email-albin.tonnerre@free-electrons.com>
 <1249311501-23102-2-git-send-email-albin.tonnerre@free-electrons.com>
 <1249311501-23102-3-git-send-email-albin.tonnerre@free-electrons.com>
 <1249311501-23102-4-git-send-email-albin.tonnerre@free-electrons.com>
 <20090806224055.GH31579@n2100.arm.linux.org.uk>
 <20090807092423.GA4455@laptop>
 <4A7BF5B8.4030907@knaff.lu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A7BF5B8.4030907@knaff.lu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 11:36:56AM +0200, Alain Knaff wrote :
> On 08/07/09 11:24, Albin Tonnerre wrote:
> > On Thu, Aug 06, 2009 at 11:40:55PM +0100, Russell King - ARM Linux wrote :
> >> On Mon, Aug 03, 2009 at 04:58:19PM +0200, Albin Tonnerre wrote:
> >>> This is the second part of patch. This part includes:
> >>>  - changes to ach/arch/boot/Makefile to make it easier to add new
> >>>    compression types
> >>>  - new piggy.lzo.S necessary for lzo compression
> >>>  - changes in arch/arm/boot/compressed/misc.c to allow the use of lzo or
> >>>    gzip, depending on the config
> >>>  - Kconfig support

> >> FYI, with these patches applied and selecting GZIP method, I get
> >> linker errors.  I've been unable to track down what's going on, but
> >> it appears to be a libgcc issue.

> >> In spite of the decompressor being built as an EABI object, gcc seems
> >> to be issuing calls to __umodsi3, which isn't in the EABI libgcc
> >> (they're called something different - don't ask.)

> > I also happen to have issues related to the linker not finding __aeabi_uidivmod,
> > but only when compiling with CONFIG_CC_OPTIMIZE_FOR_SIZE. Is it similar for you,
> > or does it also fail when compiling with -O2 ?

> >> So I think these patches need further testing and evaluation on ARM
> >> before they can be merged.  Moreover, I'd like to see some comparisons
> >> between the _current_ gzip method, the new gzip method and the lzo
> >> method on ARM.

> > I don't have my ARM platforms at hand, but I'll so these comparisons in a couple
> > days when I access to them again.

> > Regards,

> Could it be that the patches that remove division (zutil.h and inflate.c)
> have somehow not been applied?

Indeed, they've not been applied. However, I'd rather try to understand why
exactly this is an issue when compiling with -Os and not -O2 instead of working
around it by removing the divisions.

Regards,
-- 
Albin Tonnerre, Free Electrons
Kernel, drivers and embedded Linux development,
consulting, training and support.
http://free-electrons.com
