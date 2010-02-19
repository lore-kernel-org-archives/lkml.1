Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab0BSMAd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 07:00:33 -0500
Received: from zimbra.ccs.neu.edu ([129.10.116.59]:50709 "EHLO
	zimbra.ccs.neu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab0BSMAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 07:00:32 -0500
Date: Fri, 19 Feb 2010 07:00:24 -0500 (EST)
From: "Ari G. Entlich" <atrigent@ccs.neu.edu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, atrigent@ccs.neu.edu
Message-ID: <28568671.141471266580824918.JavaMail.root@zimbra>
In-Reply-To: <7662526.141431266580674036.JavaMail.root@zimbra>
Subject: Re: [PATCH] Add a new VT mode which is like VT_PROCESS but doesn't
 require a VT_RELDISP ioctl call
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [129.10.223.88]
X-Mailer: Zimbra 5.0.22_GA_3210.UBUNTU6 (ZimbraWebClient - FF3.0 (Linux)/5.0.22_GA_3210.UBUNTU6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- "Alan Cox" <alan@lxorguk.ukuu.org.uk> wrote:
> If KMS doesn't need to mode switch then does it need any of this stuff-
> can it not just switch to a console and use it ? Otherwise please use a
> different value than ACKACQ (just for clarity) and conceptually it looks
> fine to me - I just question if it's really needed as KMS based X not
> having to play with magic locking stuff would be cleaner still.

I'm not positive I understand what you're saying. Are you asking why we can't
just use VT_AUTO now? That's something I investigated, and there are a couple
reasons why it wouldn't be suitable:

1. VT_AUTO doesn't send signals to anything when a VT switch happens, precisely
   because VT_AUTO is supposed to be used in the case where there's nothing to
   send signals TO (i.e. the VT is managed by the kernel). The X server still
   needs to know about VT switches to turn input devices off and such.
2. The kernel ignores VT switches when switching away from a VT which is in
   KD_GRAPHICS + VT_AUTO mode. I'm not sure what the reason for this is, and
   I'm also not sure why it doesn't ignore switches TO these sorts of VTs, but
   that's the reality and my impression is that it's generally not a good idea
   to change these sorts of things when they've been in place for this long.

Is this what you were asking about? Also, in terms of what you said about
VT_ACKACQ, it wouldn't really make sense for there to be a new VT_ACKACQ value,
because VT_ACKACQ is something which gets passed to a VT_RELDISP, and VT_RELDISP
isn't needed at all in this new mode.

I hope that clarifies things.

Thanks!

Ari
