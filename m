Return-Path: <linux-kernel-owner+w=401wt.eu-S1754397AbYHDNvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397AbYHDNvX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 09:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752998AbYHDNvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 09:51:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:33557 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbYHDNvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 09:51:15 -0400
Date: Mon, 4 Aug 2008 06:51:01 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Keith Packard <keithp@keithp.com>, Ingo Oeser <ioe-lkml@rameria.de>,
       John Stoffel <john@stoffel.org>, Christoph Hellwig <hch@infradead.org>,
       Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org
Subject: Re: files/process scaling problem? (was: [PATCH] Export
 shmem_file_setup and shmem_getpage for DRM-GEM)
Message-ID: <20080804065101.6f70725a@infradead.org>
In-Reply-To: <20080804091930.164f31c3@lxorguk.ukuu.org.uk>
References: <1217573919-7496-1-git-send-email-eric@anholt.net>
	<18581.43362.460694.60862@stoffel.org>
	<1217785943.23437.330.camel@koto.keithp.com>
	<200808040135.32563.ioe-lkml@rameria.de>
	<1217809152.23437.401.camel@koto.keithp.com>
	<20080804091930.164f31c3@lxorguk.ukuu.org.uk>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Aug 2008 09:19:30 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > The other issue is that several important applications (including
> > the X server) use select instead of poll, and they have a small
> > maximum number of fds that they support. It seems like this could
> > be worked around by dup2'ing the shmem fds up a ways.
> 
> That would work yes. Switching to poll() would probably be even
> smarter, or if you have a large number of fds being scanned take a
> look at epoll which is likely to be far more efficient but wouldn't
> be available on so many systems - poll is at least standard.
> --

the hard part is that DRI is a library that gets linked into existing
applications... which already are using select ;-(

Fixing X is one thing and not impossible.. fixing all existing games in
the field is quite another


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
