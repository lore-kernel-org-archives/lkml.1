Return-Path: <linux-kernel-owner+w=401wt.eu-S1755994AbZBFVPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994AbZBFVPY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 16:15:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753593AbZBFVPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 16:15:06 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:50840 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308AbZBFVPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 16:15:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=MLGEA/A27yvhGzJ79ZhyCNe7FayAS4LoHKjpPHuZF17ZZxkUyd4D7PB21MV222tRXP
         j5f74OtSoDbuTUUZgN8MP7RbDfz11c77scTQo/lhn0rf5k2pqQLXIZTUKa7kgcTx0U4V
         5CZEhnLD8OQ+kJm1cY+g4pyTwVexx3QJ15YHo=
MIME-Version: 1.0
In-Reply-To: <1233936169-5243-1-git-send-email-anemo@mba.ocn.ne.jp>
References: <1233936169-5243-1-git-send-email-anemo@mba.ocn.ne.jp>
Date: Fri, 6 Feb 2009 14:15:02 -0700
X-Google-Sender-Auth: 415e84c1775717ae
Message-ID: <e9c3a7c20902061315n7184c55ck7fcaa2c519a035d4@mail.gmail.com>
Subject: Re: [PATCH] net_dma: call dmaengine_get only if NET_DMA enabled
From: Dan Williams <dan.j.williams@intel.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ please cc netdev on net_dma patches ]

On Fri, Feb 6, 2009 at 9:02 AM, Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:
> The commit 649274d993212e7c23c0cb734572c2311c200872 ("net_dma:
> acquire/release dma channels on ifup/ifdown") added unconditional call
> of dmaengine_get() to net_dma.  The API should be called only if
> NET_DMA was enabled.
>
> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Acked-by: Dan Williams <dan.j.williams@intel.com>

I was looking to avoid ifdefs in this path by making
dmaengine_{get,put} a nop in the DMAENGINE=n case.  However, the
current code with DMAENGINE=y NET_DMA=n will pin channels even though
the network stack is not using them.

Thanks,
Dan
