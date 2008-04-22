Return-Path: <linux-kernel-owner+w=401wt.eu-S932918AbYDVWOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932918AbYDVWOI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 18:14:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757968AbYDVWNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 18:13:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43687 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756955AbYDVWNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 18:13:55 -0400
Date: Tue, 22 Apr 2008 15:13:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
cc: Jeff Chua <jeff.chua.linux@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Broken] PCI: clean up resource alignment management
In-Reply-To: <alpine.LFD.1.10.0804221451270.2779@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0804221510420.2779@woody.linux-foundation.org>
References: <b6a2187b0804220943l26f7b441sb5a7309dff0e84dc@mail.gmail.com> <alpine.LFD.1.10.0804221020470.2779@woody.linux-foundation.org> <20080422214050.GA1166@jurassic.park.msu.ru> <alpine.LFD.1.10.0804221451270.2779@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 22 Apr 2008, Linus Torvalds wrote:
> 
> (In fact, I think cardbus bridges have a much more flexible alignment than 
> that size thing, and can be aligned at finer granularity, but I forget the 
> exact details, and since we didn't add a special "alignment" field, we 
> can't take advantage of it anyway).

Yeah, I double-checked: the IO alignment is 4 bytes, the MEM alignment is 
4k.

So if we had a separate alignment word we could use that, but in the 
meantime I think IORESOURCE_SIZEALIGN is good enough, and a bit more 
readable than the STARTALIGN thing.

Now we just need to have somebody test it. It turns out that I no longer 
have any Cardbus cards, since my laptops now all have built-in wireless. 
Boo hiss for me.

			Linus
