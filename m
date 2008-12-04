Return-Path: <linux-kernel-owner+w=401wt.eu-S1754859AbYLDEWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbYLDEWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 23:22:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751639AbYLDEWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 23:22:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:52972 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbYLDEWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 23:22:39 -0500
Message-ID: <49375A7F.10407@kernel.org>
Date: Thu, 04 Dec 2008 13:20:15 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jeff Garzik <jgarzik@redhat.com>
Subject: Re: [patch 067/104] libata: improve phantom device detection
References: <20081203193901.715896543@mini.kroah.org> <20081203195323.GP8950@kroah.com>
In-Reply-To: <20081203195323.GP8950@kroah.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 04 Dec 2008 04:20:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 2.6.27-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> From: Tejun Heo <tj@kernel.org>
> 
> commit 6a6b97d360702b98c02c7fca4c4e088dcf3a2985 upstream.
> 
> Currently libata uses four methods to detect device presence.
> 
> 1. PHY status if available.
> 2. TF register R/W test (only promotes presence, never demotes)
> 3. device signature after reset
> 4. IDENTIFY failure detection in SFF state machine
> 
> Combination of the above works well in most cases but recently there
> have been a few reports where a phantom device causes unnecessary
> delay during probe.  In both cases, PHY status wasn't available.  In
> one case, it passed #2 and #3 and failed IDENTIFY with ATA_ERR which
> didn't qualify as #4.  The other failed #2 but as it passed #3 and #4,
> it still caused failure.
> 
> In both cases, phantom device reported diagnostic failure, so these
> cases can be safely worked around by considering any !ATA_DRQ IDENTIFY
> failure as NODEV_HINT if diagnostic failure is set.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Alan thinks this patch could cause regression.  Given that we're
nearing the end of 2.6.28-rc cycles, I don't think it's critical to
include this into 2.6.27-stable or at least it can wait a bit more.

Thanks.

-- 
tejun
