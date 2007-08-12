Return-Path: <linux-kernel-owner+w=401wt.eu-S934764AbXHLM76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934764AbXHLM76 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 08:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759571AbXHLM7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 08:59:47 -0400
Received: from ns2.suse.de ([195.135.220.15]:60368 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756490AbXHLM7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 08:59:47 -0400
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Petr Vandrovec <petr@vandrovec.name>, discuss@x86-64.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] Fix triplefault on x86-64 bootup
References: <20070812081252.GA23309@vana.vc.cvut.cz>
	<20070812104606.GA5871@martell.zuzino.mipt.ru>
From: Andi Kleen <andi@firstfloor.org>
Date: 12 Aug 2007 15:53:57 +0200
In-Reply-To: <20070812104606.GA5871@martell.zuzino.mipt.ru>
Message-ID: <p73643kkgei.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan <adobriyan@gmail.com> writes:

> On Sun, Aug 12, 2007 at 10:12:52AM +0200, Petr Vandrovec wrote:
> > --- a/arch/x86_64/lib/memcpy.S
> > +++ b/arch/x86_64/lib/memcpy.S
> > @@ -124,6 +124,8 @@ ENDPROC(__memcpy)
> >  	.quad memcpy
> >  	.quad 1b
> >  	.byte X86_FEATURE_REP_GOOD
> > -	.byte .Lfinal - memcpy
> > +	/* Replace only beginning, memcpy is used to apply alternatives, so it
> > +	 * is silly to overwrite itself with nops - reboot is only outcome... */
> > +	.byte 2b - 1b
> >  	.byte 2b - 1b
> >  	.previous
> 
> Thanks, this fixes E6400 reboots on bootup here.

Please test with only ab144f5ec64c42218a555ec1dbde6b60cf2982d6
applied (or rather a few patches back in the git history) 
I bet that fixes it already.

-Andi
