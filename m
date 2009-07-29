Return-Path: <linux-kernel-owner+w=401wt.eu-S1755383AbZG2NNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbZG2NNQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 09:13:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755286AbZG2NNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 09:13:15 -0400
Received: from cantor.suse.de ([195.135.220.2]:41299 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754979AbZG2NNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 09:13:14 -0400
Date: Wed, 29 Jul 2009 06:02:33 -0700
From: Greg KH <gregkh@suse.de>
To: Nicolas Palix <npalix@diku.dk>
Cc: hjanssen@microsoft.com, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] Staging: hv: Fix warning by casting a (const void
 *) to (void *)
Message-ID: <20090729130233.GA27054@suse.de>
References: <200907291410.29355.npalix@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907291410.29355.npalix@diku.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 02:10:28PM +0200, Nicolas Palix wrote:
> 
> Fix compilation warning by casting the const void *Buffer
> variable into a void *.
> 
> Signed-off-by: Nicolas Palix <npalix@diku.dk>
> ---
>  drivers/staging/hv/Channel.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/hv/Channel.c b/drivers/staging/hv/Channel.c
> index 68f3442..854fa30 100644
> --- a/drivers/staging/hv/Channel.c
> +++ b/drivers/staging/hv/Channel.c
> @@ -787,7 +787,7 @@ VmbusChannelSendPacket(
>  	bufferList[0].Data = &desc;
>  	bufferList[0].Length = sizeof(VMPACKET_DESCRIPTOR);
>  
> -	bufferList[1].Data = Buffer;
> +	bufferList[1].Data = (void *)Buffer;

Yeah, I thought about doing this as well, but it's wrong.  If this
buffer really isn't being modified, then the Data pointer needs to be
const.

Or, if the Data pointer really is going to not be const, then the
function parameters need to be changed, but that means lots of code
needs to be changed.

Hank, what do you think is the correct thing to do here?

thanks,

greg k-h
