Return-Path: <linux-kernel-owner+w=401wt.eu-S1757497AbYLESjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497AbYLESjV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 13:39:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754570AbYLESis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 13:38:48 -0500
Received: from kroah.org ([198.145.64.141]:49039 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754010AbYLESiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 13:38:46 -0500
Date: Fri, 5 Dec 2008 10:36:57 -0800
From: Greg KH <greg@kroah.com>
To: Tejun Heo <tj@kernel.org>
Cc: Greg KH <gregkh@suse.de>, "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>, torvalds@linux-foundation.org,
       Eugene Teo <eteo@redhat.com>, Justin Forbes <jmforbes@linuxtx.org>,
       linux-kernel@vger.kernel.org, Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>,
       Randy Dunlap <rdunlap@xenotime.net>, Willy Tarreau <w@1wt.eu>,
       Michael Krufky <mkrufky@linuxtv.org>, alan@lxorguk.ukuu.org.uk,
       Chuck Ebbert <cebbert@redhat.com>, Jeff Garzik <jgarzik@redhat.com>,
       Dave Jones <davej@redhat.com>, akpm@linux-foundation.org,
       Jake Edge <jake@lwn.net>, Chuck Wolber <chuckw@quantumlinux.com>,
       stable@kernel.org, Rodrigo Rubira Branco <rbranco@la.checkpoint.com>
Subject: Re: [stable] [patch 067/104] libata: improve phantom device
	detection
Message-ID: <20081205183657.GC2144@kroah.com>
References: <20081203193901.715896543@mini.kroah.org> <20081203195323.GP8950@kroah.com> <49375A7F.10407@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49375A7F.10407@kernel.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2008 at 01:20:15PM +0900, Tejun Heo wrote:
> > 2.6.27-stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > From: Tejun Heo <tj@kernel.org>
> > 
> > commit 6a6b97d360702b98c02c7fca4c4e088dcf3a2985 upstream.
> > 
> > Currently libata uses four methods to detect device presence.
> > 
> > 1. PHY status if available.
> > 2. TF register R/W test (only promotes presence, never demotes)
> > 3. device signature after reset
> > 4. IDENTIFY failure detection in SFF state machine
> > 
> > Combination of the above works well in most cases but recently there
> > have been a few reports where a phantom device causes unnecessary
> > delay during probe.  In both cases, PHY status wasn't available.  In
> > one case, it passed #2 and #3 and failed IDENTIFY with ATA_ERR which
> > didn't qualify as #4.  The other failed #2 but as it passed #3 and #4,
> > it still caused failure.
> > 
> > In both cases, phantom device reported diagnostic failure, so these
> > cases can be safely worked around by considering any !ATA_DRQ IDENTIFY
> > failure as NODEV_HINT if diagnostic failure is set.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> Alan thinks this patch could cause regression.  Given that we're
> nearing the end of 2.6.28-rc cycles, I don't think it's critical to
> include this into 2.6.27-stable or at least it can wait a bit more.

Ok, I'll transfer it over to the next 2.6.27-stable release.

thanks,

greg k-h
