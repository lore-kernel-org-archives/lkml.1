Return-Path: <linux-kernel-owner+w=401wt.eu-S1757338AbYGOUGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338AbYGOUGi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 16:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbYGOUGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 16:06:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56770 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbYGOUG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 16:06:29 -0400
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
From: David Woodhouse <dwmw2@infradead.org>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, david@lang.hm,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
In-Reply-To: <1216152021.27242.94.camel@violet.holtmann.net>
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
	 <1216146651.27455.336.camel@shinybook.infradead.org>
	 <1216152021.27242.94.camel@violet.holtmann.net>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 13:06:17 -0700
Message-Id: <1216152377.26991.10.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-15 at 22:00 +0200, Marcel Holtmann wrote:
> I really think we should use /lib/firmware/`uname -r`/. I do see the
> point here that I don't wanna overwrite existing firmware from other
> installed kernels. Especially if modules_install will install the
> firmware files.
> 
> So in case of non-Ubuntu distros we have to push a fix to udev, but that
> is not a big deal. It should be a one-line change if I am not mistaken.

My concern with that is that even though it's a one-line change, it's a
one-line change which people don't already _have_. We really do need to
remain compatible with existing setups.

For _now_, I think it's much better to leave it in /lib/firmware where
existing upstream udev will find it. Let's change udev ASAP and then we
can talk about when it makes sense to change the default setting of
$(INSTALL_FW_PATH) to match.

I'm not too worried about overwriting existing firmware
in /lib/firmware. We very rarely change firmware anyway, when we _do_
change it it's almost always compatible rather than having ABI changes.
On the rare occasions that remain, the incompatibly changed firmware
really ought to have a new filename so that older drivers don't pick it
up when they want the old one.

It's not a _complete_ non-problem, but it's fairly close. And the
incompatibility with existing upstream udev would be much more of an
issue, I think.

-- 
dwmw2

