Return-Path: <linux-kernel-owner+w=401wt.eu-S1765928AbYBNMSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765928AbYBNMSW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 07:18:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757478AbYBNMSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 07:18:11 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49174 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758790AbYBNMSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 07:18:09 -0500
Date: Thu, 14 Feb 2008 12:10:26 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Newall <davidn@davidnewall.com>
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Handshaking on USB serial devices
Message-ID: <20080214121026.16a9c510@core>
In-Reply-To: <47B40918.20206@davidnewall.com>
References: <47B30291.2040905@davidnewall.com>
	<20080214050211.GB1432@kroah.com>
	<47B40918.20206@davidnewall.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> To make it clear: Even aside from the buffer in 2.6's pl2303.c, there's
> a race: An in-flight write URB can fill all hardware buffers, making
> unsafe what previously appeared to be a safe write.  I think it's
> essential to delay submission of the URB on a stop-transmit condition.

Hardware flow control *is* a race, and always will be. The remote end has
a delay in signalling 'stop' there is a propogation delay and a response
delay. This is why most implementations assert stop a bit *before* they
run out.

Given the size of transfers and the internal buffering one would hope the
USB devices do their own flow control if told to properly.

Alan
