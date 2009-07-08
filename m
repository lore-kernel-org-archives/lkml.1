Return-Path: <linux-kernel-owner+w=401wt.eu-S1758852AbZGHATh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758852AbZGHATh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 20:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757239AbZGHATa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 20:19:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:47788 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756094AbZGHATa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 20:19:30 -0400
Message-ID: <4A53E602.6030505@kernel.org>
Date: Wed, 08 Jul 2009 09:19:14 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Figo.zhang" <figo1802@gmail.com>
CC: Andrew Morton <akpm@osdl.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vmalloc.c: fix double error checking
References: <1246983201.2597.13.camel@myhost>
In-Reply-To: <1246983201.2597.13.camel@myhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 08 Jul 2009 00:19:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Figo.zhang wrote:
> it is no need for double error checking.
> 
> Signed-off-by: Figo.zhang <figo1802@gmail.com>
> -		err = vmap_pud_range(pgd, addr, next, prot, pages, &nr);
> -		if (err)
> -			break;
> +		if (vmap_pud_range(pgd, addr, next, prot, pages, &nr))
> +			return -ENOMEM;

Wouldn't it be better to keep the error return value?

Thanks.

--
tejun
