Return-Path: <linux-kernel-owner+w=401wt.eu-S933699AbXHHPIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933699AbXHHPIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 11:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753449AbXHHPIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 11:08:46 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47801 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753006AbXHHPIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 11:08:46 -0400
Date: Wed, 8 Aug 2007 16:16:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Paul Fulghum <paulkf@microgate.com>
Cc: Laurent Pinchart <laurentp@cse-semaphore.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Serial buffer memory leak
Message-ID: <20070808161606.32a40793@the-village.bc.nu>
In-Reply-To: <1186584775.3508.13.camel@x2.microgate.com>
References: <200708081158.06843.laurentp@cse-semaphore.com>
	<20070808144532.5e3a1998@the-village.bc.nu>
	<1186582307.3394.3.camel@x2.microgate.com>
	<200708081628.36897.laurentp@cse-semaphore.com>
	<1186584775.3508.13.camel@x2.microgate.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> tty_buffer_flush() needs to wait for buf.flushpending to clear.

Not 100% sure it does as its no different to events really occuring with
a possible timing. Trivial to wait_event on the read queue for this
however and definitely worth doing to be sure.

Should probably make the flushpending an atomic bit op to avoid taking
and retaking the lock.

Alan
