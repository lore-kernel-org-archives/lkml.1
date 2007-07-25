Return-Path: <linux-kernel-owner+w=401wt.eu-S934600AbXGYRho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934600AbXGYRho (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 13:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759673AbXGYRhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 13:37:35 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40285 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758353AbXGYRhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 13:37:34 -0400
Date: Wed, 25 Jul 2007 18:36:46 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, jeremy@goop.org, hpa@zytor.com,
       kaos@ocs.com.au, xyzzy@speakeasy.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH][RFC] getting rid of stupid loop in BUG()
Message-ID: <20070725173646.GI27237@ftp.linux.org.uk>
References: <21803.1185331847@ocs10w.ocs.com.au> <46A6DB04.3000003@zytor.com> <46A6ECB7.7090208@goop.org> <20070724.232914.56812376.davem@davemloft.net> <alpine.LFD.0.999.0707250954400.3607@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707250954400.3607@woody.linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2007 at 09:56:12AM -0700, Linus Torvalds wrote:
> We don't just do the "ud2" instruction - we also do the file and line 
> number information after it. Which means that __builtin_trap() is useless.
> 
> So we might as well keep the loop, since both are two-byte instructions 
> that tell gcc that it will never continue.

Actually, the worse problem is that gcc will happily merge these guys.
And that's a killer.
