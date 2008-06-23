Return-Path: <linux-kernel-owner+w=401wt.eu-S1750971AbYFWWql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750971AbYFWWql (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 18:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750989AbYFWWqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 18:46:12 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:15159 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbYFWWqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 18:46:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=htT4n6dSi/i2EGYQ8v9IoqWNDKzdeu5aGp0S5Z5tYJK3ndI8BpKn9DLrt6tF9HuGIK
         4u7ZIvyaYgrQTZTz1JOtFy/K5lwAdz1hx9O+1DxvUhU0diMuKQNn4e+v9NJG18WvnnJG
         WtBVYkuT6Jsx9lgJCbhy6IhLwacOo1bQwEhB4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Elias Oltmanns <eo@nebensachen.de>
Subject: Re: [PATCH] IDE: Fix HDIO_DRIVE_RESET handling
Date: Tue, 24 Jun 2008 00:47:28 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>
References: <87k5gmz596.fsf@denkblock.local> <87r6apuk16.fsf@denkblock.local> <87wskgtwwm.fsf@denkblock.local>
In-Reply-To: <87wskgtwwm.fsf@denkblock.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806240047.29118.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 June 2008, Elias Oltmanns wrote:
> Elias Oltmanns <eo@nebensachen.de> wrote:
> [...]
> > @@ -941,6 +949,7 @@ static ide_startstop_t atapi_reset_pollfunc (ide_drive_t *drive)
> >  	/* done polling */
> >  	hwgroup->polling = 0;
> >  	hwgroup->resetting = 0;
> 
> Actually, ->resetting needs to be protected by the ide_lock here.
> 
> [...]
> > @@ -1005,6 +1014,8 @@ static ide_startstop_t reset_pollfunc (ide_drive_t *drive)
> >  	}
> >  	hwgroup->polling = 0;	/* done polling */
> >  	hwgroup->resetting = 0; /* done reset attempt */
> 
> Same as above.  Unless I have missed something, a simple
> 
> spin_lock(&ide_lock)
> 
> should suffice since there cannot possibly be another interrupt that
> changes ->resetting behind our back.  I'll send an updated version of
> patches 1 and 4 once I have your opinion on the current series.

With patch #1 we may as well just remove ->resetting and allow the next
reset request to be added to the queue.
