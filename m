Return-Path: <linux-kernel-owner+w=401wt.eu-S1751833AbZIOFDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833AbZIOFDq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 01:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751635AbZIOFDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 01:03:42 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:53907 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559AbZIOFDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 01:03:41 -0400
Date: Tue, 15 Sep 2009 07:03:42 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: ralf@linux-mips.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/8] arch/mips/txx9: introduce missing kfree, iounmap
In-Reply-To: <Pine.LNX.4.64.0909132113520.31000@ask.diku.dk>
Message-ID: <Pine.LNX.4.64.0909150701170.11392@ask.diku.dk>
References: <Pine.LNX.4.64.0909111820370.10552@pc-004.diku.dk>
 <20090913.232548.253168283.anemo@mba.ocn.ne.jp> <Pine.LNX.4.64.0909131708190.25903@ask.diku.dk>
 <20090914.003321.160496287.anemo@mba.ocn.ne.jp> <Pine.LNX.4.64.0909132113520.31000@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +out_pdev:
> +	platform_device_put(pdev);
> +out_gpio:
> +	gpio_remove(&iocled->chip);

I just noticed that the prototype of gpio_remove has __must_check
I don't think there is anything to check here; since the thing is not 
fully initialized here, it is unlikely to be busy.  Should there be (void) 
in front of it?

julia
