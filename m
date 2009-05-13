Return-Path: <linux-kernel-owner+w=401wt.eu-S1760696AbZEMPB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760696AbZEMPB0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 11:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756572AbZEMPBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 11:01:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754942AbZEMPBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 11:01:14 -0400
Date: Wed, 13 May 2009 07:58:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: dsaxena@plexity.net, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 8250: Don't restore NS16550 mode when console suspend
 is disabled
In-Reply-To: <20090513094409.50c2409f@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.01.0905130755090.3343@localhost.localdomain>
References: <20090512210015.GA25540@plexity.net> <alpine.LFD.2.01.0905121452190.3343@localhost.localdomain> <20090513011842.22d9cd6c@lxorguk.ukuu.org.uk> <20090513002850.GA28422@plexity.net> <20090513094409.50c2409f@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 13 May 2009, Alan Cox wrote:
> 
> Then hard coding is no improvement either. It needs to restore the mode
> that was present at suspend.

Alan, you're missing the fact that this is a special-case for "this is the 
console, and we're not suspending consoles AT ALL".

IOW, it was never suspended either, and it's a case that is known to be 
fundamentally buggy (we're suspending all the PCI bridges, but not a 
serial device that may be behind them!), but often work in _practice_ 
(because people don't use this thing for random serial devices, but for 
things like integrated serial lines that don't lose power).

So we _could_ just save the mode, but that isn't really what this patch is 
all about. The patch in question is about a total hack to avoid touching a 
piece of hardware that we simply don't consider normal.

			Linus
