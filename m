Return-Path: <linux-kernel-owner+w=401wt.eu-S1754103AbYICVQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbYICVQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 17:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbYICVQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 17:16:46 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40414
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752293AbYICVQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 17:16:45 -0400
Date: Wed, 03 Sep 2008 14:16:38 -0700 (PDT)
Message-Id: <20080903.141638.121245807.davem@davemloft.net>
To: s.L-H@gmx.de
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [patch 29/42] net: Unbreak userspace which includes
 linux/mroute.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <200809032117.00425.s.L-H@gmx.de>
References: <20080903171927.534216229@mini.kroah.org>
	<20080903172624.GD7731@suse.de>
	<200809032117.00425.s.L-H@gmx.de>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Date: Wed, 3 Sep 2008 21:16:56 +0200

> Hi
> 
> On Mittwoch, 3. September 2008, Greg KH wrote:
> > 2.6.26-stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > 
> > From: David S. Miller <davem@davemloft.net>
> > 
> > [ Upstream commit 7c19a3d280297d43ef5ff7c6b205dc208a16d3d1 ]
> > 
> > This essentially reverts two commits:
> > 
> > 1) 2e8046271f68198dd37451017c1a4a2432e4ec68 ("[IPV4] MROUTE: Move PIM
> >    definitions to <linux/pim.h>.")
> > 
> > and
> > 
> > 2) 80a9492a33dd7d852465625022d56ff76d62174d ("[IPV4] MROUTE: Adjust
> >    include files for user-space.")
> > 
> > which broke userpsace, in particular the XORP build as reported by
> > Jose Calhariz, the debain package maintainer for XORP.
> > 
> > Nothing originally in linux/mroute.h was exported to userspace
> > ever, but some of this stuff started to be when it was moved into
> > this new linux/pim.h, and that was wrong.  If we didn't provide these
> > definitions for 10 years we can reasonable expect that applications
> > defined this stuff locally or used GLIBC headers providing the
> > protocol definitions.  And as such the only result of this can
> > be conflict and userland build breakage.
> > 
> > The commit #1 had such a short and terse commit message, that we
> > cannot even know why such a move and set of new userland exports were
> > even made.
> > 
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > ---
> >  include/linux/Kbuild   |    1 -
> >  include/linux/mroute.h |   25 +++++++++++++++++++++----
> >  include/linux/pim.h    |   45 ---------------------------------------------
> >  3 files changed, 21 insertions(+), 50 deletions(-)
> 
> This patch is missing to remove the include for linux/pim.h in 
> net/ipv6/ip6mr.c, leading to the following build failure:

Sorry, I sent the wrong patch. :-?

Greg please drop this, I'll send you a fixed version.

