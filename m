Return-Path: <linux-kernel-owner+w=401wt.eu-S1759897AbYE2VSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759897AbYE2VSl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 17:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754697AbYE2VSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 17:18:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46135 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205AbYE2VSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 17:18:30 -0400
Subject: Re: RFC: Moving firmware blobs out of the kernel.
From: David Woodhouse <dwmw2@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Theodore Tso <tytso@mit.edu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       James.Bottomley@HansenPartnership.com,
       ksummit-2008-discuss@lists.linux-foundation.org,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
In-Reply-To: <483F002E.5060002@garzik.org>
References: <1211995212.3445.52.camel@localhost.localdomain>
	 <20080528.225826.40264516.davem@davemloft.net>
	 <1212041839.8888.38.camel@pasglop>  <20080529124548.GC8065@mit.edu>
	 <1212077700.26088.83.camel@shinybook.infradead.org>
	 <483F002E.5060002@garzik.org>
Content-Type: text/plain
Date: Fri, 30 May 2008 00:18:11 +0300
Message-Id: <1212095891.18530.12.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-29 at 15:12 -0400, Jeff Garzik wrote:
> I like your idea, all the way to the point where you actually remove the 
> firmware file from the kernel tree :)

I've been careful to ensure that what I'm doing is a benefit even
without that final step. But I still think that final step is useful
too.

> If the firmware has a compatible license and is required for critical 
> operations like booting the machine, built-in firmware should remain an 
> option. 

Well, 'compatible licence' is a loaded question. It takes a fairly
wilful misinterpretation of 'mere aggregation', IMHO, to see what we're
currently doing as legal -- but I was trying to avoid that discussion
since it tends to devolve into name-calling and nobody's _actually_
right until/unless it's decided by a court.

But sticking to the technical side -- with what I have now, it's
_easier_ to build external firmware into the kernel than it was before.
My original testing was done with a kernel with the libertas
'usb8388.bin' firmware built in to it, for example. That was never
possible before.

Having firmware files in a separate tarball doesn't prevent you from
building them into your vmlinux if you want to. And there are some
companies who wouldn't allow their firmware to be distributed in the
kernel source tree because it's under GPL, but _would_ consider putting
it in a separate 'kernel-firmware' repository instead. So this should
_also_ mean we can ship more firmware, more easily.

Hell, with git submodules you almost don't need to notice the
difference, do you? Just check out kernel-firmware as a subdirectory of
the source tree (or point CONFIG_BUILTIN_FIRMWARE_DIR at wherever you
_did_ check it out), and you're done.

>  For certain embedded cases, I could certainly see that 
> in-kernel firmware being the best method for firmware distribution, for 
> both $Platform's users and $Platform's developers.

It is not my intention to remove that possibility. I believe I have made
it _more_ feasible; not less.

-- 
dwmw2

