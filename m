Return-Path: <linux-kernel-owner+w=401wt.eu-S1757494AbYA2XVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494AbYA2XVd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 18:21:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbYA2XVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 18:21:25 -0500
Received: from c60.cesmail.net ([216.154.195.49]:18931 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794AbYA2XVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 18:21:24 -0500
Subject: Re: ndiswrapper and GPL-only symbols redux
From: Pavel Roskin <proski@gnu.org>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Giridhar Pemmasani <pgiri@yahoo.com>
In-Reply-To: <24944.1201645637@turing-police.cc.vt.edu>
References: <1201641765.18773.35.camel@dv>
	 <24944.1201645637@turing-police.cc.vt.edu>
Content-Type: text/plain
Date: Tue, 29 Jan 2008 18:21:23 -0500
Message-Id: <1201648883.18773.95.camel@dv>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-01-29 at 17:27 -0500, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 29 Jan 2008 16:22:45 EST, Pavel Roskin said:
> > Hello!
> > 
> > It have come to my attention that a patch has been committed to the
> > kernel with the explicit purpose of tainting ndiswrapper - the kernel
> > module allowing Windows NDIS drivers for Ethernet and Wireless cards to
> > be used by the kernel.
> 
> At some point, a compromise position of "Have ndiswrapper do the tainting
> if it loads something with contentious licensing" was suggested - whatever
> happened to that?
> 
> (If for no other reason than if you load ndiswrapper for testing, and then
> do *not* actually load something, your kernel should remain untainted...)

We should distinguish kernel tainting and module tainting.  Kernel
tainting affects the stack dumps.  Module tainting affects access to
GPL-only symbols.

Kernel tainting for "ndiswrapper" is in the code already.  The patch I'm
complaining about is replacing kernel tainting with both kinds of
tainting.

Of course, ndiswrapper could taint itself as a module, but it would be a
purely symbolic act, since the module would be loaded already, and the
GPL-only symbols resolved.

-- 
Regards,
Pavel Roskin
