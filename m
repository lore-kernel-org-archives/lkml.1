Return-Path: <linux-kernel-owner+w=401wt.eu-S1752076Ab0AIIpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076Ab0AIIpO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 03:45:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857Ab0AIIpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 03:45:12 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:6713 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab0AIIpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 03:45:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=ukWQNyJr3tQF4ymhk0zgEEAhxmTL6SKpXAr/GUX5RM6qkQNQXIo/Frwx7Ggl33dIcK
         5aKo1emxeUuIV0lYze1XsyWSdIQCx29yp39lXmWunI5HF+3Qo0d8kgAjQMJl4RU5KdME
         vm6rPs/TfbF5P8yOrT9vuP0CyG3PjI/ZCNOSA=
Date: Sat, 9 Jan 2010 11:44:38 +0300
From: Dan Carpenter <error27@gmail.com>
To: horms@vergenet.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>, Peter Huewe <PeterHuewe@gmx.de>
Subject: Re: [patch 6/6] otus: zfRateCtrlRateDiff(): remove duplicate
	comparison
Message-ID: <20100109084438.GD7840@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>, horms@vergenet.net,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Peter Huewe <PeterHuewe@gmx.de>
References: <20100108075748.059645106@vergenet.net> <20100108075921.504899210@vergenet.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100108075921.504899210@vergenet.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 08, 2010 at 06:57:54PM +1100, horms@vergenet.net wrote:
> I think this is correct.
> 
> $ gcc (Debian 4.4.2-8) 4.4.2
> Copyright (C) 2009 Free Software Foundation, Inc.
> This is free software; see the source for copying conditions.  There is NO
> warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> 
> $ make
> ...
> drivers/staging/otus/80211core/ratectrl.c: In function
> 'zfRateCtrlRateDiff':
> drivers/staging/otus/80211core/ratectrl.c:433: warning: suggest parentheses
> around comparison in operand of '=='
> ...
> 
> Signed-off-by: Simon Horman <horms@verge.net.au>
> 
> Index: linux-2.6/drivers/staging/otus/80211core/ratectrl.c
> ===================================================================
> --- linux-2.6.orig/drivers/staging/otus/80211core/ratectrl.c	2010-01-08 17:13:44.000000000 +1100
> +++ linux-2.6/drivers/staging/otus/80211core/ratectrl.c	2010-01-08 17:14:02.000000000 +1100
> @@ -430,7 +430,7 @@ u8_t zfRateCtrlRateDiff(struct zsRcCell*
>              {
>                  return ((rcCell->currentRateIndex - i)+1)>>1;
>              }
> -            else if (i == rcCell->currentRateIndex == 0)
> +            else if (i == rcCell->currentRateIndex)

You realize you have reversed the meaning of the test?  The original 
was the same as if (i != rcCell->currentRateIndex).

Your patch is possibly correct, but it's hard to know.  I would
leave this for now until someone grovels through the code to find
out for sure if it should be == or !=.  If we silence the warning,
no one will ever look at this code again.

regards,
dan carpenter

