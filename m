Return-Path: <linux-kernel-owner+w=401wt.eu-S1756017AbYB0Ogr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017AbYB0Ogr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 09:36:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754655AbYB0Ogh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 09:36:37 -0500
Received: from ns2.suse.de ([195.135.220.15]:51621 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754647AbYB0Ogh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 09:36:37 -0500
Message-ID: <47C575E4.7050206@suse.de>
Date: Wed, 27 Feb 2008 15:38:28 +0100
From: Andi Kleen <ak@suse.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander van Heukelum <heukelum@mailshack.com>
Subject: Re: [PATCH] reserve_early end-of-conventional-memory to 1MB II -
 some numbers to put it into perspective
References: <20080224174605.GA21661@mailshack.com> <47C22568.1010405@zytor.com> <1203958478.20033.1239002461@webmail.messagingengine.com> <20080225170134.GA15839@elte.hu> <20080225180750.GA31054@mailshack.com> <47C3053D.5060504@zytor.com> <1203968796.24935.1239027765@webmail.messagingengine.com> <20080226093046.GK9857@elte.hu>
In-Reply-To: <20080226093046.GK9857@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Alexander van Heukelum <heukelum@fastmail.fm> wrote:
> 
>>> Either way, the code should be shared between 32 and 64 bits. There 
>>> is nothing bitsize-specific about it!
>> Of course. That's also why I already added the old-Dell case ;). But 
>> one problem at a time, please!
> 
> i've applied your patch to x86.git#testing. Feel free to send a 
> code-unification patch too :-)

Just to give some perspective of this:

On my laptop here

 BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d2000 - 0000000000100000 (reserved)

This means it reserves only ~193KB in the 640k-1MB area

With this patch it will reserve 384KB instead. This means 191KB
are lost. While that doesn't sound too much it worth as much as
382 patches that reduce kernel code size by 512bytes or
worth 3820 patches that reduce kernel code by 100 bytes in terms
of memory consumption.

Now such kernel code size patches are always popular, but why undo that
work by throwing away perfectly good memory elsewhere?

Or also the laptop kernel does

Freeing unused kernel memory: 340k freed

This means the 193KB now lost are worth 56% of the complete
memory that is freed by __initdata/__init. Just maintaining
these annotations is a lot of work, but why do all that if we
then throw away than half as much memory as they save so easily?

-Andi
