Return-Path: <linux-kernel-owner+w=401wt.eu-S1757994AbYLDBcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994AbYLDBcu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 20:32:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755262AbYLDBci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 20:32:38 -0500
Received: from gate.crashing.org ([63.228.1.57]:44671 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754849AbYLDBch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 20:32:37 -0500
Subject: Re: [Bug #12158] commit b1ee26b freezes system on switching from X
 to text console
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Gaudenz Steinlin <gaudenz@debian.org>
In-Reply-To: <alpine.LFD.2.00.0812031642280.3256@nehalem.linux-foundation.org>
References: <QFIA5HSHV8B.A.2aG.hoxNJB@chimera>
	 <bfPM5B8Tx2B.A.8DH.voxNJB@chimera>
	 <alpine.LFD.2.00.0812031642280.3256@nehalem.linux-foundation.org>
Content-Type: text/plain
Date: Thu, 04 Dec 2008 12:31:26 +1100
Message-Id: <1228354286.7356.275.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-03 at 16:44 -0800, Linus Torvalds wrote:
> 
> On Wed, 3 Dec 2008, Rafael J. Wysocki wrote:
> >
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.27.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12158
> > Subject		: commit b1ee26b freezes system on switching from X to text console
> > Submitter	: Gaudenz Steinlin <gaudenz@debian.org>
> > Date		: 2008-11-25 19:44 (9 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b1ee26bab14886350ba12a5c10cbc0696ac679bf
> > References	: http://marc.info/?l=linux-kernel&m=122764344231140&w=4
> > Handled-By	: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> 
> I think we're assuming that this already got fixed by commit 
> c4c6fa9891f3d1bcaae4f39fb751d5302965b566 ("radeonfb: fix problem with 
> color expansion & alignment").

No, this is a different problem I think. That race between VT switch and
X, which I -suspect- may be an X bug. I haven't managed to pin it down
yet, so what I may do for .28 is send a patch that disables color
expansion acceleration unless you explicitely request it via a module
param. At least until I can find what's going on.

Cheers,
Ben.

