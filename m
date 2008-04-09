Return-Path: <linux-kernel-owner+w=401wt.eu-S1755446AbYDIRwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbYDIRwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 13:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754076AbYDIRwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 13:52:00 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55404 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbYDIRv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 13:51:59 -0400
Date: Wed, 9 Apr 2008 19:56:29 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Hastings <abh@cray.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org, pj@sgi.com,
       linux-mm@kvack.org, nickpiggin@yahoo.com.au
Subject: Re: [PATCH] [12/18] Add support to allocate hugetlb pages that are larger than MAX_ORDER
Message-ID: <20080409175629.GE30885@one.firstfloor.org>
References: <20080317258.659191058@firstfloor.org> <20080317015826.110AA1B41E0@basil.firstfloor.org> <47FCE93D.4090509@cray.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47FCE93D.4090509@cray.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This looks like an off-by-one error here and in the code below -- it 
> should be ">= MAX_ORDER" not "> MAX_ORDER".  Cf alloc_pages() in gfp.h:
> 
>         if (unlikely(order >= MAX_ORDER))
>                 return NULL;

True good point. Although it will only matter if some architecture
has MAX_ORDER sized huge pages :) x86-64 definitely hasn't.

I passed this code over to Nick so he'll hopefully incorporate the fix.

-Andi
