Return-Path: <linux-kernel-owner+w=401wt.eu-S1763329AbZFNUUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763329AbZFNUUf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 16:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755378AbZFNUU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 16:20:26 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:59718 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623AbZFNUUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 16:20:25 -0400
Date: Sun, 14 Jun 2009 22:22:44 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Tim Abbott <tabbott@ksplice.com>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux arch <linux-arch@vger.kernel.org>,
       Anders Kaseorg <andersk@ksplice.com>
Subject: Re: [PATCH] Improve vmlinux.lds.h support for arch specific linker scripts
Message-ID: <20090614202244.GA2951@uranus.ravnborg.org>
References: <20090607185430.GA15299@uranus.ravnborg.org> <alpine.DEB.1.10.0906112032560.9154@vinegar-pot.mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0906112032560.9154@vinegar-pot.mit.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 10:52:06AM -0400, Tim Abbott wrote:
> On Sun, 7 Jun 2009, Sam Ravnborg wrote:
> 
> > Please review and comment..
> > It will be part of kbuild-next.git
> 
> This patch looks great.  I have a few very minor comments.
> 
> > + *	/DISCARD/ : {
> > + *		EXIT_TEXT
> > + *		EXIT_DATA
> > + *		*(.exitcall.exit)
> > + *	}
> 
> I recommend adding
> 
> #define EXIT_CALL *(.exitcall.exit)
> 
> and using it in the DISCARD section of the sample linker script so that 
> the sample linker script doesn't use any raw section names.
> 
> > +#define BSS_SECTION(sbss_align, bss_align)				\
> > +	SBSS								\
> > +	BSS(bss_align)							\
> > +	. = ALIGN(4);							\
> 
> This macro should end with the 'ALIGN(4);' -- there's an extra backslash 
> at the end of the line.
> 
> I recommend changing HEAD_SECTION to HEAD_TEXT_SECTION to better fit the 
> naming scheme.  This would involve deleting the recently added 
> include/linux/section-names.h and going back to hardcoding .head.text in 
> include/linux/init.h (given the way these macros have turned out, 
> include/linux/section-names.h doesn't really make sense).
> 
I fixed the above in a separate commit, so

> Also, the commit message misspells 'alignment', 'linker', and 'Abbott'.
these were not addressed.

	Sam
