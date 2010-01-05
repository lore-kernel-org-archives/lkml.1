Return-Path: <linux-kernel-owner+w=401wt.eu-S932157Ab0AEUyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157Ab0AEUyY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 15:54:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755484Ab0AEUyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 15:54:23 -0500
Received: from cpsmtpm-eml103.kpnxchange.com ([195.121.3.7]:51166 "EHLO
	CPSMTPM-EML103.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755474Ab0AEUyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 15:54:22 -0500
Message-ID: <4B43A6FD.3050407@gmail.com>
Date: Tue, 05 Jan 2010 21:54:21 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091210 Lightning/1.0pre Shredder/3.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 099/101] rt2x00: Disable powersaving for rt61pci and rt2800pci.
References: <20100105192014.GA23628@kroah.com> <1262719290-310-1-git-send-email-gregkh@suse.de> <1262719290-310-2-git-send-email-gregkh@suse.de>
In-Reply-To: <1262719290-310-2-git-send-email-gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Jan 2010 20:54:21.0724 (UTC) FILETIME=[4190B5C0:01CA8E49]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/10 20:21, Greg Kroah-Hartman wrote:
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
> ---
>  drivers/net/wireless/rt2x00/rt61pci.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
> index b20e3ea..1894e7e 100644
> --- a/drivers/net/wireless/rt2x00/rt61pci.c
> +++ b/drivers/net/wireless/rt2x00/rt61pci.c
> @@ -2538,6 +2538,11 @@ static int rt61pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
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

This looks like the wrong version of the patch. John Linville sent you an updated one
that is applicable for .32 (and .31).

This patch won't compile on .32 and before.

---
Gertjan.
