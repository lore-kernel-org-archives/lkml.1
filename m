Return-Path: <linux-kernel-owner+w=401wt.eu-S1754332AbYLGL6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332AbYLGL6U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 06:58:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbYLGL6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 06:58:10 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44742 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753565AbYLGL6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 06:58:09 -0500
Date: Sun, 7 Dec 2008 11:58:20 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: Runaway loop with the current git.
Message-ID: <20081207115820.1c595877@lxorguk.ukuu.org.uk>
In-Reply-To: <20081207114519.GA23247@ioremap.net>
References: <20081205212428.GB8075@ioremap.net>
	<ac3eb2510812051810x8cf4256lf9fd31b15b9e0552@mail.gmail.com>
	<20081206160927.GA498@ioremap.net>
	<ac3eb2510812060816h4401c78bj6d656d0d5721024@mail.gmail.com>
	<20081206165634.GA2516@ioremap.net>
	<ac3eb2510812061011u7a7f0fbdtc46b95a9c642f9c7@mail.gmail.com>
	<1228591926.3808.6.camel@nga>
	<20081206202620.GA9470@ioremap.net>
	<ac3eb2510812061956g6bb422d9r7c8032fb68552b4c@mail.gmail.com>
	<20081207112335.0afd5192@lxorguk.ukuu.org.uk>
	<20081207114519.GA23247@ioremap.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > So we have a buggy modprobe... 
> 
> Which nevertheless should not break boot process...

Now you are talking complete crap. If init crashes what happens. If I
have the wrong root fs listed what happens ?

Gee it breaks. Early userspace actually does have to be correct.

> should not hung. Detect recursion, do not allow more than 1-2-3
> simultaneous modprobes, whatever, but do not say, that kernel behaves
> that bad just because userspace is allowed to do that.

Please read the code: that is what we do. That is *WHY* you got the
runaway modprobe message. It was caught but despite that the broken
initrd failed to recover. We've had that feature for years.

> And what's the argument of being close to a release? Do you propose to
> hide the head into the sand and point a finger to anyone else saying its
> not a kernel's problem? If prerelease has a bug, it should be fixed, and
> not hidden under the cover.

Its an incredibly obscure corner case. It is not appropriate to totally
trash years of kernel testing by panic re-ordering some init functions
just before a release. You will undoubtedly harm more people than you'll
please.

> What about storing a small stack of recently requested device ids, and
> if new request is about to ask one from that stack, return error? I can
> cook up the patch tomorrow.

That would be an interesting experiment for 2.6.29 however we do requests
in lots of different formats so it might be a bit more complex. You could
store the last few strings. However the existing runaway code caught it
and will have resulted in the -ENXIO path occuring anyway so I don't see
what your "change" will achieve.

Alan
