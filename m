Return-Path: <linux-kernel-owner+w=401wt.eu-S1760325AbYBBLty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760325AbYBBLty (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 06:49:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756761AbYBBLtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 06:49:47 -0500
Received: from gw.goop.org ([64.81.55.164]:49984 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756708AbYBBLtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 06:49:46 -0500
Message-ID: <47A458AD.6050409@goop.org>
Date: Sat, 02 Feb 2008 03:49:01 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 6 of 7] x86: move pud/pgd functions into common	asm/pgalloc.h
References: <patchbomb.1201943112@localhost> <fe3ff49757e16a5b9290.1201943118@localhost> <20080202101356.GA19782@elte.hu> <47A443FE.6040900@goop.org> <20080202104048.GA24605@elte.hu>
In-Reply-To: <20080202104048.GA24605@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> yes but the early hang is very real so either my hardware is stubbornly 
> ignoring that your patch is pure code movement (in which case i'll have 
> to have a word or two with my hardware), or your patch is perhaps wrong 
> somewhere ;-)
>   

I see what it is.  set_pud on 32-bit needs only _PAGE_PRESENT, but for 
64-bit it needs _PAGE_TABLE.

> generally you can protect yourself against full reverts by separating 
> the NOP changes from the non-NOP changes. If a change is small enough i 
> might spot the bug immediately and fix it - otherwise i have to undo 
> your whole series to keep the x86.git ball rolling. I thought we went 
> through this excercise a few times already :-/ ...
>   

This one was supposed to be pure motion, but my eyeball diff failed me.

    J
