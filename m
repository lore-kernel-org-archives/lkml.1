Return-Path: <linux-kernel-owner+w=401wt.eu-S1754861AbZKMHDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbZKMHDy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 02:03:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754612AbZKMHDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 02:03:50 -0500
Received: from mail-qy0-f174.google.com ([209.85.221.174]:55796 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191AbZKMHDt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 02:03:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Ug8uqnSeojVcy5azIXnnV0/SJwHTdJbMTRKw76OFwLMEGaQYAoF64PbLOsvqFVHnmu
         w8cBivfkvpsdjFhKUajTrp+fuITdQrrlH6Fl6g9ZKZfltpiq6YoiJzVMAAo4t0wZKuD3
         L8NDOcCnx49JmeDAgYv+ZTDEExC/9CqG+u8j4=
MIME-Version: 1.0
In-Reply-To: <4AFAE0DA.6040300@gmail.com>
References: <4AFAE0DA.6040300@gmail.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Fri, 13 Nov 2009 15:03:35 +0800
Message-ID: <f17812d70911122303x53892464le04883069ad99e64@mail.gmail.com>
Subject: Re: [PATCH] pxa: make index mfp unsigned in mfp_read() and write()
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 12, 2009 at 12:05 AM, Roel Kluin <roel.kluin@gmail.com> wrote:
> When signed, it is possible in theory to pass a negative mfp,
> and read/write outside the array bounds.
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  arch/arm/plat-pxa/include/plat/mfp.h |    4 ++--
>  arch/arm/plat-pxa/mfp.c              |    4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> I did not observe the passing of a negative mfp anywhere so this
> can be considered as a cleanup. Alternatively I could introduce
> a `mfp < 0' check in mfp_{read,write} instead if desired.
>

I'd prefer to have a check in mfp_{read,write} instead.
