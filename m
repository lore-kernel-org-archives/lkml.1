Return-Path: <linux-kernel-owner+w=401wt.eu-S932750AbXGYRiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932750AbXGYRiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 13:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761456AbXGYRh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 13:37:56 -0400
Received: from gw.goop.org ([64.81.55.164]:56841 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759673AbXGYRhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 13:37:55 -0400
Message-ID: <46A78A31.10506@goop.org>
Date: Wed, 25 Jul 2007 10:36:49 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, hpa@zytor.com, kaos@ocs.com.au,
       xyzzy@speakeasy.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH][RFC] getting rid of stupid loop in BUG()
References: <21803.1185331847@ocs10w.ocs.com.au> <46A6DB04.3000003@zytor.com> <46A6ECB7.7090208@goop.org> <20070724.232914.56812376.davem@davemloft.net> <alpine.LFD.0.999.0707250954400.3607@woody.linux-foundation.org> <46A781A4.40103@goop.org> <alpine.LFD.0.999.0707251018280.3607@woody.linux-foundation.org> <20070725172542.GG27237@ftp.linux.org.uk>
In-Reply-To: <20070725172542.GG27237@ftp.linux.org.uk>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> Who said that we need to populate that section from asm?  Define
> a static variable in that section inside a block; identifier is
> not a problem, obviously.
>
> I'm not saying that it's not revolting, but it's not impossible.
>   

I tried that, but there's still no way of getting a pointer to the ud2a
instruction in there.  gcc just generates garbage if you try to use use
the &&label syntax on a label which isn't (potentially) the target of a
goto (it just gets placed somewhere random).

But there's a bigger problem than that.  If the BUG is in code which can
be replicated (ie inlined or unrolled), then it would also require
replicating the static variable...

    J
