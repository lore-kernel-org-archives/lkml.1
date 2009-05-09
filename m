Return-Path: <linux-kernel-owner+w=401wt.eu-S1753218AbZEIIoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbZEIIoT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 04:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751440AbZEIIoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 04:44:10 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:38827 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbZEIIoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 04:44:09 -0400
Message-ID: <4A054156.60501@cs.helsinki.fi>
Date: Sat, 09 May 2009 11:39:50 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: gorcunov@openvz.org, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie,
       cl@linux-foundation.org, riel@redhat.com, linux-kernel@vger.kernel.org,
       mingo@elte.hu, rientjes@google.com
Subject: Re: [PATCH 1/2] mm: Introduce GFP_PANIC for early-boot allocations
References: <1241795428.28600.60.camel@penberg-laptop> <20090508135632.9c041339.akpm@linux-foundation.org>
In-Reply-To: <20090508135632.9c041339.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Andrew Morton wrote:
> On Fri, 08 May 2009 18:10:28 +0300
> Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> 
>> +#define GFP_PANIC	(__GFP_NOFAIL | __GFP_NORETRY)
> 
> urgh, you have to be kidding me.  This significantly worsens complexity
> and risk in core MM and it's just yuk.
> 
> I think we can justify pulling such dopey party tricks to save
> pageframe space, or bits in page.flags and such.  But just to save a
> scrap of memory which would have been released during boot anwyay? 
> Don't think so.

No, I wasn't kidding and I don't agree that it "significantly worsens 
complexity". The point is not to save memory but to clearly annotate 
those special call-sites that really don't need to check for out-of-memory.

But anyway, if you don't want it, then I guess it stays out of the kernel.

Andrew Morton wrote:
> I'd suggest panic_if_null().  Or just leave everything alone - it's
> hardly a pressing problem.

It has no advantage over the current BUG_ON() pattern.

			Pekka
