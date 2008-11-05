Return-Path: <linux-kernel-owner+w=401wt.eu-S1755218AbYKERUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbYKERUK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 12:20:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbYKERT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 12:19:56 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:8682 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbYKERT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 12:19:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=cVq9s1Irn7KnPbzOIbwPLhvy6P7VIVR0lUiecWORaztcWEv/uLWA5uwknKMmS+obnk
         DMb1moYjQuLVmguiFvmUpMu+e9NMoXIOETskofsD3nNpYKrudJeVKSbvsrZSXDL+zc2v
         lASTu2Y5kGcWGnLsrJZm3QgrVukgOIs+GB2nU=
Date: Wed, 5 Nov 2008 20:23:12 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Always include <linux/types.h>
Message-ID: <20081105172312.GA10585@x200.localdomain>
References: <491073BB.4000900@panasas.com> <1225817069-5969-1-git-send-email-bharrosh@panasas.com> <20081104180347.GA9818@uranus.ravnborg.org> <20081105163941.GB6561@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081105163941.GB6561@logfs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2008 at 05:39:41PM +0100, Jörn Engel wrote:
> Hardly any file in the kernel can be compiled without including
> <linux/types.h>, directly or indirectly.  And I'd wager a beer that
> noone can find a non-trivial example.  I couldn't.
> 
> So instead of sprinkling even more #include <linux/types.h> everywhere -
> 140 headers in include/linux/ would need that to compile standalone -
> let us just pass it automatically.
> 
> The existing 4000 odd includes for types.h, plus some 300 each for
> compiler.h and stddef.h, which get pulled through types.h, can get
> removed at leasure.
> 
> --- a/Makefile
> +++ b/Makefile
> @@ -326,7 +326,8 @@ AFLAGS_KERNEL	=
>  # Needed to be compatible with the O= option
>  LINUXINCLUDE    := -Iinclude \
>                     $(if $(KBUILD_SRC),-Iinclude2 -I$(srctree)/include) \
> -		   -include include/linux/autoconf.h
> +		   -include include/linux/autoconf.h \
> +		   -include include/linux/types.h

This is only going to slow down compilation and types.h is not causing much
compilation problems, in fact, I can't recall a compilation problem due to
types.h. Contary to config.h situation which was a pain.
