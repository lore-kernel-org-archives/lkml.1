Return-Path: <linux-kernel-owner+w=401wt.eu-S1754736Ab0AIQz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab0AIQz7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 11:55:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754712Ab0AIQz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 11:55:58 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:63399 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711Ab0AIQz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 11:55:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=muR21XbzqkjKRo2Mfdkni15gA+1UlQ5e+QDGb2zPMBcfen3C+Ohn5QyLSJ+lfttiqf
         a8lGtqs6sLOzCE3gu6gBsW4b4A82+a+SLqDU9naa+vy0ruaSWe77tqlgGxXzxPL/rZq6
         4vpk2H9NvLkQ0EepEisnCvBw6mOimKCXSJIf0=
Date: Sun, 10 Jan 2010 00:57:43 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel/resource.c: fix memory leak
Message-ID: <20100109165743.GA9190@hack>
References: <1263048395-14873-1-git-send-email-a.beregalov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263048395-14873-1-git-send-email-a.beregalov@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 09, 2010 at 05:46:35PM +0300, Alexander Beregalov wrote:
>Free res before exit.
>Found by cppcheck.
>
>Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
>---
> kernel/resource.c |    3 ++-
> 1 files changed, 2 insertions(+), 1 deletions(-)
>
>diff --git a/kernel/resource.c b/kernel/resource.c
>index af96c1e..ae2e177 100644
>--- a/kernel/resource.c
>+++ b/kernel/resource.c
>@@ -545,11 +545,12 @@ static void __init __reserve_region_with_split(struct resource *root,
> 	res->flags = IORESOURCE_BUSY;
> 
> 	conflict = __request_resource(parent, res);
>+	kfree(res);
>+
> 	if (!conflict)
> 		return;
> 
> 	/* failed, split and try again */
>-	kfree(res);
> 
> 	/* conflict covered whole area */
> 	if (conflict->start <= start && conflict->end >= end)

NAK.

If I read it correctly, 'res' will be used if !conflict, we
should't kfree it.


-- 
Live like a child, think like the god.
 
