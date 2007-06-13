Return-Path: <linux-kernel-owner+w=401wt.eu-S1755226AbXFMEec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbXFMEec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 00:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751079AbXFMEeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 00:34:24 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:39049 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754AbXFMEeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 00:34:24 -0400
Date: Wed, 13 Jun 2007 06:35:26 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Jan Beulich <jbeulich@novell.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
Subject: Re: [PATCH] x86: fix improper .init-type section references
Message-ID: <20070613043526.GA20088@uranus.ravnborg.org>
References: <466E6BDF.76E4.0078.0@novell.com> <a781481a0706120414g385ccfe8j82b5b18d96d064f2@mail.gmail.com> <a781481a0706120509k89c331ela81f57ad0f0e29eb@mail.gmail.com> <466EB12B.76E4.0078.0@novell.com> <a781481a0706120632p54ad83d0ka0a07a9fd9b276b4@mail.gmail.com> <466EC08A.76E4.0078.0@novell.com> <a781481a0706120709v5a2d1147m9d372a8056aeba6d@mail.gmail.com> <20070612180002.GC15329@uranus.ravnborg.org> <a781481a0706122018i6273cd17y61cd95e269b5c7c9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a781481a0706122018i6273cd17y61cd95e269b5c7c9@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Yup, we were only discussing possibility that modpost not complain
> about .init -> .exit references that will never go oops (because the arch
> guarantees that).

And there are no good reasosns why the rules should be different for i386
and powerpc.
This type of special casing is always bad.
Think about it a little.
Someone writes a generic driver and test it on i386 - OK.
But for powerpc it result in a build failure. It would be so much better
to warn about this situation early.

We had this exact issue in loop.c recently - so it is not a made up example.
[I recall it was ia64 that had a build failure but the example still holds ture]

	Sam
