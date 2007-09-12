Return-Path: <linux-kernel-owner+w=401wt.eu-S933495AbXILCSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933495AbXILCSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 22:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754169AbXILCSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 22:18:06 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37483 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753341AbXILCSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 22:18:05 -0400
Date: Tue, 11 Sep 2007 19:17:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michael Neuling <mikey@neuling.org>
cc: akpm@linux-foundation.org, paulus@samba.org, Alan Cox <alan@redhat.com>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] powerpc: add new required termio functions
In-Reply-To: <8018.1189562679@neuling.org>
Message-ID: <alpine.LFD.0.999.0709111915350.16478@woody.linux-foundation.org>
References: <8018.1189562679@neuling.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 12 Sep 2007, Michael Neuling wrote:
>
> The "tty: termios locking functions break with new termios type" patch
> (f629307c857c030d5a3dd777fee37c8bb395e171) breaks the powerpc compile.

Really?

It shouldn't. The use of kernel_termios_to_user_termios_1() is conditional 
on the architecture having a define for TCGETS2, and I think they match 
up. I see:

	[torvalds@woody linux]$ git grep -l kernel_termios_to_user_termios_1 include | wc -l
	10
	[torvalds@woody linux]$ git grep -l TCGETS2 include | wc -l
	10

and in neither case is ppc in that list of architecures.

So maybe you just read the patch without actually testing whether it 
actually broke powerpc?

Or is something subtler going on?

			Linus
