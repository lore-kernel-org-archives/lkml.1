Return-Path: <linux-kernel-owner+w=401wt.eu-S1760831AbYFEQT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760831AbYFEQT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 12:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756326AbYFEQTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 12:19:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49947 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760733AbYFEQTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 12:19:11 -0400
Date: Thu, 5 Jun 2008 09:19:01 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
cc: =?ISO-8859-15?Q?Alejandro_Riveira_Fern=E1ndez?= 
	<ariveira@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Linux 2.6.26-rc5
In-Reply-To: <200806051012.07457.bjorn.helgaas@hp.com>
Message-ID: <alpine.LFD.1.10.0806050917020.3473@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0806042018060.3473@woody.linux-foundation.org> <20080605150306.18c00bd9@Varda> <alpine.LFD.1.10.0806050749570.3473@woody.linux-foundation.org> <200806051012.07457.bjorn.helgaas@hp.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 5 Jun 2008, Bjorn Helgaas wrote:
>  
>  	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_MEM, i)); i++) {
> -		if (res->flags & IORESOURCE_DISABLED)
> +		if (res->flags & IORESOURCE_UNSET ||
> +		    res->flags & IORESOURCE_DISABLED)
>  			continue;

Umm. If I was a compiler, I'd be warning about this. You don't get a 
warning about suggesting parentheses around the '&'?

Also, regardless of lack of warnings, the natural way to do this is to 
just say

	if (res->flags & (IORESOURCE_DISABLED | IORESOURCE_UNSET))
		continue;

which is what any sane compiler would rewrite it to anyway, but since it's 
not just more readable for computers, but for humans too, why not do it 
that way?

			Linus
