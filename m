Return-Path: <linux-kernel-owner+w=401wt.eu-S1751997AbZJWLqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997AbZJWLqK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 07:46:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbZJWLqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 07:46:09 -0400
Received: from mail-yx0-f187.google.com ([209.85.210.187]:41791 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbZJWLqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 07:46:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=X7k/uxFdD3Kn6Ql6BT5q5FCbmJ71wxHkT/klZ+POhYhiX92KMH5geIzaaILTkmX4X6
         +pCj8JLVuS4o0dj9vBhtTxt51ZSgDSmWZ1Idf2kkqi1uX616maX1gNsidp9q6YUF0+Tn
         +pwJdwYw2liNWb9Gz5BqMOdXEfK48SXPBNtBA=
Message-ID: <4AE19780.3020507@gmail.com>
Date: Fri, 23 Oct 2009 07:46:08 -0400
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: fangxiaozhi 00110321 <huananhu@huawei.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, zihan@huawei.com,
       greg@kroah.com, haegar@sdinet.de
Subject: Re: PATCH 23/10]Optimize the upload speed for PPP connection.
References: <fae097f21b27.1b27fae097f2@huawei.com>
In-Reply-To: <fae097f21b27.1b27fae097f2@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fangxiaozhi 00110321 wrote:
> From: fangxiaozhi <huananhu@huawei.com>
> 1. This patch is based on the kernel of 2.6.32-rc4 
> 2. In this patch, we enlarge the out buffer size to optimize the upload speed for the ppp connection. Then it can support the upload of HSUPA data cards.
> Signed-off-by: fangxiaozhi <huananhu@huawei.com>
> -----------------------------------------------------------------------------------------
> --- a/drivers/net/ppp_async.c	2009-10-12 05:43:56.000000000 +0800
> +++ b/drivers/net/ppp_async.c	2009-10-15 16:29:56.000000000 +0800
> @@ -36,7 +36,7 @@
>  
>  #define PPP_VERSION	"2.4.2"
>  
> -#define OBUFSIZE	256
> +#define OBUFSIZE	2048
>  
>  /* Structure for storing local state. */
>  struct asyncppp {
> 
Concur.  I'd go further than that, my code usually made room for at least
a full MTU (MRU) with HDLC escaping.  To minimize context switches, that
should be 3014 ((1500 MRU + 2 FCS + 4 header) * 2 escapes + 2 flags).

Even in the old days, when memory was tight, context switches and interrupt
time were more expensive, too.  PPP is supposed to scale to OC-192.
