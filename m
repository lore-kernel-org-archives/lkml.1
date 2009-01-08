Return-Path: <linux-kernel-owner+w=401wt.eu-S1757614AbZAHASQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614AbZAHASQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 19:18:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbZAHASA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 19:18:00 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45107 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752239AbZAHASA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 19:18:00 -0500
Date: Wed, 7 Jan 2009 16:17:24 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Arjan van de Ven <arjan@infradead.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/7] V3 of the async function call patches
In-Reply-To: <20090107151151.458333c1@infradead.org>
Message-ID: <alpine.LFD.2.00.0901071611490.3283@localhost.localdomain>
References: <20090107151151.458333c1@infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Jan 2009, Arjan van de Ven wrote:
>
> version 3 of the async function call patches
> 
> * Dropped the ACPI part; it broke i surprising ways; needs a rethink
>   (working with Len and co on that)
> * Included asynchronous delete()

Ok, I pulled this, because I really do want the boot speedups and the 
previous version missed the last merge window, but after booting it, I 
started to worry:

My dmesg shows:

 [    2.264955] sd 5:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 [    2.264958]  sdb:<6>Freeing unused kernel memory: 408k freed

Ouch. How come that "Freeing unused kernel memory" got done in the middle 
of the sdb partition thing?

There's a async_synchronize_full() there before the free_initmem(), but 
I'm worrying that it just isn't working. Hmm? What am I missing?

		Linus
