Return-Path: <linux-kernel-owner+w=401wt.eu-S1755377AbXD0G3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377AbXD0G3N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 02:29:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755369AbXD0G3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 02:29:12 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:54191 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755379AbXD0G3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 02:29:12 -0400
Date: Fri, 27 Apr 2007 09:29:10 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
In-Reply-To: <Pine.LNX.4.64.0704270910190.18521@sbz-30.cs.Helsinki.FI>
Message-ID: <Pine.LNX.4.64.0704270927240.18521@sbz-30.cs.Helsinki.FI>
References: <1177567481.5025.211.camel@nigel.suspend2.net> 
 <84144f020704260028q190fc90fs8f9ea703e42e7910@mail.gmail.com> 
 <1177573348.5025.224.camel@nigel.suspend2.net> 
 <alpine.LFD.0.98.0704260941310.9964@woody.linux-foundation.org> 
 <1177617379.4737.29.camel@nigel.suspend2.net> 
 <Pine.LNX.4.64.0704270750320.13539@sbz-30.cs.Helsinki.FI>
 <1177654110.4737.91.camel@nigel.suspend2.net>
 <Pine.LNX.4.64.0704270910190.18521@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007, Nigel Cunningham wrote:
> > COW is a possibility, but I understood (perhaps wrongly) that Linus was
> > thinking of a single syscall or such like to prepare the snapshot. If
> > you're going to start doing things like this, won't that mean you'd then
> > have to update/redo the snapshot or somehow nullify the effect of
> > anything the programs does so that doing it again after the snapshot is
> > restored doesn't cause problems?

On Fri, 27 Apr 2007, Pekka J Enberg wrote:
> No. The snapshot is just that. A snapshot in time. From kernel point of 
> view, it doesn't matter one bit what when you did it or if the state has 
> changed before you resume. It's up to userspace to make sure the user 
> doesn't do real work while the snapshot is being written to disk and 
> machine is shut down.

Btw, obviously we need to break the COW when resuming and not include the 
snapshot mapping. However, that should be trivially doable by snapshotting 
the page mappings before remapping them as COW.

				Pekka
