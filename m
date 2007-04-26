Return-Path: <linux-kernel-owner+w=401wt.eu-S1031279AbXDZPZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031279AbXDZPZM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 11:25:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031287AbXDZPZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 11:25:11 -0400
Received: from ns.suse.de ([195.135.220.2]:43137 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031279AbXDZPZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 11:25:08 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Mel Gorman <mel@skynet.ie>
Subject: Re: 2.6.21-rc7-mm2 -- x86_64 VDSO compile error II
Date: Thu, 26 Apr 2007 17:24:45 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steve Fox <drfickle@us.ibm.com>, Andy Whitcroft <apw@shadowen.org>
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org> <20070426143902.GD16909@skynet.ie> <20070426152039.GF16909@skynet.ie>
In-Reply-To: <20070426152039.GF16909@skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704261724.46027.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> --- build/arch/x86_64/vdso/vdso.lds-orig	2007-04-26 08:18:19.000000000 -0700
> +++ build/arch/x86_64/vdso/vdso.lds	2007-04-26 08:18:23.000000000 -0700
> @@ -33,7 +33,7 @@
>       For the layouts to match, we need to skip more than enough
>       space for the dynamic symbol table et al.  If this amount
>       is insufficient, ld -shared will barf.  Just increase it here.  */
> -  . = 0xffffffffff700000 + 0x500;
> +  . = 0xffffffffff700000 + 0x400;

Hmm, you must have an old version of the patch. in my copy it looks like

  . = VDSO_PRELINK + VDSO_TEXT_OFFSET;

and 

#define VDSO_TEXT_OFFSET 0x400

Can you try the latest patch from ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt/patches/vdso 
?

(doesn't include the -m64 change yet so you will still need to apply that)

-Andi

