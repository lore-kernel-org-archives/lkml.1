Return-Path: <linux-kernel-owner+w=401wt.eu-S1754020AbZEKO7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbZEKO7E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 10:59:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753014AbZEKO6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 10:58:52 -0400
Received: from toccata.ens-lyon.fr ([140.77.166.68]:53583 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbZEKO6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 10:58:51 -0400
X-Greylist: delayed 1623 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 May 2009 10:58:51 EDT
Date: Mon, 11 May 2009 16:31:48 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Stefan Lankes <lankes@lfbs.rwth-aachen.de>
Subject: Re: [RFC PATCH 0/4]: affinity-on-next-touch
Message-ID: <20090511143148.GG21290@const.u-bordeaux.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
	Stefan Lankes <lankes@lfbs.rwth-aachen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi writes:
> > With this patch, the kernel reduces the overhead of page distribution via
> > "affinity-on-next-touch" from 2518ms to 366ms compared to the user-level
> 
> The interesting part is less how much faster it is compared to an user
> space implementation, but how much this migrate on touch approach
> helps in general compared to already existing policies. Some hard
> numbers on that would appreciated.

That is described in the papers that Stefan mentioned.  The problem is
that quite often it is very hard or even impossible to know which data
should get which migration, because you have a sparse matrix which gets
accessed by threads according to intermediate results, for instance.

> Note that for the OpenMP case old kernels sometimes had trouble because
> the threads tended to be not scheduled to the final target CPU
> on the first time slice so the memory was often first-touched
> on the wrong node.

It's not only that kind of issue, but in a lot of applications memory
is initialized sequentially by the main thread (not only zeroing, but
also reading files etc).  Setting "next-touch" right after sequential
initialization would just work fine.

Samuel
