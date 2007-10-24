Return-Path: <linux-kernel-owner+w=401wt.eu-S1758459AbXJXUMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758459AbXJXUMp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 16:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbXJXUMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 16:12:36 -0400
Received: from hpsmtp-eml16.KPNXCHANGE.COM ([213.75.38.116]:8062 "EHLO
	hpsmtp-eml16.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754079AbXJXUMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 16:12:35 -0400
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] portman2x4.c: fix boot hang
Cc: linux-kernel@vger.kernel.org, perex@suse.cz, tiwai@suse.de,
       torvalds@linux-foundation.org
In-reply-To: <20071024194417.GA17025@elte.hu>
References: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org> <20071024194417.GA17025@elte.hu>
Message-Id: <E1Ikmae-0000at-OB@faramir.fjphome.nl>
From: Frans Pop <elendil@planet.nl>
Date: Wed, 24 Oct 2007 22:12:32 +0200
X-OriginalArrivalTime: 24 Oct 2007 20:12:32.0924 (UTC) FILETIME=[361535C0:01C8167A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>  if ((parport_read_status(p) & ESTB) == ESTB)
> -		return 1;	/* CODE 1 - Strobe Failure. */
> +		return -EIO;	/* CODE 1 - Strobe Failure. */
>  
>  /* Set for RXDATA0 where no damage will be done. */
>  /* 5 */
> @@ -475,7 +475,7 @@ static int portman_probe(struct parport
>  
>  /* 6 */
>  if ((parport_read_status(p) & ESTB) != ESTB)
> -		return 1;	/* CODE 1 - Strobe Failure. */
> +		return -EIO;	/* CODE 1 - Strobe Failure. */

Why are you keeping the "CODE 1" comment? Just "Strobe Failure" as comment 
would seem more consistent with the change.
