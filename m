Return-Path: <linux-kernel-owner+w=401wt.eu-S1760111AbYBZBd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760111AbYBZBd1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 20:33:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbYBZBdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 20:33:18 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:53578 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752672AbYBZBdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 20:33:17 -0500
X-Sasl-enc: B8CJ3RdtKRfgX3ANhCGFeRUkF/O948K604pEMNqL/8vD 1203989595
Date: Mon, 25 Feb 2008 22:33:12 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC] Disk shock protection (revisited)
Message-ID: <20080226013312.GA24646@khazad-dum.debian.net>
References: <87skzgd1zk.fsf@denkblock.local> <47C35714.4090604@garzik.org> <87ejb0d0eu.fsf@denkblock.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ejb0d0eu.fsf@denkblock.local>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008, Elias Oltmanns wrote:
> > You don't want, for example, to swap out other apps, swap in the
> > daemon, in order to handle a sudden acceleration.
> 
> Quite. But with mlock this particular problem can be handled in user
> space just fine. The only reason I can see right now for putting this

And, as long as there is a way to also invoke it from within the kernel, we
can call it from inside the kernel as well when there is a reason to make
that function available.  Full flexibility is easily attainable here and
nothing we should bother about too much.

> logic into the kernel as well is to keep the functionality around even

Some hardware (Apple's?) has the entire APS logic in firmware (and AFAIK
*also* export the accelerometer data for other uses).  On those boxes, if
you want to trust the firmware, you just ignore the accelerometer and hook
to an interrupt.  When you get the interrupt, you freeze the queue and
unload heads.  Adding that to work in-kernel would be trivial.

Adding a suspend-time-only emergency HDAPS in-kernel monitor thread would
also be doable, if we wanted to duplicate that for ThinkPads (I don't really
think it is needed, but...).  As long as queue freezing and the required
unload immediate procedure can be called in at *any* time before the disk
device, and its buses and controller are suspended, it would do to implement
whatever we feel it is needed.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
