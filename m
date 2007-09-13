Return-Path: <linux-kernel-owner+w=401wt.eu-S1760486AbXIMPTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760486AbXIMPTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 11:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753093AbXIMPTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 11:19:09 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48366 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752945AbXIMPTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 11:19:08 -0400
Date: Thu, 13 Sep 2007 08:16:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       orgis@agnld.uni-potsdam.de, arekm@maven.pl, ed.lin@promise.com,
       Andrew Morton <akpm@linux-foundation.org>, James.Bottomley@SteelEye.com
Subject: Re: [PATCH] Fix race with shared tag queue maps
In-Reply-To: <20070913122652.GK25592@kernel.dk>
Message-ID: <alpine.LFD.0.999.0709130813220.16478@woody.linux-foundation.org>
References: <20070913122652.GK25592@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 13 Sep 2007, Jens Axboe wrote:
> +
> +	/*
> +	 * Ensure ordering with tag section
> +	 */
> +	smp_mb__before_clear_bit();
> +
> +	if (unlikely(!test_and_clear_bit(tag, bqt->tag_map))) {

You don't need the "smp_mb__before_clear_bit()" there.

The regular "clear_bit()" needs it, but the "test_and_xxx()" versions are 
architecturally defined to be memory barriers, exactly because they are 
regularly used for locking.

This is even documented - see Documentation/atomic_ops.txt.

		Linus
