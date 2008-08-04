Return-Path: <linux-kernel-owner+w=401wt.eu-S1753460AbYHDIhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbYHDIhO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 04:37:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbYHDIhB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 04:37:01 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60963 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751890AbYHDIhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 04:37:00 -0400
Date: Mon, 4 Aug 2008 09:19:30 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Keith Packard <keithp@keithp.com>
Cc: Ingo Oeser <ioe-lkml@rameria.de>, keithp@keithp.com,
       John Stoffel <john@stoffel.org>, Christoph Hellwig <hch@infradead.org>,
       Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org
Subject: Re: files/process scaling problem? (was: [PATCH] Export
 shmem_file_setup and shmem_getpage for DRM-GEM)
Message-ID: <20080804091930.164f31c3@lxorguk.ukuu.org.uk>
In-Reply-To: <1217809152.23437.401.camel@koto.keithp.com>
References: <1217573919-7496-1-git-send-email-eric@anholt.net>
	<18581.43362.460694.60862@stoffel.org>
	<1217785943.23437.330.camel@koto.keithp.com>
	<200808040135.32563.ioe-lkml@rameria.de>
	<1217809152.23437.401.camel@koto.keithp.com>
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

> The other issue is that several important applications (including the X
> server) use select instead of poll, and they have a small maximum number
> of fds that they support. It seems like this could be worked around by
> dup2'ing the shmem fds up a ways.

That would work yes. Switching to poll() would probably be even smarter,
or if you have a large number of fds being scanned take a look at epoll
which is likely to be far more efficient but wouldn't be available on so
many systems - poll is at least standard.
