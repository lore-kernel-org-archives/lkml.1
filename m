Return-Path: <linux-kernel-owner+w=401wt.eu-S1752406AbYCPLz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406AbYCPLz0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 07:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbYCPLzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 07:55:16 -0400
Received: from mo10.iij4u.or.jp ([210.138.174.78]:35503 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611AbYCPLzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 07:55:15 -0400
Date: Sun, 16 Mar 2008 20:55:03 +0900
To: jbeulich@novell.com
Cc: tomof@acm.org, fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] avoid endless loops in lib/swiotlb.c
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <47DA5EF1.76E4.0078.0@novell.com>
References: <47D8FE4A.76E4.0078.0@novell.com>
	<20080314182219P.tomof@acm.org>
	<47DA5EF1.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080316205441G.tomof@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2008 10:18:09 +0000
"Jan Beulich" <jbeulich@novell.com> wrote:

> >> - if the number of slots requested fits into a swiotlb segment, but is
> >>   too large for the part of a segment which remains after considering
> >>   offset_slots
> >
> >Sorry, I'm not sure what you mean. Can you give me an actual example
> >numbers that leads to that?
> 
> For one part, it can happen if nslots > max_slots (which is a driver
> error [except for the case above where max_slots erroneously got set
> to zero], but shouldn't lead to a silent hang, especially as it didn't do so
> before).
> 
> For another part, requesting e.g. a transfer of 128k with a segment
> mask of 128k when the IOTLB isn't aligned to a 128k boundary would
> again lead to a silent hang, as would various cases where the request
> exceeds the segment size (and the segment mask is sufficiently small).
> Neither of these cases got stuck in the old code.
> 
> Beyond that, maybe I was too quick in concluding this could happen
> even in less unusual cases - I think I didn't pay close enough attention
> to the fact that offset_slots + index gets masked by max_slots - 1.
> But even then I think the code looks simpler/safer and is smaller with
> the adjusted logic.

I don't think that the old code hits the problems (endless loops or
silent hang) that you explained, but I agree that the patch made the
code simpler a bit.

Thanks,
