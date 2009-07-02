Return-Path: <linux-kernel-owner+w=401wt.eu-S1753262AbZGBEZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262AbZGBEZq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 00:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750850AbZGBEZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 00:25:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43375 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750822AbZGBEZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 00:25:38 -0400
Date: Wed, 1 Jul 2009 21:23:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: printk regression?
In-Reply-To: <4A4C3410.8080704@kernel.org>
Message-ID: <alpine.LFD.2.01.0907012119370.3380@localhost.localdomain>
References: <4A4C3410.8080704@kernel.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 1 Jul 2009, Yinghai Lu wrote:
>
> [   75.690022] <7>printing local APIC contents on CPU#0/0:

Yes. This is because the io_apic code should be fixed.

It does:

	printk("\n" KERN_DEBUG "printing local APIC

and that "\n" at the beginning should just be deleted. The log-level 
should be at the beginning of the printk, not in the middle.

Same goes for the insane binary printing crap. How about just making it 
sane?

		Linus
