Return-Path: <linux-kernel-owner+w=401wt.eu-S1755430AbYLEDF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbYLEDF0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 22:05:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbYLEDFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 22:05:09 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:2107 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbYLEDFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 22:05:08 -0500
Message-ID: <ac3eb2510812041905j639ea7d4ybe8e83b0d7c5965e@mail.gmail.com>
Date: Fri, 5 Dec 2008 04:05:06 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Matt Mackall" <mpm@selenic.com>
Subject: Re: [PATCH] Use vprintk rather that vsnprintf where possible
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <1228423309.3255.109.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1228423309.3255.109.camel@calx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 4, 2008 at 21:41, Matt Mackall <mpm@selenic.com> wrote:
> This does away with lots of large static and on-stack buffers as well
> as a few associated locks.

> -               len = snprintf(s, 256, KERN_DEBUG "%s: ", prefix);
> -
>                va_start(args, fmt);
> -               len += vsnprintf(&s[len], (256 - len), fmt, args);
> +               printk(KERN_DEBUG "%s: ", prefix);
> +               vprintk(fmt, args);

If we convert to two printk calls for a single line, does that not
possibly get mixed up with printks from other locations and lead to
hardly readable log output?

Thanks,
Kay
