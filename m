Return-Path: <linux-kernel-owner+w=401wt.eu-S935315AbXHLNMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935315AbXHLNMn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 09:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934643AbXHLNMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 09:12:33 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:16087 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760497AbXHLNMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 09:12:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=lrdCeY+yIIIOEB9KvfU78x3YDCLzEOwpdwr33fKVj2R4nU4QSomHx3WzBC8O10PFVHYZRqZDRDNYeIx41OUQptGy/WBpybTp44N9+3UXMNNUGTVVSGffuRtdNRVSLiisDD++NdO13rPTPP84LvYG7Iv70aCsliNKjRcTx5emML8=
Date: Sun, 12 Aug 2007 17:12:27 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Petr Vandrovec <petr@vandrovec.name>, discuss@x86-64.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] Fix triplefault on x86-64 bootup
Message-ID: <20070812131227.GB5871@martell.zuzino.mipt.ru>
References: <20070812081252.GA23309@vana.vc.cvut.cz> <20070812104606.GA5871@martell.zuzino.mipt.ru> <p73643kkgei.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73643kkgei.fsf@bingen.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 12, 2007 at 03:53:57PM +0200, Andi Kleen wrote:
> Alexey Dobriyan <adobriyan@gmail.com> writes:
> 
> > On Sun, Aug 12, 2007 at 10:12:52AM +0200, Petr Vandrovec wrote:
> > > --- a/arch/x86_64/lib/memcpy.S
> > > +++ b/arch/x86_64/lib/memcpy.S
> > > @@ -124,6 +124,8 @@ ENDPROC(__memcpy)
> > >  	.quad memcpy
> > >  	.quad 1b
> > >  	.byte X86_FEATURE_REP_GOOD
> > > -	.byte .Lfinal - memcpy
> > > +	/* Replace only beginning, memcpy is used to apply alternatives, so it
> > > +	 * is silly to overwrite itself with nops - reboot is only outcome... */
> > > +	.byte 2b - 1b
> > >  	.byte 2b - 1b
> > >  	.previous
> > 
> > Thanks, this fixes E6400 reboots on bootup here.
> 
> Please test with only ab144f5ec64c42218a555ec1dbde6b60cf2982d6
> applied (or rather a few patches back in the git history) 
> I bet that fixes it already.

Sorry?
/me pulls
/me recompiles
/me sees reboot on boot
/me goes in short unprejudiced bisect session
bisections points to "i386: Make patching more robust, fix paravirt issue"
/me sees Petr's patch
above patch fixes problem

