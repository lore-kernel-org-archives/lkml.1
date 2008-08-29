Return-Path: <linux-kernel-owner+w=401wt.eu-S1759563AbYH2WcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759563AbYH2WcJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 18:32:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755581AbYH2Wb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 18:31:56 -0400
Received: from quackingmoose.com ([63.73.180.143]:58043 "EHLO
	penguin.merfinllc.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755117AbYH2Wb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 18:31:56 -0400
Date: Fri, 29 Aug 2008 15:31:55 -0700
From: Aaron Straus <aaron@merfinllc.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mpm@selenic.com, linux-kernel@vger.kernel.org,
       "Theodore Ts'o" <tytso@mit.edu>, stable@kernel.org
Subject: Re: drivers/char/random.c line 728 BUG
Message-ID: <20080829223155.GM31108@merfinllc.com>
References: <20080826225918.GC5452@merfinllc.com> <20080828225924.GD6432@merfinllc.com> <20080829124807.54293904.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080829124807.54293904.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Aug 29 12:48 PM, Andrew Morton wrote:
> yep, I would agree with all that.

Thanks for responding.

> How's this look?

Quick question off list... below

> -	if (r == &input_pool &&
> -	    r->entropy_count >= random_read_wakeup_thresh) {
> +	if (r == &input_pool && entropy_count >= random_read_wakeup_thresh) {
>  		wake_up_interruptible(&random_read_wait);
>  		kill_fasync(&fasync, SIGIO, POLL_IN);
>  	}
> -
> +	r->entropy_count = entropy_count;

Here you set the entropy_count in the pool *after* waking up the reader.
I was a little worried the reader would find the entropy_count unchanged
and go back to sleep.


					Regards,
					=a=

-- 
===================
Aaron Straus
aaron@merfinllc.com
