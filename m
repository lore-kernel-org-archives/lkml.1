Return-Path: <linux-kernel-owner+w=401wt.eu-S1758399AbZKYJ1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758399AbZKYJ1B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 04:27:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758242AbZKYJ1B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 04:27:01 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58728 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbZKYJ1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 04:27:00 -0500
Date: Wed, 25 Nov 2009 10:26:56 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Yang Hongyang <yanghy@cn.fujitsu.com>, Alan Cox <alan@linux.intel.com>,
       linux-scsi@vger.kernel.org, Alan Cox <alan@redhat.com>
Subject: Re: [PATCH 02/38] move atp870u_remove to .devexit.text
Message-ID: <20091125092656.GA14459@pengutronix.de>
References: <1259096853-18909-1-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-2-git-send-email-u.kleine-koenig@pengutronix.de> <1259098696.4549.643.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1259098696.4549.643.camel@mulgrave.site>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 03:38:16PM -0600, James Bottomley wrote:
> On Tue, 2009-11-24 at 22:06 +0100, Uwe Kleine-König wrote:
> > The function atp870u_remove is used only wrapped by __devexit_p so define
> > it using __devexit.
> 
> But there's really no point to this.  HOTPLUG is always defined on SCSI
> systems that have these drivers, which means that _devinit/exit are
> nops.  That makes the change purely cosmetic and not worth churning two
> dozen drivers for.
> 
> Even for the EMBEDDED cases that should care about this, the maintainers
> have indicated that the memory savings simply aren't worth the hassle of
> tracking the sectional updates.
I think there are people that care.  Anyhow, then the best thing you can
do is something like

	find drivers/scsi -type f -print0 | xargs perl -p -i -e 's/\b__(dev)?exit(_p)?\b//'

Then my scripts will drop the scsi related patches.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
