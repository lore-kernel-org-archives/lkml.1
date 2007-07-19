Return-Path: <linux-kernel-owner+w=401wt.eu-S1763513AbXGSUrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763513AbXGSUrf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 16:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763195AbXGSUrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 16:47:25 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:42902 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763180AbXGSUrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 16:47:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=hoHV3vCS4AT/NGCl3zIbXWBnrT+UBbMXkcP6RqGCCuTDdiT4B2+opVRyXMSRavVO5TCr9DP7/FzwzzXXZW50mvuobIuHarw4s6HF6Y90JQfpCYPbtABf7Oe+EIK0yYDCY2d9WgjAW916lKCMKRBWOZb602h1j4h2DPq485BDbvU=
Date: Fri, 20 Jul 2007 00:47:18 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RFC] Remove R/W semaphore content from generic semaphore.h headers.
Message-ID: <20070719204718.GD6524@martell.zuzino.mipt.ru>
References: <Pine.LNX.4.64.0707190530040.19703@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707190530040.19703@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2007 at 05:37:58AM -0400, Robert P. J. Day wrote:
> apparently, for historical reasons, virtually every generic
> semaphore.h header file includes the more specific rwsem.h header
> file.  this is probably a bad thing, since someone who wants only a
> generic semaphore shouldn't be forced to include rwsem definitions as
> well if they don't need them.
>
> this patch removes all of those extraneous definitions, as well as
> some other rwsem-related cruft.  however, i wouldn't try to apply this
> patch as is since it's almost guaranteed to introduce breakage.
> chances are, there are some places in the code that use R/W semaphores
> but are just *coincidentally* getting those definitions via
> semaphore.h so everything works just fine.  as soon as you remove that
> include of <linux/rwsem.h> ... boom.
>
> the better solution would be for each arch maintainer to do this
> cleanup for their own code, if they think it's worth it.

No, the better solution is to setup a bunch of cross compilers instead
of asking arch maintainers to clean up after you. If you don't want to
do it, that's fine, but then refrain from touching core headers.

> (note the
> occasional definition of the macro RW_LOCK_BIAS, which also seems out
> of place in a generic semaphore.h header file, and which clearly
> belongs in rwsem.h.)
>
>  include/asm-alpha/semaphore.h     |    1 -
>  include/asm-arm/semaphore.h       |    1 -
>  include/asm-arm26/semaphore.h     |    1 -
>  include/asm-avr32/semaphore.h     |    1 -
>  include/asm-cris/semaphore.h      |    3 ---
>  include/asm-frv/semaphore.h       |    3 ---
>  include/asm-h8300/semaphore.h     |    1 -
>  include/asm-i386/semaphore.h      |    1 -
>  include/asm-ia64/semaphore.h      |    1 -
>  include/asm-m32r/semaphore.h      |    1 -
>  include/asm-m68k/semaphore.h      |    1 -
>  include/asm-m68knommu/semaphore.h |    1 -
>  include/asm-mips/semaphore.h      |    8 --------
>  include/asm-parisc/semaphore.h    |    1 -
>  include/asm-powerpc/semaphore.h   |    8 --------
>  include/asm-s390/semaphore.h      |    1 -
>  include/asm-sh/semaphore.h        |    1 -
>  include/asm-sh64/semaphore.h      |    1 -
>  include/asm-sparc/semaphore.h     |    1 -
>  include/asm-sparc64/semaphore.h   |    1 -
>  include/asm-v850/semaphore.h      |    1 -
>  include/asm-x86_64/semaphore.h    |    2 --
>  include/asm-xtensa/semaphore.h    |    1 -
>  23 files changed, 42 deletions(-)

