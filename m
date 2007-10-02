Return-Path: <linux-kernel-owner+w=401wt.eu-S1756758AbXJBV0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758AbXJBV0y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 17:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755776AbXJBV0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 17:26:46 -0400
Received: from smtp-102-tuesday.nerim.net ([62.4.16.102]:59742 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755762AbXJBV0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 17:26:46 -0400
Date: Tue, 2 Oct 2007 23:26:42 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-rc8 build failure: __you_cannot_kmalloc_that_much in
 dmi_id_init
Message-ID: <20071002232642.568ea660@hyperion.delvare>
In-Reply-To: <20071001235412.0737de78@hyperion.delvare>
References: <20071001225447.20f989aa@hyperion.delvare>
	<20071001235412.0737de78@hyperion.delvare>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Oct 2007 23:54:12 +0200, Jean Delvare wrote:
> On Mon, 1 Oct 2007 22:54:47 +0200, Jean Delvare wrote:
> > 2.6.23-rc8 and 2.6.23-rc8-git4 fail to build on one of my test
> > machines, with:
> > 
> > drivers/built-in.o(.init.text+0x780e): In function `dmi_id_init':
> > : undefined reference to `__you_cannot_kmalloc_that_much'
> > 
> > The code is allocating sizeof(struct device) so it really shouldn't be
> > a problem. I have no idea what's wrong. That's on i386, very old
> > machine (Pentium 166MMX / Intel TX chipset), with gcc 3.2.3 and
> > binutils 2.14.90.0.6. 2.6.22.9 compiles fine on the same system (but it
> > doesn't include dmi-id so it's not very surprising).
> > 
> > .config attached.
> 
> More information: building the same config on a much more recent system
> works fine. This seems to point at a toolchain issue.

More information:
* No improvement in 2.6.23-rc9.
* Building the same config on a different system with the same
  toolchain, fails the same. So it's not just one system acting weirdly,
  the bug can be reproduced.
* I tried arbitrary values for the kzalloc() in dmi-id.c, the bottom line
  is that anything above 64 bytes triggers the bug.
* The same kzalloc() in a different driver doesn't trigger the bug.

I'm puzzled, no idea what to try next.

-- 
Jean Delvare
