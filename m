Return-Path: <linux-kernel-owner+w=401wt.eu-S1751178AbXBZAYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751178AbXBZAYl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 19:24:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751168AbXBZAYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 19:24:41 -0500
Received: from smtp.osdl.org ([65.172.181.24]:55408 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178AbXBZAYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 19:24:40 -0500
Date: Sun, 25 Feb 2007 16:24:41 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Woodhouse <dwmw2@infradead.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, john stultz <johnstul@us.ibm.com>
Subject: Re: Make sure we populate the initroot filesystem late enough
In-Reply-To: <1172448057.3971.9.camel@shinybook.infradead.org>
Message-ID: <Pine.LNX.4.64.0702251614420.12485@woody.linux-foundation.org>
References: <200612112059.kBBKx1j7022473@hera.kernel.org>
 <1172448057.3971.9.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 25 Feb 2007, David Woodhouse wrote:
> 
> One side-effect of this patch is to move the call to free_initrd() much
> later in the init sequence, potentially after other memory management
> code is assuming it's already been freed.

Hmm. No, I don't think that should be a problem. free_initmem() only 
happens at the very, after do_basic_setup() has been run, which includes 
all the initcall stuff.

However, it's an interesting observation. How sure are you that it's this 
commit that triggers it. You say "This seems to be what's triggering ..", 
I'm wondering how firm that is..

		Linus
