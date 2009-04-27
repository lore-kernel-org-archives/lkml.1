Return-Path: <linux-kernel-owner+w=401wt.eu-S1754677AbZD0LkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677AbZD0LkW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 07:40:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbZD0LkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 07:40:07 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:56609 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752625AbZD0LkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 07:40:06 -0400
Subject: Re: [PATCH] regulator core: fix double-free in
 regulator_register() error path
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Paul Walmsley <paul@pwsan.com>
Cc: broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, dbrownell@users.sourceforge.net
In-Reply-To: <alpine.DEB.2.00.0904250526210.28378@utopia.booyaka.com>
References: <alpine.DEB.2.00.0904250526210.28378@utopia.booyaka.com>
Content-Type: text/plain
Date: Mon, 27 Apr 2009 12:40:02 +0100
Message-Id: <1240832402.14165.4.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-04-25 at 05:28 -0600, Paul Walmsley wrote:
> During regulator registration, any error after device_register() will 
> cause a double-free on the struct regulator_dev 'rdev'.  The bug is in 
> drivers/regulator/core.c:regulator_register():
> 
> ...
> scrub:
> 	device_unregister(&rdev->dev);
> clean:
> 	kfree(rdev);                           <---
> 	rdev = ERR_PTR(ret);
> 	goto out;
> ...
> 
> device_unregister() calls regulator_dev_release() which frees rdev.  The 
> subsequent kfree corrupts memory and causes some OMAP3 systems to oops on 
> boot in regulator_get().
> 
> Applies against 2.6.30-rc3.
> 
> Signed-off-by: Paul Walmsley <paul@pwsan.com>
> ---
>  drivers/regulator/core.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 

Applied.

Thanks

Liam

