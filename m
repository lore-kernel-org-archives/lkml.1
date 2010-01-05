Return-Path: <linux-kernel-owner+w=401wt.eu-S1755511Ab0AEU6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab0AEU6Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 15:58:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755427Ab0AEU6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 15:58:25 -0500
Received: from cpsmtpm-eml103.kpnxchange.com ([195.121.3.7]:53329 "EHLO
	CPSMTPM-EML103.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755365Ab0AEU6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 15:58:24 -0500
Message-ID: <4B43A7EF.8040702@gmail.com>
Date: Tue, 05 Jan 2010 21:58:23 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091210 Lightning/1.0pre Shredder/3.0
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org,
       Ivo van Doorn <IvDoorn@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [08/10] rt2x00: Disable powersaving for rt61pci and rt2800pci.
References: <20100105194915.239350321@mini.kroah.org>
In-Reply-To: <20100105194915.239350321@mini.kroah.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Jan 2010 20:58:23.0766 (UTC) FILETIME=[D1D56360:01CA8E49]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/10 20:47, Greg KH wrote:
> 2.6.27-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> From: Gertjan van Wingerde <gwingerde@gmail.com>
> 
> commit 93b6bd26b74efe46b4579592560f9f1cb7b61994 upstream.
> 
> We've had many reports of rt61pci failures with powersaving enabled.
> Therefore, as a stop-gap measure, disable powersaving of the rt61pci
> until we have found a proper solution.
> Also disable powersaving on rt2800pci as it most probably will show
> the same problem.
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
> Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  drivers/net/wireless/rt2x00/rt61pci.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> --- a/drivers/net/wireless/rt2x00/rt61pci.c
> +++ b/drivers/net/wireless/rt2x00/rt61pci.c
> @@ -2281,6 +2281,11 @@ static void rt61pci_probe_hw_mode(struct
>  	unsigned int i;
>  
>  	/*
> +	 * Disable powersaving as default.
> +	 */
> +	rt2x00dev->hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
> +
> +	/*
>  	 * Initialize all hw fields.
>  	 */
>  	rt2x00dev->hw->flags =
> 
> 
> 

This one isn't applicable for .27. Powersaving wasn't implemented on .27 yet, so
this patch is unnecessary, and won't compile on .27.

---
Gertjan.
