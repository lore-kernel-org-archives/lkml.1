Return-Path: <linux-kernel-owner+w=401wt.eu-S1753474AbYGURzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474AbYGURzZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 13:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbYGURzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 13:55:12 -0400
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:29941 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbYGURzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 13:55:11 -0400
Date: Mon, 21 Jul 2008 19:34:26 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Greg K-H <greg@kroah.com>
Subject: Re: [PATCH] block: fix block_class iteration locking
Message-ID: <20080721193426.28ad925c@gondolin>
In-Reply-To: <487B3DA1.7010906@kernel.org>
References: <487AECD0.5010602@kernel.org>
	<20080714134228.1079c6f7@gondolin.boeblingen.de.ibm.com>
	<487B3DA1.7010906@kernel.org>
Organization: IBM Deutschland Research & Development GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2008 20:50:57 +0900,
Tejun Heo <tj@kernel.org> wrote:

> > With your patch, you protect against adding/removing devices to/from
> > the class between _start and _stop. This wasn't done previously, and
> > won't be done with Greg's patches (which leaves in the
> > locking/unlocking of block_class_lock). Not sure if I'm missing
> > something here...
> 
> That's mostly the point of this patch.  It wasn't protected properly
> before.  It would be best if there's a safe iterator (maybe use klist?).

Hm, I don't see how a klist would help here since it still allows to
add/remove devices during walking the file.

What we need is more like a "lock/unlock the device list" operation and
a lockless iterator - that would give the same semantics as your patch.
