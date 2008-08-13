Return-Path: <linux-kernel-owner+w=401wt.eu-S1756187AbYHMQyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187AbYHMQyX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 12:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbYHMQyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 12:54:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53560 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbYHMQyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 12:54:14 -0400
Message-ID: <48A31188.4050904@zytor.com>
Date: Wed, 13 Aug 2008 09:53:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mark Langsdorf <mark.langsdorf@amd.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: invalidate caches before going into suspend
References: <200808131141.18003.mark.langsdorf@amd.com> <20080813164728.GD5720@elte.hu>
In-Reply-To: <20080813164728.GD5720@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> also, we might be safer if the wbinvd(), the CLI and the halt was in a 
> single assembly sequence:
> 
> 	if (cpu >= i486)
> 		asm ("cli; wbinvd; cli; 1: hlt; jmp 1b")
> 	else
> 		asm ("cli; 1: hlt; jmp 1b")
> 
> to make sure the compiler doesnt ever insert something into this 
> codepath? [ And note the double cli which would be further 
> robustification - in theory we could get a spurious interrupt straight 
> after the wbinvd. ] Hm?
> 

Spurious interrupt of what kind?  The only things that could come in 
would not be non-INT type interrupts, and those aren't affected by CLI.

	-hpa
