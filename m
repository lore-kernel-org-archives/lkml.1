Return-Path: <linux-kernel-owner+w=401wt.eu-S1030699AbXAZBt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030699AbXAZBt4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 20:49:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030701AbXAZBt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 20:49:56 -0500
Received: from smtp.osdl.org ([65.172.181.24]:40842 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030699AbXAZBtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 20:49:55 -0500
Date: Thu, 25 Jan 2007 17:49:44 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] x86_64: fix put_user for 64-bit constant
In-Reply-To: <20070126011951.ECFD5180051@magilla.sf.frob.com>
Message-ID: <Pine.LNX.4.64.0701251747530.25027@woody.linux-foundation.org>
References: <20070126011951.ECFD5180051@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 25 Jan 2007, Roland McGrath wrote:
>
> On x86-64, a put_user call using a 64-bit pointer and a constant value that
> is > 0xffffffff will produce code that doesn't assemble.  This patch fixes
> the asm construct to use the Z constraint for 32-bit constants.

Ahh. Will apply.

Just out of interest: did we have such code and it just happened to use a 
register, or was this found because you wrote some new code that triggered 
something that had just never been triggered before? Or is there a newer 
gcc that is better at optimizations and finds a constant propagation where 
it used to not find it?

Inquiring minds..

		Linus
