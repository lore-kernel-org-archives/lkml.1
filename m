Return-Path: <linux-kernel-owner+w=401wt.eu-S1762615AbXHUPv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762615AbXHUPv5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 11:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759895AbXHUPvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 11:51:48 -0400
Received: from ms-smtp-06.texas.rr.com ([24.93.47.45]:61949 "EHLO
	ms-smtp-06.texas.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755645AbXHUPvr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 11:51:47 -0400
From: Dave McCracken <dave.mccracken@oracle.com>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [RFC 0/7] Postphone reclaim laundry to write at high water marks
Date: Tue, 21 Aug 2007 10:51:35 -0500
User-Agent: KMail/1.9.7
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20070820215040.937296148@sgi.com>
In-Reply-To: <20070820215040.937296148@sgi.com>
Organization: Oracle Corp
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708211051.36569.dave.mccracken@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 August 2007, Christoph Lameter wrote:
> 1. First reclaiming non dirty pages. Dirty pages are deferred until reclaim
>    has reestablished the high marks. Then all the dirty pages (the laundry)
>    is written out.

I don't buy it.  What happens when there aren't enough clean pages in the 
system to achieve the high water mark?  I'm guessing we'd get a quick OOM (as 
observed by Peter).

> 2. Reclaim is essentially complete during the writeout phase. So we remove
>    PF_MEMALLOC and allow recursive reclaim if we still run into trouble
>    during writeout.

You're assuming the system is static and won't allocate new pages behind your 
back.  We could be back to critically low memory before the write happens.

More broadly, we need to be proactive about getting dirty pages cleaned before 
they consume the system.  Deferring the write just makes it harder to keep 
up.

Dave McCracken
