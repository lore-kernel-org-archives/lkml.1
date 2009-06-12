Return-Path: <linux-kernel-owner+w=401wt.eu-S1764839AbZFLOwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764839AbZFLOwh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 10:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761143AbZFLOw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 10:52:28 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:45387 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756533AbZFLOw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 10:52:27 -0400
Date: Fri, 12 Jun 2009 10:52:06 -0400 (EDT)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@vinegar-pot.mit.edu
To: Sam Ravnborg <sam@ravnborg.org>
cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux arch <linux-arch@vger.kernel.org>,
       Anders Kaseorg <andersk@ksplice.com>
Subject: Re: [PATCH] Improve vmlinux.lds.h support for arch specific linker
 scripts
In-Reply-To: <20090607185430.GA15299@uranus.ravnborg.org>
Message-ID: <alpine.DEB.1.10.0906112032560.9154@vinegar-pot.mit.edu>
References: <20090607185430.GA15299@uranus.ravnborg.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Jun 2009, Sam Ravnborg wrote:

> Please review and comment..
> It will be part of kbuild-next.git

This patch looks great.  I have a few very minor comments.

> + *	/DISCARD/ : {
> + *		EXIT_TEXT
> + *		EXIT_DATA
> + *		*(.exitcall.exit)
> + *	}

I recommend adding

#define EXIT_CALL *(.exitcall.exit)

and using it in the DISCARD section of the sample linker script so that 
the sample linker script doesn't use any raw section names.

> +#define BSS_SECTION(sbss_align, bss_align)				\
> +	SBSS								\
> +	BSS(bss_align)							\
> +	. = ALIGN(4);							\

This macro should end with the 'ALIGN(4);' -- there's an extra backslash 
at the end of the line.

I recommend changing HEAD_SECTION to HEAD_TEXT_SECTION to better fit the 
naming scheme.  This would involve deleting the recently added 
include/linux/section-names.h and going back to hardcoding .head.text in 
include/linux/init.h (given the way these macros have turned out, 
include/linux/section-names.h doesn't really make sense).

Also, the commit message misspells 'alignment', 'linker', and 'Abbott'.

	-Tim Abbott
