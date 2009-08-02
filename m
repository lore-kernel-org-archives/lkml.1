Return-Path: <linux-kernel-owner+w=401wt.eu-S1752554AbZHBNv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554AbZHBNv3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 09:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbZHBNv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 09:51:28 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:48983 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbZHBNv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 09:51:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=k5/JhGdVmpe1Ihqs9yKP3qb08R/JrC1ce/seEh/uM/X2wdjWaHmGABfe38yIgDjDOm
         mSGZkYxlHQlBWJ0QnkFwseWAdE7B7WX3HX3NM9zEwDU6FsN65Xagl6KkRQi1aozDUUtJ
         DsZ2zk3PuPp9NVEmmdsb4aZWf4pMbu/vVMvKI=
Date: Sun, 2 Aug 2009 15:51:22 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Julia Lawall <julia@diku.dk>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 15/15] drivers/ide/ide-cd.c: Use DIV_ROUND_CLOSEST
Message-ID: <20090802135122.GA15279@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	Julia Lawall <julia@diku.dk>, linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.64.0908021049350.15557@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0908021049350.15557@ask.diku.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 02, 2009 at 10:49:54AM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> The kernel.h macro DIV_ROUND_CLOSEST performs the computation (x + d/2)/d
> but is perhaps more readable.
> 
> The semantic patch that makes this change is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @haskernel@
> @@
> 
> #include <linux/kernel.h>
> 
> @depends on haskernel@
> expression x,__divisor;
> @@
> 
> - (((x) + ((__divisor) / 2)) / (__divisor))
> + DIV_ROUND_CLOSEST(x,__divisor)
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Acked-by: Borislav Petkov <petkovbb@gmail.com>

-- 
Regards/Gruss,
    Boris.
