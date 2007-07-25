Return-Path: <linux-kernel-owner+w=401wt.eu-S933939AbXGYQ5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933939AbXGYQ5L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 12:57:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762675AbXGYQ45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 12:56:57 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53658 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758028AbXGYQ44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 12:56:56 -0400
Date: Wed, 25 Jul 2007 09:56:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
cc: jeremy@goop.org, hpa@zytor.com, kaos@ocs.com.au, xyzzy@speakeasy.org,
       viro@ftp.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH][RFC] getting rid of stupid loop in BUG()
In-Reply-To: <20070724.232914.56812376.davem@davemloft.net>
Message-ID: <alpine.LFD.0.999.0707250954400.3607@woody.linux-foundation.org>
References: <21803.1185331847@ocs10w.ocs.com.au> <46A6DB04.3000003@zytor.com>
 <46A6ECB7.7090208@goop.org> <20070724.232914.56812376.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 24 Jul 2007, David Miller wrote:
>
> From: Jeremy Fitzhardinge <jeremy@goop.org>
> Date: Tue, 24 Jul 2007 23:24:55 -0700
> 
> > H. Peter Anvin wrote:
> > > How far back was __builtin_trap() supported?
> > 
> > I think its relatively recent, but it might be within our supported
> > compiler window.
> 
> I'm pretty sure it is.

.. and I'm pretty sure it's immaterial.

We don't just do the "ud2" instruction - we also do the file and line 
number information after it. Which means that __builtin_trap() is useless.

So we might as well keep the loop, since both are two-byte instructions 
that tell gcc that it will never continue.

		Linus
