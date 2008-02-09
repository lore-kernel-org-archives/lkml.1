Return-Path: <linux-kernel-owner+w=401wt.eu-S1754749AbYBIFYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbYBIFYO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 00:24:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750862AbYBIFX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 00:23:58 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:34205 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750765AbYBIFX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 00:23:57 -0500
Subject: Re: REPOST: [PATCH] Add iSCSI iBFT support (v0.4.7)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Konrad Rzeszutek <konrad@darnok.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>, michaelc@cs.wisc.edu, dwm@enoyolf.org,
       darnok@68k.org, pjones@redhat.com, konradr@redhat.com,
       konradr@linux.vnet.ibm.com, randy.dunlap@oracle.com, hpa@zytor.com,
       lenb@kernel.org, mike.anderson@us.ibm.com, dwm@austin.ibm.com,
       arjan@infradead.org, Andy Whitcroft <apw@shadowen.org>
In-Reply-To: <20080209031026.GA14878@andromeda.dapyr.net>
References: <20080208194717.GA10712@andromeda.dapyr.net>
	 <20080209031026.GA14878@andromeda.dapyr.net>
Content-Type: text/plain
Date: Fri, 08 Feb 2008 23:23:48 -0600
Message-Id: <1202534628.3102.103.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-08 at 23:10 -0400, Konrad Rzeszutek wrote:
> +       ibft_device = kmalloc(len, GFP_KERNEL);
> +       if (!ibft_device)
> +               return -ENOMEM;
> +
> +       memcpy(ibft_device, hdr, len);

This piece looks a bit odd.  you're making ibft_device an exact
duplicate of ibft_addr (which is reserved in bootmem and lives as long
as the kernel does).  I can't seem to find anywhere you actually modify
ibft_device, so why not just use the original ibft_addr here instead of
making a copy?

James


