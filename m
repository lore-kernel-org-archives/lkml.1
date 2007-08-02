Return-Path: <linux-kernel-owner+w=401wt.eu-S1759726AbXHBVDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759726AbXHBVDU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 17:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755735AbXHBVDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 17:03:10 -0400
Received: from styx.suse.cz ([82.119.242.94]:44503 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755068AbXHBVDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 17:03:08 -0400
Date: Thu, 2 Aug 2007 23:03:21 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Sergey Vlasov <vsu@altlinux.ru>, Ulrich Kunitz <kune@deine-taler.de>,
       Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
       Jan Kratochvil <honza@jikos.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Is PIE randomization breaking klibc binaries?
In-Reply-To: <46B22C25.2070601@zytor.com>
Message-ID: <Pine.LNX.4.64.0708022259170.1779@jikos.suse.cz>
References: <20070720211300.GA21644@deine-taler.de> <46A131BF.4080404@zytor.com>
 <46A6624E.60003@redhat.com> <46A667BD.5080106@redhat.com>
 <20070724220053.GA20531@deine-taler.de> <46A68003.6060901@redhat.com>
 <46A68118.9080902@zytor.com> <20070725063243.GA25148@deine-taler.de>
 <20070802230219.97b7f7b5.vsu@altlinux.ru> <46B22C25.2070601@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Aug 2007, H. Peter Anvin wrote:

> Yup... it should probably be pointed out the reason the old kernel 
> worked was nothing but pure dumb luck.  This was a GNU ld change which 
> needed to be undone for klibc.  It's unfortunate that stock x86-64 
> binaries leave as little of a null pointer range as they do, but that's 
> life, unfortunately.  The other alternative is to map klibc just below 
> the 2 GB point, which would also work, but the old way broke when the ld 
> change went in.  As previously stated, klibc-1.4.35 or higher fixes 
> this.

Thanks for pointing this out. So it seems that maybe the mainline revert 
of pie-randomization.patch was a little bit premature. Bret -- could you 
please clarify whether you have experienced also klibc-related segfaults 
with pie-randomization.patch applied, or you have had just random binaries 
segfaulting, as you pointed out here: http://lkml.org/lkml/2007/7/21/31

Seems like you are also using ubuntu, same as Ulrich, so you might have 
been hitting the very same behavior of klibc-1.4.

Thanks in advance for clarifying this, so that I can eventually resubmit 
the pie-randomization patch.

Thanks,

-- 
Jiri Kosina
SUSE Labs
