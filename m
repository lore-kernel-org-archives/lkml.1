Return-Path: <linux-kernel-owner+w=401wt.eu-S2992745AbXCGXhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992745AbXCGXhL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 18:37:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992743AbXCGXhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 18:37:10 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49192 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992747AbXCGXhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 18:37:08 -0500
Date: Thu, 8 Mar 2007 00:40:56 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jiri Kosina <jikos@jikos.cz>, Jon Ringle <JRingle@vertical.com>,
       linux-kernel@vger.kernel.org
Subject: Re: tiny tty driver sample
Message-ID: <20070308004056.251a81e7@lxorguk.ukuu.org.uk>
In-Reply-To: <45EEFBA0.7030101@zytor.com>
References: <4DD3AF7ECBBC43409BA36508938D0185123A35@CVAEX1.VERTICAL.COM>
	<Pine.LNX.4.64.0703071730190.10909@twin.jikos.cz>
	<20070307182318.28d95c95@lxorguk.ukuu.org.uk>
	<45EEFBA0.7030101@zytor.com>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Unless data_size can be very large and high speed then you can replace the
> > lot with
> > 
> > 	if (tty_insert_flip_string(tty, data, data_size))
> > 		tty_flip_buffer_push(tty);
> > 
> 
> What does "very large and high speed" mean in this context?

The default behaviour is to generate buffers based upon perceived need
and then cycle them, so you tend to get chunks of 512 bytes or so. The
logic is abstracted into tty_buffer_find() so can easily be changed.

Some hardware at high speeds with big FIFOs (or virtualised interfaces)
produces big chunks of data in blocks with the size known at read time (eg
that with large fifos and 100 polls/sec) - for those you can avoid
generating a series of allocations or buffers by using the request_room
interface to hint the size of the buffer you will actually need.

