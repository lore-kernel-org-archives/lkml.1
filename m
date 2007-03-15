Return-Path: <linux-kernel-owner+w=401wt.eu-S1751221AbXCORfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751221AbXCORfi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 13:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240AbXCORfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 13:35:38 -0400
Received: from mail.alkar.net ([195.248.191.95]:50154 "EHLO mail.alkar.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbXCORfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 13:35:37 -0400
From: "Vladimir V. Saveliev" <vs@namesys.com>
To: "Nate Diller" <nate.diller@gmail.com>
Subject: Re: [BUG] reiser4: page lock recursion in reiser4_write_extent
Date: Thu, 15 Mar 2007 20:34:29 +0300
User-Agent: KMail/1.8.2
Cc: reiserfs-dev@namesys.com, "Linux Kernel" <linux-kernel@vger.kernel.org>
References: <5c49b0ed0703132240h2087eb12xb44652bf0d235521@mail.gmail.com>
In-Reply-To: <5c49b0ed0703132240h2087eb12xb44652bf0d235521@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703152034.29962.vs@namesys.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

On Wednesday 14 March 2007 08:40, Nate Diller wrote:
> This little code snippet seems to have a page_lock recursion, in
> addition to overall looking particularly fragile to me.  It seems to
> be handling the case where a page needs to be brought uptodate because
> a partial page write is being done.  The page gets locked as many as 3
> times, each checking PageUptodate, however the two failure cases here
> go BUG() instead of returning an error. 

yes, these are to be returned errors

> I'm starting to think that 
> somehow the whole suspect branch just never gets taken, because
> otherwise I would expect to see bug reports related to -EIO, -ENOMEM,
> etc causing this to barf.

> 
[snip]
> 
> BOOM!!!

2.6.21-rc3-mm2 has this bug fixed.

>                 lock_page(page);
>                 if (!PageUptodate(page) && to_page != PAGE_CACHE_SIZE) {
> 
> ---
> 
> NATE
> 
> 
