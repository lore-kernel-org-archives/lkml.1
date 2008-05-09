Return-Path: <linux-kernel-owner+w=401wt.eu-S935107AbYEIBso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935107AbYEIBso (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 21:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbYEIBsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 21:48:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56745 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751880AbYEIBse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 21:48:34 -0400
Date: Thu, 8 May 2008 18:46:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: Dave Airlie <airlied@gmail.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Gary Hade <garyhade@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: regression fixed by using pci=rom
In-Reply-To: <200805081717.54102.jbarnes@virtuousgeek.org>
Message-ID: <alpine.LFD.1.10.0805081842030.2940@woody.linux-foundation.org>
References: <21d7e9970805081654h6de38d58q5ad3b6d3520b45f1@mail.gmail.com> <200805081717.54102.jbarnes@virtuousgeek.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 May 2008, Jesse Barnes wrote:
> 
> Hm, yeah in many cases we definitely *do* want to try to get the expansion ROM 
> space allocated.  But maybe it should be a lower priority than other BARs...  
> Gary?

The thing is, a lot of these things have been done this way because not 
doing them that way breaks.

We want to allocate expansion ROM space - even if we don't enable it - 
because not doing so will screw up bus sizing etc, and can make it 
impossible to allocate later.

In general, changing PCI allocation strategy is really _really_ dangerous, 
even when it is "right", because it tends to expose a lot of issues where 
something worked just because it was perhaps indirectly causing a layout 
that worked.

So the reason I immediately reverted this is that it was simply totally 
wrong. If somebody cares about multi-node systems, the onus of making 
those work should be on *that*, not on old systems that already work.

Ingo, Thomas: I would _seriously_ suggest that you don't consider the x86 
PCI setup code to be "x86" code. Because it isn't. Not in that sense. Just 
don't take patches to it.

		Linus
