Return-Path: <linux-kernel-owner+w=401wt.eu-S1030687AbXC2UcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030687AbXC2UcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 16:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030686AbXC2UcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 16:32:19 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:40378 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030684AbXC2UcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 16:32:18 -0400
Date: Thu, 29 Mar 2007 22:35:05 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Jeff Garzik <jeff@garzik.org>, Justin Piszcz <jpiszcz@lucidpixels.com>,
       linux@horizon.com, htejun@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Why is NCQ enabled by default by libata? (2.6.20)
Message-ID: <20070329223505.481a4f5e@the-village.bc.nu>
In-Reply-To: <460BF73C.5070707@cfl.rr.com>
References: <20070327161616.31448.qmail@science.horizon.com>
	<Pine.LNX.4.64.0703271224400.5965@p34.internal.lan>
	<460A7EE7.5070101@cfl.rr.com>
	<460A8053.3040209@garzik.org>
	<460BF73C.5070707@cfl.rr.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

O> writes, and sending down multiple untagged cached writes that complete 
> immediately and actually hit the disk later?  Either way the host keeps 
> sending writes to the disk until it's buffers are full, and the disk is 
> constantly trying to commit those buffers to the media in the most 
> optimal order.

On the controller side primarily you get to queue commands which means
you don't have a dead time period between the completion interrupt and
the next command being issued. Those times add up even when there is a
disk cache buffering the output
