Return-Path: <linux-kernel-owner+w=401wt.eu-S1755900AbXJXCaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900AbXJXCaI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 22:30:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753400AbXJXC34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 22:29:56 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57417 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753203AbXJXC3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 22:29:55 -0400
Date: Tue, 23 Oct 2007 19:29:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gilles Gigan <gilles.gigan@gmail.com>
Cc: wim@iguana.be, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog: add Nano 7240 driver
Message-Id: <20071023192948.1fe5dd8d.akpm@linux-foundation.org>
In-Reply-To: <20071024121159.03d209ec.gilles.gigan@gmail.com>
References: <20071024121159.03d209ec.gilles.gigan@gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2007 12:11:59 +1000 Gilles Gigan <gilles.gigan@gmail.com> wrote:

> +	case WDIOC_SETOPTIONS:{
> +			int retval = -EINVAL;
> +
> +			if (arg & WDIOS_DISABLECARD) {
> +				wdt_disable();
> +				retval = 0;
> +			}
> +
> +			if (arg & WDIOS_ENABLECARD) {
> +				wdt_enable();
> +				retval = 0;
> +			}
> +
> +			return retval;

hrm.  So if userspace does ioctl(..., WDIOS_DISABLECARD|WDIOS_ENABLECARD,
that happens to be equivalent to WDIOS_ENABLECARD?

Do all watchdog drivers do it exactly the same way, or are we offering
inconsistent interfaces between different drivers?

An exceedingly minor point, but fun nonetheless.

(And hey, I had to say _something_)

(apart from directing your attention to scripts/checkpatch.pl)
