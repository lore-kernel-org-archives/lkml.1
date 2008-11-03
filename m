Return-Path: <linux-kernel-owner+w=401wt.eu-S1756679AbYKCWfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679AbYKCWfm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 17:35:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753628AbYKCWfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 17:35:30 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57831 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753558AbYKCWf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 17:35:29 -0500
Date: Mon, 3 Nov 2008 14:35:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: roel kluin <roel.kluin@gmail.com>
Cc: len.brown@intel.com, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH] intel_menlo: max_state is unsigned, invalid test
Message-Id: <20081103143526.375be238.akpm@linux-foundation.org>
In-Reply-To: <4908D067.9080207@gmail.com>
References: <4908D067.9080207@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2008 17:06:47 -0400
roel kluin <roel.kluin@gmail.com> wrote:

> max_state is unsigned, so the test is invalid.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> I think max_state can only become -1, no? then probably a different
> patch is required.
> I may not be able to respond for a few weeks.
> 
> diff --git a/drivers/misc/intel_menlow.c b/drivers/misc/intel_menlow.c
> index e00a275..980171d 100644
> --- a/drivers/misc/intel_menlow.c
> +++ b/drivers/misc/intel_menlow.c
> @@ -121,7 +121,7 @@ static int memory_set_cur_bandwidth(struct thermal_cooling_device *cdev,
>  	if (memory_get_int_max_bandwidth(cdev, &max_state))
>  		return -EFAULT;
>  
> -	if (max_state < 0 || state > max_state)
> +	if (max_state == -1 || state > max_state)
>  		return -EINVAL;
>  
>  	arg_list.count = 1;
> 

hm, maybe.

This can only happen if acpi_evaluate_integer(MEMORY_GET_BANDWIDTH)
returned no-error and a bandwidth of zero (I assume).

Is this a special case which the driver really wanted to handle?  If
so, why is "0" the only bad value which we're checking for?  Or is this
all some big brainfart which should be removed?
