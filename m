Return-Path: <linux-kernel-owner+w=401wt.eu-S934243AbZJGJAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934243AbZJGJAN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 05:00:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933929AbZJGJAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 05:00:12 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:30712 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933950AbZJGJAL convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;4:1>);
	Wed, 7 Oct 2009 05:00:11 -0400
Message-Id: <4ACC749602000078000186ED@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 07 Oct 2009 09:59:34 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Hugh Dickins" <hugh.dickins@tiscali.co.uk>
Cc: <linux-mm@kvack.org>, "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] adjust gfp mask passed on nested vmalloc()
	 invocation
References: <4AC9E38E0200007800017F57@vpn.id2.novell.com>
 <Pine.LNX.4.64.0910062241500.21409@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0910062241500.21409@sister.anvils>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Hugh Dickins <hugh.dickins@tiscali.co.uk> 06.10.09 23:58 >>>
>On Mon, 5 Oct 2009, Jan Beulich wrote:
>
>> - fix a latent bug resulting from blindly or-ing in __GFP_ZERO, since
>>   the combination of this and __GFP_HIGHMEM (possibly passed into the
>>   function) is forbidden in interrupt context
>> - avoid wasting more precious resources (DMA or DMA32 pools), when
>>   being called through vmalloc_32{,_user}()
>> - explicitly allow using high memory here even if the outer allocation
>>   request doesn't allow it, unless is collides with __GFP_ZERO
>> 
>> Signed-off-by: Jan Beulich <jbeulich@novell.com>
>
>I thought vmalloc.c was a BUG_ON(in_interrupt()) zone?
>The locking is all spin_lock stuff, not spin_lock_irq stuff.
>That's probably why your "bug" has remained "latent".

Actually, my previous reply to this was bogus, and I agree with your
statement. Hence, from a second version of the patch (depending on
your response on my question regarding the other part of your reply),
I should drop that part of the description.

Jan

