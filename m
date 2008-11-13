Return-Path: <linux-kernel-owner+w=401wt.eu-S1755527AbYKMVr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527AbYKMVr6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 16:47:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751819AbYKMVrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 16:47:49 -0500
Received: from mx2.redhat.com ([66.187.237.31]:54861 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557AbYKMVrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 16:47:49 -0500
Date: Thu, 13 Nov 2008 14:46:36 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Ingo van Lil <inguin@gmx.de>
Cc: linux-kernel@vger.kernel.org, zaitcev@redhat.com
Subject: Re: [PATCH] usbmon binary format reader loses synchronization
Message-Id: <20081113144636.f1ac7cc0.zaitcev@redhat.com>
In-Reply-To: <20081113125945.GA10450@zaphod.peppercon.de>
References: <20081113125945.GA10450@zaphod.peppercon.de>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2008 13:59:45 +0100, Ingo van Lil <inguin@gmx.de> wrote:

> +++ b/drivers/usb/mon/mon_bin.c	2008-11-13 11:44:03.000000000 +0100
> @@ -681,7 +681,7 @@
>  	}
>  
>  	if (rp->b_read >= sizeof(struct mon_bin_hdr)) {
> -		step_len = min(nbytes, (size_t)ep->len_cap);
> +		step_len = min(nbytes, sizeof(struct mon_bin_hdr) + (size_t)ep->len_cap - rp->b_read);
>  		offset = rp->b_out + PKT_SIZE;

I cannot tell right away if this is the best fix, but I'll look
into this. Thanks a lot!

-- Pete
