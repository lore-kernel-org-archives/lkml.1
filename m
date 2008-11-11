Return-Path: <linux-kernel-owner+w=401wt.eu-S1752766AbYKKXR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbYKKXR2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 18:17:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbYKKXRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 18:17:19 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:57977 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbYKKXRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 18:17:18 -0500
Date: Tue, 11 Nov 2008 15:05:02 -0800 (PST)
From: Trent Piepho <tpiepho@freescale.com>
X-X-Sender: xyzzy@t2.domain.actdsltmp
To: "Darrick J. Wong" <djwong@us.ibm.com>
cc: Jean Delvare <khali@linux-fr.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [PATCH 1/2] Create a DIV_ROUND_CLOSEST macro to do
 division with	rounding
In-Reply-To: <20081111010132.1730.76566.stgit@elm3a70.beaverton.ibm.com>
Message-ID: <Pine.LNX.4.64.0811111459300.24267@t2.domain.actdsltmp>
References: <20081111010132.1730.76566.stgit@elm3a70.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2008, Darrick J. Wong wrote:
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index fba141d..fb02266 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -48,6 +48,12 @@ extern const char linux_proc_banner[];
> #define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
> #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
> #define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
> +#define DIV_ROUND_CLOSEST(x, divisor)(			\
> +{							\
> +	typeof(divisor) __divisor = divisor;		\
> +	(((x) + ((__divisor) / 2)) / (__divisor));	\
> +}							\
> +)

Maybe you can do away with the statement-expression extension?  I've seen
cases where it cases gcc to generate worse code.  It seems like it
shouldn't, but it does.  I know DIV_ROUND_CLOSEST (maybe DIV_ROUND_NEAR?)
uses divisor twice, but all the also divide macros do that too, so why does
this one need to be different?

Note that if divisor is a signed variable, divisor/2 generates worse code
than divisor>>1.
