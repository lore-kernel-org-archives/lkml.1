Return-Path: <linux-kernel-owner+w=401wt.eu-S932929AbXCRTad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932929AbXCRTad (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 15:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751078AbXCRTad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 15:30:33 -0400
Received: from colin.muc.de ([193.149.48.1]:2552 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbXCRTac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 15:30:32 -0400
Date: 18 Mar 2007 20:30:30 +0100
Date: Sun, 18 Mar 2007 20:30:30 +0100
From: Andi Kleen <ak@muc.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David Miller <davem@davemloft.net>, rusty@rustcorp.com.au, mingo@elte.hu,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       chrisw@sous-sol.org, zach@vmware.com, anthony@codemonkey.ws,
       torvalds@linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [patch 13/26] Xen-paravirt_ops: Consistently wrap paravirt ops callsites to make them patchable
Message-ID: <20070318193030.GB71548@muc.de>
References: <20070316.023331.59468179.davem@davemloft.net> <45FB005D.9060809@goop.org> <1174127638.8897.75.camel@localhost.localdomain> <20070318.003309.71088169.davem@davemloft.net> <20070318120814.GA45869@muc.de> <45FD619D.6030402@goop.org> <20070318170414.GB45869@muc.de> <45FD76E6.4060907@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45FD76E6.4060907@goop.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 18, 2007 at 10:29:10AM -0700, Jeremy Fitzhardinge wrote:
> Andi Kleen wrote:
> > You could use the dwarf2 unwind tables. They have exact information
> > what register has what. But it would likely get complicated.
> 
> Yes.  And would they be accurate for hand-written asm, which is where we
> have this problem?

Yes. All inline assembly tells gcc what registers are clobbered
and it fills in the tables. Hand clobbering in inline assembly cannot
be expressed with the current toolchain, so we moved all those
out of line.

But again I'm not sure it will work anyways. For once you would
need large padding around the calls anyways for inline replacement --
how would you generate that? I expect you would need to put the calls
into asm() again and with that a custom annotiation format looks reasonable.

-Andi
