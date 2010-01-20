Return-Path: <linux-kernel-owner+w=401wt.eu-S1754881Ab0ATWxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab0ATWxk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 17:53:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596Ab0ATWxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 17:53:39 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:41271 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865Ab0ATWx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 17:53:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=osUq3pglXXuiowm8u6IcHFUqmBfOjpE++OFD8zUFd4DlhQxgZngGvQcwfAycPDLxpI
         ZJW7rILXjiFtYCiwnt+trkxKydBXyl8enCZNUf1CcqREfM/xWhOyg1zOLptGVxQ6ZdX+
         WBfEFwDa1IwFR4PFCutrApYOSzEMld6BWTq3U=
Date: Wed, 20 Jan 2010 23:53:22 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Miller <davem@davemloft.net>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Michael Breuer <mbreuer@majjas.com>, akpm@linux-foundation.org,
       flyboy@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Michael Chan <mchan@broadcom.com>, Don Fry <pcnet32@verizon.net>,
       Francois Romieu <romieu@fr.zoreil.com>,
       Matt Carlson <mcarlson@broadcom.com>
Subject: Re: [PATCH] sky2: Fix WARNING: at lib/dma-debug.c:902 check_sync
Message-ID: <20100120225322.GC3072@del.dom.local>
References: <20100120094103.GA6225@ff.dom.local>
 <20100120222414.57909d14@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100120222414.57909d14@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 10:24:14PM +0000, Alan Cox wrote:
> > > Seems like an underlying bug in the DMA api. Maybe it just can't
> > > handle operations on partial mapping.
> > > 
> > > Other drivers with same problem:
> > >   bnx2, cassini, pcnet32, r8169, rrunner, skge, sungem, tg3, 
> > 
> > It seems using the same length (even without pci_unmap_len()) is
> > crucial here, but I hope maintainers (added to CC) will take care.
> 
> The API needs fixing - if you've got a large mapping and you want to sync
> part of it then we need to support that. Now it might well be that the
> implementation on some braindead platform has to sync the entire thing,
> and some implementations entire pages or cache lines.
> 
> You can't fix this in the drivers, they requested a service and they
> don't have enough information nor is it their job to know about all the
> platform specific rules.

Yes, the need to repeat some other values if there is a dedicated
structure/pointer could be misleading. Btw, it seems to be a trivial
overlooking since there is dma_sync_single_range() ready to use.

Jarek P.
