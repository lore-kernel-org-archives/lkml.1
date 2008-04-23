Return-Path: <linux-kernel-owner+w=401wt.eu-S933857AbYDWB1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933857AbYDWB1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 21:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755611AbYDWB1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 21:27:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39347 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752315AbYDWB1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 21:27:05 -0400
Date: Tue, 22 Apr 2008 18:26:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Chua <jeff.chua.linux@gmail.com>
cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Broken] PCI: clean up resource alignment management
In-Reply-To: <b6a2187b0804221805j38905128h74b6db258301f10f@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0804221822340.2779@woody.linux-foundation.org>
References: <b6a2187b0804220943l26f7b441sb5a7309dff0e84dc@mail.gmail.com>  <alpine.LFD.1.10.0804221020470.2779@woody.linux-foundation.org>  <20080422214050.GA1166@jurassic.park.msu.ru>  <alpine.LFD.1.10.0804221451270.2779@woody.linux-foundation.org>
 <b6a2187b0804221805j38905128h74b6db258301f10f@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 23 Apr 2008, Jeff Chua wrote:

> On Wed, Apr 23, 2008 at 5:59 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >  On Wed, 23 Apr 2008, Ivan Kokshaysky wrote:
> >  > Yes, exactly. My fault - I somehow missed the cardbus stuff...
> >  Ok, this patch looks sane, but ..
> >  Patch entirely UNTESTED!
> 
> I just tested Linus's patch and it works.

Thanks, and I could test it myself (without any actual card, but at least 
I could see the failure to even set up the bridge, and the fix). 

So I committed it.

When we did the original commit that caused this, we had considered having 
a separate "alignment" value, but I had discarded it because I didn't 
think there was any actual hardware that could even use it. But this 
cardbus thing shows that I was wrong - the two bits may have been clever, 
and it works no worse than the old setup (and slightly better), but I 
think the separate alignment field would probably have been better.

Anyway, it's probably not worth worrying about now. It's not like we've 
ever _needed_ the finer-granularity alignment, so I think we're ok with 
the current setup, but if we ever decide to add the alignment field after 
all, somebody should remind me/Ink about the cardbus thing.

			Linus
