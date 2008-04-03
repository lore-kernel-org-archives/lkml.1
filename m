Return-Path: <linux-kernel-owner+w=401wt.eu-S1760952AbYDCCz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760952AbYDCCz5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 22:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758230AbYDCCzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 22:55:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43138 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758218AbYDCCzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 22:55:49 -0400
Date: Thu, 3 Apr 2008 03:55:46 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, josh@freedesktop.org
Subject: Re: [PATCH 7/7] asm-generic: suppress sparse warning in ioctl.h
Message-ID: <20080403025546.GB9785@ZenIV.linux.org.uk>
References: <1207182818.5740.26.camel@brick> <alpine.LFD.1.00.0804021752040.14670@woody.linux-foundation.org> <20080403013420.GV9785@ZenIV.linux.org.uk> <alpine.LFD.1.00.0804021848140.14670@woody.linux-foundation.org> <20080403015946.GX9785@ZenIV.linux.org.uk> <alpine.LFD.1.00.0804021950260.14670@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0804021950260.14670@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 07:51:08PM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 3 Apr 2008, Al Viro wrote:
> > 
> > Um...  But that's _not_ a link-time constant - simply an int variable not
> > defined in any object file...
> 
> Ahh, you're right, my bad. We could change it to take the address of it, 
> though. I assume gcc is happy with that too?

gcc might be, but what are you going to do with it?  Expression is an
integer one, after all - in cases that had triggered that thread it
was used (after & 0xff) as array index.

Besides, logically it's _not_ a constant at all - not even a base + constant,
after using it in such expression...
