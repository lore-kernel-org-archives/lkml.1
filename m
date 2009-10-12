Return-Path: <linux-kernel-owner+w=401wt.eu-S1757193AbZJLPde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193AbZJLPde (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 11:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756245AbZJLPde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 11:33:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53701 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154AbZJLPdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 11:33:33 -0400
Date: Mon, 12 Oct 2009 08:30:13 -0700
From: Greg KH <gregkh@suse.de>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Hank Janssen <hjanssen@microsoft.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Tom Hanrahan <hanrahat@microsoft.com>,
       Hashir Abdi <habdi@microsoft.com>
Subject: Re: [patch] Staging: hv: Fix vmbus load hang caused by wrong data
 packing
Message-ID: <20091012153013.GA2062@suse.de>
References: <1FB5E1D5CA062146B38059374562DF7212DEE3EC@TK5EX14MBXC130.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1FB5E1D5CA062146B38059374562DF7212DEE3EC@TK5EX14MBXC130.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 10, 2009 at 11:16:00PM +0000, Haiyang Zhang wrote:
> From: Haiyang Zhang <haiyangz@microsoft.com>
> 
> Fix vmbus load hang caused by wrong data packing.
> 
> Cc: Hank Janssen <hjanssen@microsoft.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> 
> ---
> diff --git a/drivers/staging/hv/ChannelMgmt.h b/drivers/staging/hv/ChannelMgmt.h
> index a839d8f..3f18584 100644
> --- a/drivers/staging/hv/ChannelMgmt.h
> +++ b/drivers/staging/hv/ChannelMgmt.h
> @@ -30,6 +30,8 @@
>  #include "VmbusChannelInterface.h"
>  #include "VmbusPacketFormat.h"
>  
> +#pragma pack(push,1)
> +
>  /* Version 1 messages */
>  enum vmbus_channel_message_type {
>  	ChannelMessageInvalid			=  0,
> @@ -54,24 +56,24 @@ enum vmbus_channel_message_type {
>  	ChannelMessageViewRangeRemove		= 18,
>  #endif
>  	ChannelMessageCount
> -} __attribute__((packed));

Why the change here?  Isn't this doing the same thing?

And I'm guessing that not all of these structures are needing to be
packed, right?  Are they all shared across the HV boundry?

And is this fixing the problem that Hank and users have reported with
the current code?  Does this need to get into the 2.6.32 release?

thanks,

greg k-h
