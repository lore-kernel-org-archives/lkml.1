Return-Path: <linux-kernel-owner+w=401wt.eu-S935970AbYEVJ6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935970AbYEVJ6A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 05:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757959AbYEVJ5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 05:57:49 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:43961 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756675AbYEVJ5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 05:57:48 -0400
Message-ID: <48354398.9070307@pobox.com>
Date: Thu, 22 May 2008 05:57:44 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
CC: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/5] sky2: don't warn if page allocation fails
References: <20080515000412.984337700@vyatta.com> <20080515000432.989061538@vyatta.com>
In-Reply-To: <20080515000432.989061538@vyatta.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  
>  	for (i = 0; i < sky2->rx_nfrags; i++) {
> -		struct page *page = alloc_page(GFP_ATOMIC);
> +		struct page *page = alloc_page(GFP_ATOMIC | __GFP_NOWARN);
>  
>  		if (!page)
>  			goto free_partial;


IMO it's inappropriate to add these warnings to net drivers that 
properly check all return values.

This approach is too maintenance intensive, and winds up fixing the same 
problem over and over again -- a hint that the fix is in the wrong place.

	Jeff


