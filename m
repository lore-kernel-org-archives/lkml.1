Return-Path: <linux-kernel-owner+w=401wt.eu-S1759430AbXIZTnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759430AbXIZTnX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 15:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757599AbXIZTnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 15:43:12 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:1222 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757498AbXIZTnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 15:43:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=aKan1p6XVQci+NpFp/2LEzWOrVwgRboFUqdZMqkDqQKvOyJQM4ovSPRXLM0YnxWnb66mx+oHATxMI9N40quwgpc5B/puCnclrA/Gqu0VokHnAxAJ6jO7FzlYV+DlywqgmExs1D5zltEzRlcxfNKhAILRQwMPDn+H/kiclP1TqjI=
Message-ID: <2c0942db0709261243h1267140br70796c7fcfb165e3@mail.gmail.com>
Date: Wed, 26 Sep 2007 12:43:08 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Brett Warden" <brett.warden@gmail.com>
Subject: Re: [PATCH] bw-qcam: use data_reverse instead of manually poking the control register
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
In-Reply-To: <a372714f0709261212hec0c61ofc5dd6d127352402@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a372714f0709261212hec0c61ofc5dd6d127352402@mail.gmail.com>
X-Google-Sender-Auth: c4d5ec87a24d26ed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/26/07, Brett Warden <brett.warden@gmail.com> wrote:
> Appeases the warning "parport0 (bw-qcam): use data_reverse for this!"
>
> Signed-off-by: Brett T. Warden <brett.warden@gmail.com>
>
> ---
>
> It seems to work fine with my Quickcam under 2.6.22.

> @@ -369,7 +374,11 @@ static void qc_reset(struct qcam_device *q)
>                         break;
>
>                 case QC_ANY:
> -                       write_lpcontrol(q, 0x20);
> +                       /*
> +                        * Replaced with reverse_port
> +                        * write_lpcontrol(q, 0x20);
> +                        */
> +                       reverse_port(q);
>                         write_lpdata(q, 0x75);
>
>                         if (read_lpdata(q) != 0x75) {

Just as an aside, if you've tested this and it works, then there's no
point to keep the write_lpcontrol even as a comment. Kill those four
lines, and if someone's interested in what happened they'll just look
at the file history.

Ray
