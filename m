Return-Path: <linux-kernel-owner+w=401wt.eu-S1752909AbYJ1PzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909AbYJ1PzN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 11:55:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbYJ1Py7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 11:54:59 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:60413 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbYJ1Py7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 11:54:59 -0400
Date: Tue, 28 Oct 2008 09:54:58 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: torvalds@osdl.org, akpm@osdl.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: On spreading atomic_t initialization
Message-ID: <20081028155457.GC12792@parisc-linux.org>
References: <20081028152943.GA20989@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081028152943.GA20989@x200.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2008 at 06:29:43PM +0300, Alexey Dobriyan wrote:
> I wrote stupid runtime checker to look for atomic_t uninitialized usage
> and the amount of screaming in logs is surprisingly very big.
> 
> So the question: is there really really an arch for which setting atomic_t
> by hand (kzalloc) is not equivalent to atomic_set()?

No.  atomic_t is 32-bit, and requires all 32 bits to be usable by the
callers.  It's kind of like NULL might not theoretically be represented
by a bit-pattern of all zeroes.  In practise, it always is.  I don't
see the value in your checker, sorry.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
