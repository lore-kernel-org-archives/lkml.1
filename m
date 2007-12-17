Return-Path: <linux-kernel-owner+w=401wt.eu-S1758023AbXLQSFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758023AbXLQSFq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 13:05:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754310AbXLQSFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 13:05:38 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:35968 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474AbXLQSFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 13:05:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=VCy5Hfzu+LB1dVem+UrSDzFwnQpcMjSxB3DO11CBAaB/yGPsrIsmGl0h2CpmjZlDXt/I98oethiPi9ARuSviXmsqWYREHg7kDru+cXm8wAB7hOIfADjMUW+CynOlMTWRTQhXc2R+99OesHeDyWngfLqEpkwkwOzAdZ55V7aKIV4=
Message-ID: <2c0942db0712171005w65bbb512p71a4f9b1fc65c6a7@mail.gmail.com>
Date: Mon, 17 Dec 2007 10:05:35 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Eric Dumazet" <dada1@cosmosbay.com>
Subject: Re: Signed divides vs shifts (Re: [Security] /dev/urandom uses uninit bytes, leaks user data)
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Herbert Xu" <herbert@gondor.apana.org.au>,
       "John Reiser" <jreiser@bitwagon.com>,
       "Andrew Morton" <akpm@linux-foundation.org>, security@kernel.org,
       tytso@mit.edu,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       mpm@selenic.com, linux-sparse@vger.kernel.org
In-Reply-To: <20071217185557.0b501e23.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <E1J3RD5-0006yU-00@gondolin.me.apana.org.au>
	 <alpine.LFD.0.9999.0712170856050.21557@woody.linux-foundation.org>
	 <20071217185557.0b501e23.dada1@cosmosbay.com>
X-Google-Sender-Auth: 2e0aa21163f45541
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 17, 2007 9:55 AM, Eric Dumazet <dada1@cosmosbay.com> wrote:
> -               mid = (last - first) / 2 + first;
> +       while (low <= high) {
> +               mid = (low + high) / 2;

I think you just introduced a bug. Think about what happens if
low=high=MAX_LONG/2 + 1.
