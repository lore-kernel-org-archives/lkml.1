Return-Path: <linux-kernel-owner+w=401wt.eu-S1764335AbXHYEv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764335AbXHYEv4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 00:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751469AbXHYEvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 00:51:46 -0400
Received: from canuck.infradead.org ([209.217.80.40]:60726 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbXHYEvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 00:51:45 -0400
Date: Fri, 24 Aug 2007 21:49:44 -0700
From: Greg KH <greg@kroah.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] Fix kobject uevent string handling errors
Message-ID: <20070825044944.GA13282@kroah.com>
References: <20070824224707.GA7275@Krystal> <20070824161029.6236a5f4.akpm@linux-foundation.org> <20070825001638.GB9811@Krystal> <20070824174450.70337f4f.akpm@linux-foundation.org> <20070825004640.GA21756@kroah.com> <20070825041754.GA18557@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070825041754.GA18557@Krystal>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 25, 2007 at 12:17:54AM -0400, Mathieu Desnoyers wrote:
> Fix kobject uevent string handling errors
> 
> - increment env->buflen in dmi-id.c
> - fix off-by-one in add_uevent_var in error checking of vsnprintf
> - add warnings when add_uevent_var. Proper handling of its return values should
>   really be done by the callers, but they aren't, so things currently
>   fail silently. This is why I add warnings.

Ah, thanks, but Kay just sent me an updated version with portions of
this fix in it already.

Thanks a lot for helping us track this all down, hopefully the scsi
layer isn't still overflowing the buffer :(

> -	if (env->envp_idx >= ARRAY_SIZE(env->envp))
> +	if (env->envp_idx >= ARRAY_SIZE(env->envp)) {
> +		printk("add_uevent_var: too small array size %u %u\n",
> +			env->envp_idx, ARRAY_SIZE(env->envp));
> +		WARN_ON(1);

printk's always need a KERN_level.

thanks,

greg k-h
