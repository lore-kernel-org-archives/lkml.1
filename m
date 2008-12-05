Return-Path: <linux-kernel-owner+w=401wt.eu-S1756685AbYLEUWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685AbYLEUWr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 15:22:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbYLEUWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 15:22:38 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56954
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750852AbYLEUWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 15:22:37 -0500
Date: Fri, 05 Dec 2008 12:22:38 -0800 (PST)
Message-Id: <20081205.122238.12303228.davem@davemloft.net>
To: carlos@systemhalted.org
Cc: airlied@gmail.com, linux-kernel@vger.kernel.org,
       libc-alpha@sources.redhat.com
Subject: Re: IO space memcpy support for userspace.
From: David Miller <davem@davemloft.net>
In-Reply-To: <119aab440812050932h9173a4bm79273b7ea8fe9a3a@mail.gmail.com>
References: <21d7e9970812041940h29994c60w3e7bcf20b96efe04@mail.gmail.com>
	<119aab440812050932h9173a4bm79273b7ea8fe9a3a@mail.gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Carlos O'Donell" <carlos@systemhalted.org>
Date: Fri, 5 Dec 2008 12:32:04 -0500

> On Thu, Dec 4, 2008 at 10:40 PM, Dave Airlie <airlied@gmail.com> wrote:
> > I'm sure this has come up before and I'm sure I'll either wish I never
> > posted this or someone will show me the crisp corpse of the last guy
> > who suggested it.
> 
> Do you plan to prevent the compiler from issuing the same sorts of
> instructions that might appear in an optimized memcpy?
> 
> Isn't it dangerous to have memory that doesn't behave like normal
> memory, and yet try to treat it like normal memory?
> 
> This mismatch of abstractions is a warning that must not be ignored.

This is basically my opinion as well.

You'll pretty much need to surround accesses to these places with
accessor macros that do whatever is necessary on a given platform and
avoids the "dangerous" instructions in cases like IA64.

Treating them like normal memory isn't going to work on all systems.

BTW, the sunffb xorg driver has special code for "graphics copy"
which is essentially just a scanline by scanline GCOPY using the
MMX like stuff sparc64 has.  It also is mindful of avoiding access
patterns that are known to lock up that chip :)

That's just an aside, since sunffb doesn't provide any offscreen
pixmap memory and thus shouldn't be susceptible to this problem being
discussed here.

