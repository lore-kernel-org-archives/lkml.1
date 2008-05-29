Return-Path: <linux-kernel-owner+w=401wt.eu-S1757621AbYE2QP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757621AbYE2QP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 12:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753323AbYE2QPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 12:15:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47183 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527AbYE2QPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 12:15:11 -0400
Subject: RFC: Moving firmware blobs out of the kernel.
From: David Woodhouse <dwmw2@infradead.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       James.Bottomley@HansenPartnership.com,
       ksummit-2008-discuss@lists.linux-foundation.org,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
In-Reply-To: <20080529124548.GC8065@mit.edu>
References: <1211995212.3445.52.camel@localhost.localdomain>
	 <20080528.225826.40264516.davem@davemloft.net>
	 <1212041839.8888.38.camel@pasglop>  <20080529124548.GC8065@mit.edu>
Content-Type: text/plain
Date: Thu, 29 May 2008 19:15:00 +0300
Message-Id: <1212077700.26088.83.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-29 at 08:45 -0400, Theodore Tso wrote:
>  there is always the chance the topic will resolve itself via e-mail. 

I'm kind of hoping that this is going to be one of those topics that
resolves itself -- but just in case it isn't, I'd like to discuss it at
the kernel summit:

I'd like to remove all firmware blobs from the kernel source tree.

With the intention of making that less contentious, I've done the
following: 

I've added support to the firmware loader for finding firmware in a
special section of the static kernel, so that using request_firmware()
no longer forces you to use an initrd or udev. You can build _arbitrary_
firmware files into your kernel, if you want to. Whether you're allowed
to distribute the resulting vmlinux or not is still a question you ought
to ask your lawyer.

I'm working on converting drivers over to use request_firmware(), and
shifting their firmware blobs into .ihex files in a firmware/ directory
of the source tree. For each one, I'm giving the option of continuing to
build it in statically, using the above mechanism.

I've implemented a 'make firmware_install' Kbuild target, which takes
all those firmware blobs and installs them somewhere where udev can load
them on request.

By the time the kernel summit comes around, we should have made decent
progress on moving _all_ the firmware blobs to the firmware/ directory.
And at that point I'd like to remove them completely, to a separate git
tree and tarball. Those who really want to build them in to their static
kernel would still be able to, but it wouldn't be the default behaviour.

-- 
dwmw2

