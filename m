Return-Path: <linux-kernel-owner+w=401wt.eu-S1755473AbXJ3AKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbXJ3AKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 20:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753203AbXJ3AKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 20:10:33 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:45531 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbXJ3AKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 20:10:32 -0400
X-IronPort-AV: i="4.21,345,1188792000"; 
   d="scan'208"; a="42664297:sNHT37315110"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [patch] remove support for un-needed _extratext section
Date: Mon, 29 Oct 2007 20:11:44 -0400
User-Agent: KMail/1.9.5
Cc: jdl@freescale.com, dwmw2@infradead.org, paulus@samba.org,
       linux-kernel@vger.kernel.org
References: <200710240836.13412.rgetz@blackfin.uclinux.org> <200710261543.57111.rgetz@blackfin.uclinux.org> <20071029152228.78aa5f3e.akpm@linux-foundation.org>
In-Reply-To: <20071029152228.78aa5f3e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710292011.45092.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 30 Oct 2007 00:10:30.0655 (UTC) FILETIME=[4856D0F0:01C81A89]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 29 Oct 2007 18:22, Andrew Morton pondered:

> I hit numerous rejects here.  I am not sure which kernel you patched but
> I suspect it was not an up-to-date one.

Sorry about that - I will do so in the future. Thanks for reviewing and fixing up.

> > --- kernel/kallsyms.c	(revision 3780)
> > +++ kernel/kallsyms.c	(working copy)
> 
> Please prepare patches in `patch -p1' form.  This should have been
> 
> --- foo/kernel/kallsyms.c	(revision 3780)
> +++ bar/kernel/kallsyms.c	(working copy)

Sorry twice.

> >  		 */
> >  		if ((s->addr == _etext && strcmp((char*)s->sym + offset, "_etext")) ||
> > -		    (s->addr == _einittext && strcmp((char*)s->sym + offset, "_einittext")) ||
> > -		    (s->addr == _eextratext && strcmp((char*)s->sym + offset, "_eextratext")))
> > +		    (s->addr == _einittext && strcmp((char*)s->sym + offset, "_einittext")))
> >  			return 0;
> >  	}
> 
> I don't understand why this hunk is changing _einittext handling, and I
> suspect this was a mistake, so I left that bit out.

I didn't think I did change the _einittext handling - just removed
_eextratext, and removed the trailing ||, and closed the parentheses for 
the if statement.

-  (s->addr == _einittext && strcmp((char*)s->sym + offset, "_einittext")) ||
+  (s->addr == _einittext && strcmp((char*)s->sym + offset, "_einittext")))

I think this is the same as what you have here - isn't it?

> -		if ((s->addr == _etext && strcmp((char*)s->sym + offset, "_etext")) ||
> -		    (s->addr == _einittext && strcmp((char*)s->sym + offset, "_einittext")) ||
> -		    (s->addr == _eextratext && strcmp((char*)s->sym + offset, "_eextratext")))
> +		if ((s->addr == _etext &&
> +				strcmp((char*)s->sym + offset, "_etext")) ||
> +		    (s->addr == _einittext &&
> +				strcmp((char*)s->sym + offset, "_einittext")))
>  			return 0;

?
