Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752198AbYLQRQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbYLQRQn (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 12:16:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbYLQRQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 12:16:33 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:39937 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbYLQRQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 12:16:33 -0500
Date: Wed, 17 Dec 2008 18:18:00 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, geert@linux-m68k.org, dhowells@redhat.com,
        gerg@uclinux.org
Subject: Re: [PATCH] get rid of the last symlink in uml build
Message-ID: <20081217171800.GA5436@uranus.ravnborg.org>
References: <20081217061250.GX28946@ZenIV.linux.org.uk> <20081217072620.GA3551@uranus.ravnborg.org> <20081217083734.GA28946@ZenIV.linux.org.uk> <20081217085539.GA4152@uranus.ravnborg.org> <20081217091058.GB28946@ZenIV.linux.org.uk> <20081217112723.GA5027@uranus.ravnborg.org> <20081217170257.GE28946@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081217170257.GE28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 05:02:57PM +0000, Al Viro wrote:
> 	BTW, after taking a look at the remaing asm-*...
> 
> * frv, m32r and h8300 should be as trivial as git mv

Yep - I already have positive feedback from arch maintainers that
they will fix it in the -rc1 timeframe.

> * m68k has a bit of extra PITA - we need to clean up two non-trivial
>   includes from m68knommu (pci.h and setup.h) first, then it's a matter
>   of git mv, adding arch/m68k/include to search path on m68knommu and
>   removal of dummy headers from the latter.

I took a different route here and unified the headers for m68k and m68knommu
under arch/m68k/include/asm
It was based on a script originally developed by Arnd Bergmann.

Geert already acked it, and I expect Greg to apply it in the -rc1 timeframe.

http://marc.info/?l=linux-kbuild&m=122927123805002&w=2 has Geert's ack,
but original patch did not hit marc?!?

> * xtensa is already moved in linux-next
Yes.


> * arm seems to be lacking the final push for few remaining headers; presumably
>   will happen eventually
rmk knows it and takes care.

> * mn10300 is playing with symlinks - the last one to do that for headers,
>   AFAICS.
> 
> I've thrown together a patch series on top of linux-next doing m68k and
> mn10300.  *WARNING* - it's completely untested, basically about half an
> hour diversion from sifting through the mailbox for missed VFS patches.
> And that half and hour did *not* include anything resembling building
> the resulting tree.  So take that with a trainload of salt.
Thanks Al.
I will take a closer look at the mn10300 bits and send them to David
in due time.

	Sam
