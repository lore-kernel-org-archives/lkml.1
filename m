Return-Path: <linux-kernel-owner+w=401wt.eu-S934149AbXGYR0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934149AbXGYR0Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 13:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761826AbXGYR0C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 13:26:02 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37440 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760412AbXGYR0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 13:26:00 -0400
Date: Wed, 25 Jul 2007 18:25:42 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, David Miller <davem@davemloft.net>,
       hpa@zytor.com, kaos@ocs.com.au, xyzzy@speakeasy.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH][RFC] getting rid of stupid loop in BUG()
Message-ID: <20070725172542.GG27237@ftp.linux.org.uk>
References: <21803.1185331847@ocs10w.ocs.com.au> <46A6DB04.3000003@zytor.com> <46A6ECB7.7090208@goop.org> <20070724.232914.56812376.davem@davemloft.net> <alpine.LFD.0.999.0707250954400.3607@woody.linux-foundation.org> <46A781A4.40103@goop.org> <alpine.LFD.0.999.0707251018280.3607@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707251018280.3607@woody.linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2007 at 10:19:55AM -0700, Linus Torvalds wrote:
> 
> 
> On Wed, 25 Jul 2007, Jeremy Fitzhardinge wrote:
> > 
> > No, not any more.  The file and line info is out of line, in a separate
> > section, indexed by the ud2a's eip.
> 
> That's irrelevant - the point is, we need to do the ud2 by hand, since we 
> need to control the code generation in order to associate the ud2 with the 
> proper file/linenr.
> 
> > The main problem with __builtin_trap is that there's no certain way to 
> > get the actual ud2a eip (ie, paste an asm label onto it).
> 
> Right. Which is why we need to do it as an inline asm.

Who said that we need to populate that section from asm?  Define
a static variable in that section inside a block; identifier is
not a problem, obviously.

I'm not saying that it's not revolting, but it's not impossible.
