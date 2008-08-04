Return-Path: <linux-kernel-owner+w=401wt.eu-S1763676AbYHDVDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763676AbYHDVDA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:03:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764028AbYHDVBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:01:51 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38160 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764004AbYHDVBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:01:50 -0400
Date: Mon, 4 Aug 2008 21:44:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Stuart <dstuart@rogers.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Problems with disk + network on 2.6.25.11-60.fc8
Message-ID: <20080804214441.0811138e@lxorguk.ukuu.org.uk>
In-Reply-To: <4897671F.1050003@rogers.com>
References: <48973EB9.90408@rogers.com>
	<20080804184232.601881a8@lxorguk.ukuu.org.uk>
	<4897671F.1050003@rogers.com>
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

Ok so the pdc202xx_old hardware flakes out when you have very high
network load (I'd guess in fact very high bus traffic).

The actual log is the disk I/O timing out, then the drive being busy
(probably due to the timeout and a DMA transfer getting stuck). We reset
it and carry on.

Libata happens to log this a lot more visibly than old kernels which is
useful but does mean people sometimes don't notice.

The rest then fits - the freeze I'd expect as we block I/O while trying
to get the drive back.

Doubt the Nvidia module is involved as I'd then expect problems under
high graphical load but you can certainly test that. I don't suppose
you've got a spare PCI network card you could try instead to see if it is
the network card bits ?

Alan
