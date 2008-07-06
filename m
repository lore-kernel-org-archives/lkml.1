Return-Path: <linux-kernel-owner+w=401wt.eu-S1756774AbYGFOvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774AbYGFOvU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 10:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756905AbYGFOvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 10:51:08 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48815 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757090AbYGFOvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 10:51:07 -0400
Subject: Re: [linux-dvb] [PATCH] Remove fdump tool for av7110 firmware
From: David Woodhouse <dwmw2@infradead.org>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
Cc: Klaus Schmidinger <Klaus.Schmidinger@cadsoft.de>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       kernel-janitors <kernel-janitors@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jaswinder Singh <jaswinder@infradead.org>, linux-dvb@linuxtv.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <412bdbff0807060729o639f98b1s383d146856feb6da@mail.gmail.com>
References: <1214139259.2994.8.camel@jaswinder.satnam>
	 <200807060315.51736@orion.escape-edv.de> <48708BBF.9050400@cadsoft.de>
	 <1215343022.10393.945.camel@pmac.infradead.org>
	 <412bdbff0807060729o639f98b1s383d146856feb6da@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 06 Jul 2008 15:48:02 +0100
Message-Id: <1215355682.3189.101.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-07-06 at 10:29 -0400, Devin Heitmueller wrote:
> Correct me if I'm wrong, but doesn't this also affect those
> distributions that consider kernels with binary firmware blobs to not
> be free software?  Those distributions take the stance that the
> firmware must be loadable by userland, in which case the proposed
> patch removes this capability.

No, it doesn't remove that capability.

We're just observing that the trick which fdump.c uses to turn firmware
into a hex array in C source is obsoleted by the generic ability to
include firmware blobs into the kernel using CONFIG_EXTRA_FIRMWARE. If
we just use the generic method, then the conditional code in the driver
can go away, as can the fdump tool.

Yes, that does mean that it's either in the _kernel_ or in userspace,
rather than being in the .ko file -- but if you want modularity and are
already depending on having a functional userspace, it doesn't seem to
make a lot of sense to have this reimplementation of generic
functionality, just so that you can keep the two parts in _one_ file.

-- 
dwmw2

