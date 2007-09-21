Return-Path: <linux-kernel-owner+w=401wt.eu-S1753462AbXIUBgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbXIUBgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 21:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbXIUBfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 21:35:51 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:2960 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778AbXIUBfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 21:35:50 -0400
X-Server-Uuid: 6B5CFB92-F616-4477-B110-55F967A57302
Subject: Re: bnx2 dirver's firmware images
From: "Michael Chan" <mchan@broadcom.com>
To: "Denys Vlasenko" <vda.linux@googlemail.com>
cc: "David Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       "netdev" <netdev@vger.kernel.org>
In-Reply-To: <200709201549.08165.vda.linux@googlemail.com>
References: <200709181823.26429.vda.linux@googlemail.com>
 <200709192129.23034.vda.linux@googlemail.com>
 <1190238233.9540.263.camel@dell>
 <200709201549.08165.vda.linux@googlemail.com>
Date: Thu, 20 Sep 2007 19:12:33 -0700
Message-ID: <1190340753.6934.25.camel@dell>
MIME-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-8)
X-WSS-ID: 6AEDC06D3K44133388-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-20 at 15:49 +0100, Denys Vlasenko wrote:
> 
> 
> Please test these two patches.
> I updated them according to your comments.
> 
> 

I've only tested patch #1.  It worked after some minor modifications
below.

> 
> 
> 
> 
> 
> plain text
> document
> attachment
> (linux-2.6.23-
> rc6.bnx2-1.patch)
> 
> 
> @@ -2767,89 +2769,44 @@ bnx2_set_rx_mode(struct net_device *dev)
>         spin_unlock_bh(&bp->phy_lock);
>  }
>  
> -#define FW_BUF_SIZE    0x8000
> -
> +/* To be moved to generic lib/ */
>  static int
> -bnx2_gunzip_init(struct bnx2 *bp)
> +bnx2_gunzip(void *gunzip_buf, unsigned sz, u8 *zbuf, int len, void **outbuf)

outbuf is no longer needed.

> +       rc = zlib_inflateInit2(strm, -MAX_WBITS);
> +       if (rc == Z_OK) {
> +               rc = zlib_inflate(strm, Z_FINISH);
> +               if (rc == Z_OK)

rc will always be Z_STREAM_END in this case since we provide a big
enough gunzip_buf for the whole blob.

