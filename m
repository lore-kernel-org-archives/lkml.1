Return-Path: <linux-kernel-owner+w=401wt.eu-S965970AbXCFROG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965970AbXCFROG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 12:14:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965953AbXCFROF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 12:14:05 -0500
Received: from smtp.osdl.org ([65.172.181.24]:47998 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965971AbXCFROE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 12:14:04 -0500
Date: Tue, 6 Mar 2007 09:13:48 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Howells <dhowells@redhat.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: get_order() broken !
In-Reply-To: <1173200555.9349.2.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0703060910340.5963@woody.linux-foundation.org>
References: <1173200555.9349.2.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Mar 2007, Benjamin Herrenschmidt wrote:
>
> Ok, maybe I have lots of shit in my eyes.... but it looks like get_order
> in asm-generic/page.h is broken.
> 
> AFAIK, get_order() should round up (and we have code here or there
> assuming such).
> 
> However, it seems to assume that ilog2 rounds up, which it doesn't. It
> rounds down. At least the generic implementation seems to do so and the
> powerpc optimized one too.

Yeah, I think the recent get_order() changes to change it to use ilog2() 
are just crap. I actually looked at it when it went in, but I assumed that 
it had been tested. I don't think it has.

Let's just revert that entirely.

David, quick comments before I undo commit 39d61db0?

		Linus
