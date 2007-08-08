Return-Path: <linux-kernel-owner+w=401wt.eu-S935412AbXHHOxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935412AbXHHOxP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 10:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763348AbXHHOxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 10:53:00 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:56921
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754316AbXHHOxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 10:53:00 -0400
Subject: Re: Serial buffer memory leak
From: Paul Fulghum <paulkf@microgate.com>
To: Laurent Pinchart <laurentp@cse-semaphore.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <200708081628.36897.laurentp@cse-semaphore.com>
References: <200708081158.06843.laurentp@cse-semaphore.com>
	 <20070808144532.5e3a1998@the-village.bc.nu>
	 <1186582307.3394.3.camel@x2.microgate.com>
	 <200708081628.36897.laurentp@cse-semaphore.com>
Content-Type: text/plain
Date: Wed, 08 Aug 2007 09:52:55 -0500
Message-Id: <1186584775.3508.13.camel@x2.microgate.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-08 at 16:28 +0200, Laurent Pinchart wrote:

> The patch fixes the problem (at least under the test conditions that lead me 
> to discover it in the first place). Thanks Alan.

It works here also, but I see a problem.

By deferring the flush, ioctl(TCFLSH) returns immediately
even though there is possibly still receive data being fed
to the ldisc.

If this is followed immediately by a read() then the
application gets unexpected (stale) data defeating the
purpose of the TCFLSH.

tty_buffer_flush() needs to wait for buf.flushpending to clear.

 
--
Paul Fulghum
Microgate Systems, Ltd

