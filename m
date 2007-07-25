Return-Path: <linux-kernel-owner+w=401wt.eu-S933593AbXGYR13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933593AbXGYR13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 13:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758644AbXGYR1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 13:27:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37789 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755001AbXGYR1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 13:27:20 -0400
Date: Wed, 25 Jul 2007 18:26:48 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, jeremy@goop.org, kaos@ocs.com.au,
       xyzzy@speakeasy.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH][RFC] getting rid of stupid loop in BUG()
Message-ID: <20070725172648.GH27237@ftp.linux.org.uk>
References: <21803.1185331847@ocs10w.ocs.com.au> <46A6DB04.3000003@zytor.com> <46A6ECB7.7090208@goop.org> <20070724.232914.56812376.davem@davemloft.net> <alpine.LFD.0.999.0707250954400.3607@woody.linux-foundation.org> <20070725171956.GF27237@ftp.linux.org.uk> <46A786C7.9020604@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A786C7.9020604@zytor.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2007 at 10:22:15AM -0700, H. Peter Anvin wrote:
> >> So we might as well keep the loop, since both are two-byte instructions 
> >> that tell gcc that it will never continue.
> > 
> > Umm...  Actually, we might be able to do something like
> > {
> > 	l: __builtin_trap();
> > 	static struct ... v __attribute__((section(...))) = { &&l, n, file };
> > }
> > 
> > except that it would need block-local labels and those are ugly (so's
> > &&<label>, while we are at it)...
> 
> I thought gcc was buggy when it came to passing &&labels to assembly.

Where do you see passing &&<label> to assembly?  More interesting question
is whether gcc believes it to be const...
