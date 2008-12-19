Return-Path: <linux-kernel-owner+w=401wt.eu-S1752558AbYLSUP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558AbYLSUP0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 15:15:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751118AbYLSUPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 15:15:14 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:37745 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbYLSUPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 15:15:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=MAA8EYrj7aNbPsSAdaX3RKY0/rU042XySokQpiEnqo7+B9Iy6kFpYECOtsfPDxRBLY
         WJq1rE4UqZMjKeCeRuhW5njNB2lFM/6lRhGoA9rxH8S3rUzXcRLWe0tITmKruOqpHYRt
         lefLq9wmVuyvCc40V0N8YaVcDC2qmltQrjXqk=
Message-ID: <84144f020812191215i432fd70fq3248d9feb981d4cf@mail.gmail.com>
Date: Fri, 19 Dec 2008 22:15:11 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Catalin Marinas" <catalin.marinas@arm.com>
Subject: Re: [PATCH 11/14] kmemleak: Remove some of the kmemleak false positives
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081219181357.7778.9552.stgit@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081219181255.7778.52219.stgit@pc1117.cambridge.arm.com>
	 <20081219181357.7778.9552.stgit@pc1117.cambridge.arm.com>
X-Google-Sender-Auth: ccf50d2d08fac6c3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2008 at 8:13 PM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> There are allocations for which the main pointer cannot be found but
> they are not memory leaks. This patch fixes some of them. For more
> information on false positives, see Documentation/kmemleak.txt.
>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

> @@ -2882,6 +2883,12 @@ static int __init con_init(void)
>         */
>        for (currcons = 0; currcons < MIN_NR_CONSOLES; currcons++) {
>                vc_cons[currcons].d = vc = alloc_bootmem(sizeof(struct vc_data));
> +               /*
> +                * Kmemleak does not track the memory allocated via
> +                * alloc_bootmem() but this block contains pointers to
> +                * other blocks allocated via kmalloc.
> +                */
> +               kmemleak_alloc(vc, sizeof(struct vc_data), 1, GFP_ATOMIC);
>                INIT_WORK(&vc_cons[currcons].SAK_work, vc_SAK);
>                visual_init(vc, currcons, 1);
>                vc->vc_screenbuf = (unsigned short *)alloc_bootmem(vc->vc_screenbuf_size);

I think there was some discussion about adding hooks to the bootmem
allocator. Didn't that work out?
