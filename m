Return-Path: <linux-kernel-owner+w=401wt.eu-S1754067AbYLBDnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbYLBDnW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 22:43:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbYLBDnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 22:43:14 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58258 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751388AbYLBDnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 22:43:13 -0500
Date: Mon, 1 Dec 2008 19:42:48 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken
 on Toshiba R500 (bisected)
In-Reply-To: <alpine.LFD.2.00.0812011921520.3256@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0812011933050.3256@nehalem.linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <alpine.LFD.2.00.0812011921520.3256@nehalem.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 1 Dec 2008, Linus Torvalds wrote:
> 
> or something like that. And then we just need to figure out which setup 
> routine sets the wrong alignment flag,.

Oh, btw, one more thing: since it apparently sometimes _does_ resume 
from hibernation without all this, I'd also like to see the actual 
differences in /proc/ioports and /proc/iomem that happen as a result of 
the different alignment. 

I also really suspect we should add a whole "alignment" field to "struct 
resource", instead of the size-vs-start flags. The fact is, some PCI 
devices have alignment that is neither tied to size or anything else: I 
think some PCI bus resources are really always 4kB-aligned, for example 
(and aligning them by size will give a bigger alignment than actually 
required).

			Linus
