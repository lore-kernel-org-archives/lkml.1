Return-Path: <linux-kernel-owner+w=401wt.eu-S1756071AbYIJXCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071AbYIJXCS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 19:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbYIJXCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 19:02:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53531 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbYIJXCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 19:02:04 -0400
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
From: David Woodhouse <dwmw2@infradead.org>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <48C68507.6000609@suse.com>
References: <48C68507.6000609@suse.com>
Content-Type: text/plain
Date: Wed, 10 Sep 2008 16:01:59 -0700
Message-Id: <1221087719.13621.50.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-09 at 10:15 -0400, Jeff Mahoney wrote:
>  This patch moves them to /lib/firmware/$KERNELRELEASE. udev v127's
>  firmware.sh looks there first before falling back to /lib/firmware.

NAK.

This isn't compatible with the version of udev that people actually have
installed, today. And it's also the _wrong_ thing to do.

Firmware really _isn't_ version-specific. If the firmware changes in
some incompatible way, then the filename given to request_firmware() has
to change too. Think of it like an soname on a library.

Besides, incompatible changes are fairly uncommon; firmware changes
rarely change the host<->device ABI in a way which breaks older drivers.
And that's _especially_ true for the firmwares which were present in the
kernel tree, which is all that you're moving around with this patch.

You shouldn't need more than one firmware package installed at a time --
if you are trying to do so, then that's a bug in your packaging.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

