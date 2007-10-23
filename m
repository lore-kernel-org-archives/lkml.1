Return-Path: <linux-kernel-owner+w=401wt.eu-S1754983AbXJWS0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983AbXJWS0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 14:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbXJWS0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 14:26:01 -0400
Received: from 207.47.60.147.static.nextweb.net ([207.47.60.147]:39693 "EHLO
	rpc.xensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501AbXJWS0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 14:26:00 -0400
X-Greylist: delayed 979 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Oct 2007 14:26:00 EDT
Message-ID: <471E38D6.5050202@xensource.com>
Date: Tue, 23 Oct 2007 11:09:26 -0700
From: Jeremy Fitzhardinge <jeremy@xensource.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: CONFIG_XEN dependencies
References: <471DE2F8.76E4.0078.0@novell.com>
In-Reply-To: <471DE2F8.76E4.0078.0@novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Oct 2007 18:09:39.0812 (UTC) FILETIME=[E0F3DA40:01C8159F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> Jeremy,
>
> CONFIG_XEN (in 2.6.23) depends on X86_CMPXCHG and X86_TSC. This
> precludes enabling the option in kernels using M386, M486, or M586, despite
> the fact that the detection code doesn't need these features and if Xen is
> present the features are implicitly there. At least the X86_TSC dependency
> can thus be dropped in my opinion, which would then only exclude M386
> kernels. (Dropping X86_CMPXCHG may yield build problems, but could
> perhaps also be eliminated by forcibly #define-ing it in the relevant source
> files.)

Yeah, that's a bit tacky though.  We added it because reviewers
(probably Adrian Bunk, or maybe akpm) noticed the Xen code
unconditionally using cmpxchg, and I added tsc because, well, we use it.

But you're right; we can't get to any of the Xen code without booting
under Xen, which necessarily means all those features are available,
regardless of how the kernel is configured.

What config combinations do you want to support?

    J
