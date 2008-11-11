Return-Path: <linux-kernel-owner+w=401wt.eu-S1755817AbYKKKFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817AbYKKKFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 05:05:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755149AbYKKKFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 05:05:12 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:23947 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142AbYKKKFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 05:05:11 -0500
Date: Tue, 11 Nov 2008 11:04:54 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 1/2] Create a DIV_ROUND_CLOSEST macro to do division
 with  rounding
Message-ID: <20081111110454.073a6d94@hyperion.delvare>
In-Reply-To: <20081111010132.1730.76566.stgit@elm3a70.beaverton.ibm.com>
References: <20081111010132.1730.76566.stgit@elm3a70.beaverton.ibm.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Darrick,

On Mon, 10 Nov 2008 17:01:32 -0800, Darrick J. Wong wrote:
> 
> Create a helper macro to divide two numbers and round the result to the
> nearest whole number.  This is a helper macro for hwmon drivers that
> want to convert incoming sysfs values per standard hwmon practice, though
> the macro itself can be used by anyone.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> 
>  include/linux/kernel.h |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index fba141d..fb02266 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -48,6 +48,12 @@ extern const char linux_proc_banner[];
>  #define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
>  #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
>  #define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
> +#define DIV_ROUND_CLOSEST(x, divisor)(			\
> +{							\
> +	typeof(divisor) __divisor = divisor;		\
> +	(((x) + ((__divisor) / 2)) / (__divisor));	\
> +}							\
> +)
>  
>  #define _RET_IP_		(unsigned long)__builtin_return_address(0)
>  #define _THIS_IP_  ({ __label__ __here; __here: (unsigned long)&&__here; })
> 

I don't get why you implement this as a macro rather than an inline
function? A function would look much better.

-- 
Jean Delvare
