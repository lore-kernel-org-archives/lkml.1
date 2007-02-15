Return-Path: <linux-kernel-owner+w=401wt.eu-S1161212AbXBOXFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161212AbXBOXFi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 18:05:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161656AbXBOXFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 18:05:38 -0500
Received: from gw.goop.org ([64.81.55.164]:48158 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161212AbXBOXFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 18:05:38 -0500
Message-ID: <45D4E740.9020504@goop.org>
Date: Thu, 15 Feb 2007 15:05:36 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Atsushi Nemoto <anemo@mba.ocn.ne.jp>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Optimize generic get_unaligned / put_unaligned implementations.
References: <20050830104056.GA4710@linux-mips.org> <20060306.203218.69025300.nemoto@toshiba-tops.co.jp> <20060306170552.0aab29c5.akpm@osdl.org> <20070214214226.GA17899@linux-mips.org> <20070214203903.8d013170.akpm@linux-foundation.org> <20070215143441.GA18155@linux-mips.org> <20070215135358.020781dd.akpm@linux-foundation.org> <20070215221839.GA14103@linux-mips.org>
In-Reply-To: <20070215221839.GA14103@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ralf Baechle wrote:
> Gcc info page says:
>
> [...]
> `packed'
>      The `packed' attribute specifies that a variable or structure field
>      should have the smallest possible alignment--one byte for a
>      variable, and one bit for a field, unless you specify a larger
>      value with the `aligned' attribute.
> [...]
>
> Qed?

So that the compiler has to assume that if its accessing this __packed
structure, it may be embedded unaligned within something else? And
because the pointer is cast through (void *) it isn't allowed to use
alias analysis to notice that the pointer wasn't originally (apparently)
unaligned.

Seems sound to me.

    J
