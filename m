Return-Path: <linux-kernel-owner+w=401wt.eu-S1756719AbYFWHsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719AbYFWHsd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 03:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235AbYFWHsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 03:48:19 -0400
Received: from nebensachen.de ([195.34.83.29]:51937 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754240AbYFWHsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 03:48:10 -0400
X-Hashcash: 1:20:080623:bzolnier@gmail.com::gzCyxIam5ill7uY2:00000000000000000000000000000000000000000001not
X-Hashcash: 1:20:080623:linux-ide@vger.kernel.org::XWe1glCWuSTZrl3l:0000000000000000000000000000000000001K12
X-Hashcash: 1:20:080623:linux-kernel@vger.kernel.org::mQwfZ1Il0+z8By5K:000000000000000000000000000000000HLaM
X-Hashcash: 1:20:080623:randy.dunlap@oracle.com::RnoA128Mz8bkSeIq:000000000000000000000000000000000000004PQ5
From: Elias Oltmanns <eo@nebensachen.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] IDE: Fix HDIO_DRIVE_RESET handling
References: <87k5gmz596.fsf@denkblock.local>
	<200806192247.25063.bzolnier@gmail.com>
	<87wskhuk98.fsf@denkblock.local> <87r6apuk16.fsf@denkblock.local>
Date: Mon, 23 Jun 2008 09:47:53 +0200
In-Reply-To: <87r6apuk16.fsf@denkblock.local> (Elias Oltmanns's message of
	"Mon, 23 Jun 2008 01:28:21 +0200")
Message-ID: <87wskgtwwm.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Elias Oltmanns <eo@nebensachen.de> wrote:
[...]
> @@ -941,6 +949,7 @@ static ide_startstop_t atapi_reset_pollfunc (ide_drive_t *drive)
>  	/* done polling */
>  	hwgroup->polling = 0;
>  	hwgroup->resetting = 0;

Actually, ->resetting needs to be protected by the ide_lock here.

[...]
> @@ -1005,6 +1014,8 @@ static ide_startstop_t reset_pollfunc (ide_drive_t *drive)
>  	}
>  	hwgroup->polling = 0;	/* done polling */
>  	hwgroup->resetting = 0; /* done reset attempt */

Same as above.  Unless I have missed something, a simple

spin_lock(&ide_lock)

should suffice since there cannot possibly be another interrupt that
changes ->resetting behind our back.  I'll send an updated version of
patches 1 and 4 once I have your opinion on the current series.

Regards,

Elias
