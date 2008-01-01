Return-Path: <linux-kernel-owner+w=401wt.eu-S1752633AbYAAGJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbYAAGJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 01:09:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164AbYAAGJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 01:09:10 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:5164 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbYAAGJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 01:09:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OBlNOkP08YipEFP1ye0hrdKVAdkY6tdIB4QiA5qeITJO4GfFX6zf4nBXoPSUQuB8UTGPEIlrMfcCXnMZ8wO+9YR8Lc2h0OsDuh9WTEglXIz5QI7BI/WT0Ph58rV1XDjIwI6s+NSb13YXPSFqgbn9/c/fsy/F2cvAxCGc4ovBGb4=
Message-ID: <b25c3fa70712312209q772db28l69ee22dcdafd2679@mail.gmail.com>
Date: Tue, 1 Jan 2008 15:09:08 +0900
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: "jacliburn@bellsouth.net" <jacliburn@bellsouth.net>
Subject: Re: [PATCH 25/26] atl1: add NAPI support
Cc: jeff@garzik.org, csnook@redhat.com, linux-kernel@vger.kernel.org,
       atl1-devel@lists.sourceforge.net
In-Reply-To: <1199152804-3889-26-git-send-email-jacliburn@bellsouth.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1199152804-3889-1-git-send-email-jacliburn@bellsouth.net>
	 <1199152804-3889-26-git-send-email-jacliburn@bellsouth.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/1/1, jacliburn@bellsouth.net <jacliburn@bellsouth.net>:
> From: Jay Cliburn <jacliburn@bellsouth.net>
>
> Add support for NAPI, styled after the e1000 NAPI implementation.  That we
> follow the e1000 for NAPI shouldn't come as much of a surprise, since the
> entire atl1 driver is based heavily upon it.
>
> Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
> ---
>  drivers/net/Kconfig     |   14 ++++
>  drivers/net/atlx/atl1.c |  151 +++++++++++++++++++++++++++++++++++++++++++++--
>  drivers/net/atlx/atl1.h |   20 ++++++
>  drivers/net/atlx/atlx.h |    7 ++-
>  4 files changed, 186 insertions(+), 6 deletions(-)
>
> +       if ((!tx_cleaned && (work_done == 0)) ||
> +               !netif_running(poll_dev)) {
> +quit_polling:
> +               netif_rx_complete(poll_dev, napi);
> +
> +               if (!test_bit(__ATL1_DOWN, &adapter->flags))
> +                       atlx_irq_enable(adapter);
> +       }

Hi Jay,
if buget == work_done is true, you should not call netif_rx_complete.
Searching recent netdev mailbox would be help.

Thanks.
Joonwoo
