Return-Path: <linux-kernel-owner+w=401wt.eu-S1753111AbYIHKWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111AbYIHKWF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 06:22:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbYIHKVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 06:21:54 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59805 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751983AbYIHKVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 06:21:53 -0400
Date: Mon, 8 Sep 2008 11:21:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pascal GREGIS <pgs@synerway.com>
Cc: linux-kernel@vger.kernel.org, Mark Lord <lkml@rtr.ca>
Subject: Re: SCSI or libata problem with an RDX removable disk
Message-ID: <20080908112134.7bca9dea@lxorguk.ukuu.org.uk>
In-Reply-To: <20080904135216.GF2814@venus.synerway.com>
References: <20080904095447.GE2814@venus.synerway.com>
	<20080904123418.4fab9ea3@lxorguk.ukuu.org.uk>
	<20080904135216.GF2814@venus.synerway.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sep  4 08:03:08 devsni1 kernel: ata4: port is slow to respond, please be patient (Status 0xd0)
> Sep  4 08:03:31 devsni1 kernel: ata4: port failed to respond (30 secs, Status 0xd0)
> Sep  4 08:03:31 devsni1 kernel: ata4: soft resetting port
> Sep  4 08:03:32 devsni1 kernel: ATA: abnormal status 0xD0 on port 0x0001d807
> Sep  4 08:03:32 devsni1 last message repeated 4 times

Your disk went offline and then refused to come back when the link was
reset. The initial trigger appears to have been the drive, the fact it
didn't come back could either be the drive or a controller problem. We've
seen a few cases where devices or controllers fail to recover from one
end being stuck expecting data.

Mark Lord did some patches to try and drain data in this case but I don't
remember if they were merged yet.

Alan
