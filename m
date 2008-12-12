Return-Path: <linux-kernel-owner+w=401wt.eu-S1758802AbYLLQMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758802AbYLLQMe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 11:12:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757520AbYLLQMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 11:12:25 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40052 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757133AbYLLQMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 11:12:25 -0500
Date: Fri, 12 Dec 2008 08:11:35 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Arjan van de Ven <arjan@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Frans Pop <elendil@planet.nl>, Eric Anholt <eric@anholt.net>,
       nix.or.die@googlemail.com, linux-kernel@vger.kernel.org, rjw@sisk.pl,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: Linux 2.6.28-rc8
In-Reply-To: <20081212075746.4ddc9349@infradead.org>
Message-ID: <alpine.LFD.2.00.0812120808200.3340@localhost.localdomain>
References: <alpine.LFD.2.00.0812101651130.3340@localhost.localdomain> <49407CE1.9090600@googlemail.com> <1228979963.3254.8.camel@gaiman.anholt.net> <200812111707.20857.elendil@planet.nl> <alpine.LFD.2.00.0812110814360.3340@localhost.localdomain>
 <20081211163548.GA11859@elte.hu> <alpine.LFD.2.00.0812110902450.3340@localhost.localdomain> <20081211203604.GA14817@elte.hu> <84144f020812111246m7f6470f2n8b09283f54ead81@mail.gmail.com> <20081212082456.GA25106@elte.hu>
 <20081212075746.4ddc9349@infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 12 Dec 2008, Arjan van de Ven wrote:
> 
> another thing we could do is try to only warn if you cross bar
> boundaries but not if you cross other user-of-the-resource boundaries.

Hmm. We could use the res->flags for this. But I'm not sure non-PCI 
resources fill those in correctly.

A pure "busy" allocation (ie a driver marker) would generally have just 
the IORESOURCE_BUSY bit set, while a real PCI hardware resource will have 
other bits set (ie the IORESOURCE_IO/MEM bits) and not be marked BUSY.

Maybe just ignoring resources with BUSY set, as they are driver markers 
rather than actual HW resources.

			Linus
