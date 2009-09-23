Return-Path: <linux-kernel-owner+w=401wt.eu-S1751744AbZIWW5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744AbZIWW5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 18:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277AbZIWW5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 18:57:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54966 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750769AbZIWW5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 18:57:43 -0400
Date: Wed, 23 Sep 2009 15:56:34 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jason Wessel <jason.wessel@windriver.com>
cc: Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [origin tree boot hang] [PATCH] Revert "early_printk:Allowmorethan
 one early console"
In-Reply-To: <4ABAA398.7080903@windriver.com>
Message-ID: <alpine.LFD.2.01.0909231553480.3303@localhost.localdomain>
References: <20090923135539.GA6542@kroah.com> <20090923173709.GA18056@elte.hu> <4ABA6182.1000106@windriver.com> <20090923190239.GC24251@elte.hu> <20090923191756.GA25163@elte.hu> <20090923210555.GA13492@elte.hu> <4ABA90C6.3000600@windriver.com>
 <20090923213929.GA20204@elte.hu> <4ABAA398.7080903@windriver.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 23 Sep 2009, Jason Wessel wrote:
> 
> Perhaps you will consider adding this patch to your tree?   It fixes the
> specific case you mentioned.  It will still allow the board to boot and
> instead of crashing, print a warning on the second instance.

Ugh. This looks totally bogus.

Why don't you just add CON_REGISTERED to the console flags, and do

	/* Already registered? */
	if (early_console->flags & CON_REGISTERED)
		return;
	early_console->flags |= CON_REGISTERED;

there instead? That whole "loop over existing consoles to check their 
names" looks silly and broken, and you're already playing with the flags 
in there (CON_BOOT).

		Linus
