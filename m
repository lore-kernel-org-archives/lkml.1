Return-Path: <linux-kernel-owner+w=401wt.eu-S932608AbXAZKoF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608AbXAZKoF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 05:44:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022AbXAZKoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 05:44:05 -0500
Received: from [217.111.56.2] ([217.111.56.2]:58813 "EHLO semtex.sncag.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752016AbXAZKoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 05:44:03 -0500
To: Greg KH <greg@kroah.com>
Cc: Rainer Weikusat <rweikusat@sncag.com>, torvalds@linux-foundation.org,
       bunk@stusta.de, linux-kernel@vger.kernel.org
Subject: Re: unfixed regression in 2.6.20-rc6 (since 2.6.19)
In-Reply-To: <20070125185101.GA26279@kroah.com> (Greg KH's message of "Thu, 25 Jan 2007 10:51:01 -0800")
References: <877ivb2kvc.fsf@semtex.sncag.com>
	<20070125185101.GA26279@kroah.com>
From: Rainer Weikusat <rainer.weikusat@sncag.com>
Date: Fri, 26 Jan 2007 11:43:22 +0100
Message-ID: <87y7nq131x.fsf@semtex.sncag.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> writes:
> On Thu, Jan 25, 2007 at 04:20:55PM +0100, Rainer Weikusat wrote:
>> 2.6.19 introduced changes to the UHCI handling of interrupt URBs that
>> caused at least some keyspan USB-to-serial converters to fail,

[...]

> I copied you when this patch was added to my tree,

The only thing I received was a 'this patch has been dropped from
the MM-tree because something happened' message.

> as I had reworked it to be a bit more acceptable (no pointer
> arithmatic, proper coding style, use the newer macros for endpoint
> detection, etc.),

You have basically done a couple of (functionally) totally pointless
changes, like

	- not using iterator-style array traversals, but indexed ones
          instead

	- doing the calculation to determine the endpoint type in
          three different places instead of in one place, because the
          somewhat silly endpoint classification interfaces enforces
          this

	- not using a single switch-statement but an if-else-cascade,
          again due to limitations of that interface

	- replacing the while-loop with an identical for-loop

The net effect of these changes is that an optimizing compiler will
have to work somewhat more to remove all the redundant stuff that
was added. As for 'proper coding style', the code conforms to what is
documented as 'proper kernel coding style'. If this assumption of mine
is incorrect, I'd be happy to hear about reasons why this would be so,
to take them into account for eventual future patches.

> I this patch does not work, please let me know, and I will be glad
> to work to fix it.

I think I'll just resend the working one in this case. But the logic
appears to be identical, so I do not so a reason why it shouldn't.
