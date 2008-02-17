Return-Path: <linux-kernel-owner+w=401wt.eu-S1757616AbYBQRLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616AbYBQRLk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 12:11:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754255AbYBQRKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 12:10:40 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:20534 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593AbYBQRKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 12:10:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=fpxjfCx6OrL571Y6DJd+1KMA36k+z4+FV5bV4OOP+uvt7d9sW1bQBqZrivs0KuDmtNONLZHUQqJgIEazy/jnxPCcSZq/BjhkV/BNORH+FKevx9hozBvTTD2jv+nkj2kTS2voqlM/kY5nFDMwiQCNfW29Iw8joIcyQ4rkSXhqBa4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH 1/4] : More use DIV_ROUND_UP
Date: Sun, 17 Feb 2008 18:17:47 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.58.0802161548370.1185@pc-041.diku.dk>
In-Reply-To: <Pine.LNX.4.58.0802161548370.1185@pc-041.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802171817.48155.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 16 February 2008, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> The kernel.h macro DIV_ROUND_UP performs the computation (((n) + (d) - 1) /
> (d)) but is perhaps more readable.
> 
> An extract of the semantic patch that makes this change is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @haskernel@
> @@
> 
> #include <linux/kernel.h>
> 
> @depends on haskernel@
> expression n,d;
> @@
> 
> (
> - (n + d - 1) / d
> + DIV_ROUND_UP(n,d)
> |
> - (n + (d - 1)) / d
> + DIV_ROUND_UP(n,d)
> )
> 
> @depends on haskernel@
> expression n,d;
> @@
> 
> - DIV_ROUND_UP((n),d)
> + DIV_ROUND_UP(n,d)
> 
> @depends on haskernel@
> expression n,d;
> @@
> 
> - DIV_ROUND_UP(n,(d))
> + DIV_ROUND_UP(n,d)
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

applied, thanks
