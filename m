Return-Path: <linux-kernel-owner+w=401wt.eu-S1753678AbZKTOYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678AbZKTOYR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 09:24:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753347AbZKTOYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 09:24:16 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:37847 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbZKTOYP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 09:24:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=GPVEQ+WSeKQdjD4ObqL8jkuoH8eNrxi1zT3mfoqfd2xygxFYgDrpmlw1FLnJNyottD
         WxgwKykD1CaBONcceTINB5wmVWRt2Eww7I1T8otGYMt3TrCEK6XVbh4VnhGgIbm4Sv51
         X0enQ+CgNOA9l0sEyflJtDTkbwzwTfVPySUnM=
MIME-Version: 1.0
In-Reply-To: <1258725747.3562.5.camel@ht.satnam>
References: <1258725747.3562.5.camel@ht.satnam>
Date: Fri, 20 Nov 2009 06:24:21 -0800
X-Google-Sender-Auth: 9a77a140e1dd05ad
Message-ID: <9929d2390911200624mf352c28u55a8b2aee8b52fa3@mail.gmail.com>
Subject: Re: [PATCH] ixgbe: move tc variable to CONFIG_IXGBE_DCB
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: David Miller <davem@davemloft.net>, Yi Zou <yi.zou@intel.com>,
       Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
       netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 06:02, Jaswinder Singh Rajput
<jaswinder@kernel.org> wrote:
>
> tc is required by CONFIG_IXGBE_DCB.
> This also fixes compilation warning:
>
>  drivers/net/ixgbe/ixgbe_main.c: In function ‘ixgbe_tx_is_paused’:
>  drivers/net/ixgbe/ixgbe_main.c:245: warning: unused variable ‘tc’
>
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  drivers/net/ixgbe/ixgbe_main.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/ixgbe/ixgbe_main.c b/drivers/net/ixgbe/ixgbe_main.c
> index ebcec30..61a02ce 100644
> --- a/drivers/net/ixgbe/ixgbe_main.c
> +++ b/drivers/net/ixgbe/ixgbe_main.c
> @@ -242,11 +242,11 @@ static void ixgbe_unmap_and_free_tx_resource(struct ixgbe_adapter *adapter,
>  static inline bool ixgbe_tx_is_paused(struct ixgbe_adapter *adapter,
>                                       struct ixgbe_ring *tx_ring)
>  {
> -       int tc;
>        u32 txoff = IXGBE_TFCS_TXOFF;
>
>  #ifdef CONFIG_IXGBE_DCB
>        if (adapter->flags & IXGBE_FLAG_DCB_ENABLED) {
> +               int tc;
>                int reg_idx = tx_ring->reg_idx;
>                int dcb_i = adapter->ring_feature[RING_F_DCB].indices;
>
> --
> 1.6.5.3
>
>
> --

I just submitted a patch to fix this.  So NAK.

-- 
Cheers,
Jeff
