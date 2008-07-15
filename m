Return-Path: <linux-kernel-owner+w=401wt.eu-S1762387AbYGOCxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762387AbYGOCxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757316AbYGOCw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:52:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54135 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757526AbYGOCw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:52:58 -0400
Date: Mon, 14 Jul 2008 19:51:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
cc: jeff@garzik.org, arjan@infradead.org, akpm@linux-foundation.org,
       dwmw2@infradead.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
In-Reply-To: <20080714.194032.117461306.davem@davemloft.net>
Message-ID: <alpine.LFD.1.10.0807141947540.3017@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org> <487C09EB.1050903@garzik.org> <alpine.LFD.1.10.0807141928540.3017@woody.linux-foundation.org> <20080714.194032.117461306.davem@davemloft.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Jul 2008, David Miller wrote:
> 
> Jeff's not against request_firmware() in an of itself.
> 
> He's against the fact that it's not possible to build a
> self-contained foo.ko module file any longer, and that
> would definitely be possible with using request_firmware().

.. but is it really that big of a deal?

If it were about not being able to build a self-contained non-modular 
"vmlinux", I'd be upset too.

But once you can load a module, you can load the firmware. You just have 
to _remember_ to move it along with the module.

I mean really, you're the one who was complaining that there was no 
technical reason, but now you're apparently using the "alzheimer's 
defense". 

Besides, it's not even true that foo.ko modules are self-contained. We've 
for years and years (pretty much since day one) had nesting module models, 
where in order to load foo.ko you need to load baz.ko first. Yes, the 
firmware file is named differently, but it _is_ different.

			Linus
