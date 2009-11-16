Return-Path: <linux-kernel-owner+w=401wt.eu-S1755163AbZKPXqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbZKPXqY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 18:46:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754474AbZKPXqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 18:46:23 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:14423 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755054AbZKPXqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 18:46:21 -0500
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtEEAAZzAUurR7H+/2dsb2JhbACcdKM0iRsIjhOCSwiBaQSBbYZR
X-IronPort-AV: E=Sophos;i="4.44,754,1249257600"; 
   d="scan'208";a="434000950"
User-Agent: Microsoft-Entourage/12.23.0.091001
Date: Mon, 16 Nov 2009 15:46:25 -0800
Subject: Re: [PATCH 1/4] drivers/net/enic: decrement sizeof size in strncmp
From: Scott Feldman <scofeldm@cisco.com>
To: Julia Lawall <julia@diku.dk>, Joe Eykholt <jeykholt@cisco.com>,
       <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <kernel-janitors@vger.kernel.org>
Message-ID: <C7272451.17157%scofeldm@cisco.com>
Thread-Topic: [PATCH 1/4] drivers/net/enic: decrement sizeof size in strncmp
Thread-Index: AcpnFwIQ3D8ZeAtXM0+26gJy7CZnqA==
In-Reply-To: <Pine.LNX.4.64.0911120848100.16627@ask.diku.dk>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
X-OriginalArrivalTime: 16 Nov 2009 23:46:27.0517 (UTC) FILETIME=[03902ED0:01CA6717]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Julia/Jorg.  We'll pick up change in next enic patch series.

-scott


On 11/11/09 11:48 PM, "Julia Lawall" <julia@diku.dk> wrote:

> From: Julia Lawall <julia@diku.dk>
> 
> As observed by Joe Perches, sizeof of a constant string includes the
> trailing 0.  If what is wanted is to check the initial characters of
> another string, this trailing 0 should not be taken into account.  If an
> exact match is wanted, strcmp should be used instead.
> 
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression foo;
> constant char *abc;
> @@
> 
> strncmp(foo, abc,
> - sizeof(abc)
> + sizeof(abc)-1
>  )
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  drivers/net/enic/vnic_dev.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff -u -p a/drivers/net/enic/vnic_dev.c b/drivers/net/enic/vnic_dev.c
> --- a/drivers/net/enic/vnic_dev.c
> +++ b/drivers/net/enic/vnic_dev.c
> @@ -358,9 +358,9 @@ int vnic_dev_hw_version(struct vnic_dev
> if (err)
> return err;
>  
> - if (strncmp(fw_info->hw_version, "A1", sizeof("A1")) == 0)
> + if (strncmp(fw_info->hw_version, "A1", sizeof("A1") - 1) == 0)
> *hw_ver = VNIC_DEV_HW_VER_A1;
> - else if (strncmp(fw_info->hw_version, "A2", sizeof("A2")) == 0)
> + else if (strncmp(fw_info->hw_version, "A2", sizeof("A2") - 1) == 0)
> *hw_ver = VNIC_DEV_HW_VER_A2;
> else
> *hw_ver = VNIC_DEV_HW_VER_UNKNOWN;

