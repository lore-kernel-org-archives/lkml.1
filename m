Return-Path: <linux-kernel-owner+w=401wt.eu-S1757968AbYGOSbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968AbYGOSbR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 14:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754402AbYGOSbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 14:31:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46566 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063AbYGOSbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 14:31:03 -0400
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
From: David Woodhouse <dwmw2@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, david@lang.hm,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.1.10.0807151124510.3017@woody.linux-foundation.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org>
	 <20080714164119.99c33d5b.akpm@linux-foundation.org>
	 <20080714165956.7fe2d4ee@infradead.org>
	 <alpine.DEB.1.10.0807141704120.14223@asgard.lang.hm>
	 <alpine.LFD.1.10.0807141729200.3017@woody.linux-foundation.org>
	 <alpine.DEB.1.10.0807141750290.14223@asgard.lang.hm>
	 <alpine.LFD.1.10.0807141756361.3017@woody.linux-foundation.org>
	 <alpine.DEB.1.10.0807141805300.14223@asgard.lang.hm>
	 <alpine.LFD.1.10.0807141903260.3017@woody.linux-foundation.org>
	 <487C585C.2060002@garzik.org>
	 <alpine.LFD.1.10.0807150803580.3017@woody.linux-foundation.org>
	 <487CD7FE.9010209@garzik.org>
	 <alpine.LFD.1.10.0807151008450.3017@woody.linux-foundation.org>
	 <487CDEC0.3090004@garzik.org>
	 <alpine.LFD.1.10.0807151041080.3017@woody.linux-foundation.org>
	 <487CEA73.9000408@garzik.org>
	 <alpine.LFD.1.10.0807151124510.3017@woody.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 11:30:51 -0700
Message-Id: <1216146651.27455.336.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-15 at 11:25 -0700, Linus Torvalds wrote:
> 
> On Tue, 15 Jul 2008, Jeff Garzik wrote:
> > 
> > Which is why 'make modules_install' installs the firmware, or at least it did
> > before David W pushed upstream.
> 
> So you're literally just about making this be "make modules_install" 
> rather than "make firmware_install"
> 
> Ok. Are you going to be happy if "make modules_install" just copies the 
> firmware files of the affected modules too?

I did that already. I'm not _entirely_ sure it was the right thing to
do, but it does help to reduce surprises when people don't realise that
a driver they're using now has separate firmware.

I don't believe it was the result of a constructive request from Jeff; I
think someone else suggested it in response to his whining. It may even
have been my idea, but I don't recall.

This is the current situation:

'make modules_install' will install the firmware required by the modules
it installs. It'll install that to $(INSTALL_MOD_PATH)/lib/firmware/
unless you override that by setting $(INSTALL_FW_PATH). So you can put
it into a kernel-specific directory if you want to.

'make firmware_install' will install _all_ available firmware files
to /lib/firmware (or $(INSTALL_FW_PATH)), regardless of architecture or
configuration. That's what Fedora is using for its 'kernel-firmware'
package, which is arch-independent and required by the various kernel
binary packages.

-- 
dwmw2

