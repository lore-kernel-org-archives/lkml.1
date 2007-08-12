Return-Path: <linux-kernel-owner+w=401wt.eu-S933740AbXHLKqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933740AbXHLKqV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 06:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755431AbXHLKqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 06:46:13 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:50365 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336AbXHLKqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 06:46:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=EHlfwGpcOWIot1f88L/fZyySHROH02nAapd5u6LKHHpxLD0h1pc/MJV6m0IxyqfktgAsoOxlo9+1WcOGiicONOeqKyKMTutIzGjyiiOVT/MGSWyq/l45UB2OlZUGkHq5Is4guSs+O8ekJjoKbaI3igmlJGdImY7X1PGEKVdx6uM=
Date: Sun, 12 Aug 2007 14:46:06 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Petr Vandrovec <petr@vandrovec.name>
Cc: ak@suse.de, discuss@x86-64.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] Fix triplefault on x86-64 bootup
Message-ID: <20070812104606.GA5871@martell.zuzino.mipt.ru>
References: <20070812081252.GA23309@vana.vc.cvut.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070812081252.GA23309@vana.vc.cvut.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 12, 2007 at 10:12:52AM +0200, Petr Vandrovec wrote:
> --- a/arch/x86_64/lib/memcpy.S
> +++ b/arch/x86_64/lib/memcpy.S
> @@ -124,6 +124,8 @@ ENDPROC(__memcpy)
>  	.quad memcpy
>  	.quad 1b
>  	.byte X86_FEATURE_REP_GOOD
> -	.byte .Lfinal - memcpy
> +	/* Replace only beginning, memcpy is used to apply alternatives, so it
> +	 * is silly to overwrite itself with nops - reboot is only outcome... */
> +	.byte 2b - 1b
>  	.byte 2b - 1b
>  	.previous

Thanks, this fixes E6400 reboots on bootup here.

