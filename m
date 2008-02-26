Return-Path: <linux-kernel-owner+w=401wt.eu-S1759274AbYBZDgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759274AbYBZDgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 22:36:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbYBZDgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 22:36:14 -0500
Received: from smtp-out.google.com ([216.239.33.17]:39251 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbYBZDgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 22:36:14 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=WF8/KtgAiBSEj4lhNNwSj0zYhGDtd018IXCrhYD3BwCZiCznOnGwfDeI4mHQQqzFU
	f/gMNueFExNuDxK5KBquw==
Date: Mon, 25 Feb 2008 19:35:46 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: akpm@linux-foundation.org, clameter@sgi.com, Lee.Schermerhorn@hp.com,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/6] mempolicy: convert MPOL constants to enum
In-Reply-To: <20080225212056.ca388983.pj@sgi.com>
Message-ID: <alpine.DEB.1.00.0802251931030.6021@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802250012420.12368@chino.kir.corp.google.com> <20080225212056.ca388983.pj@sgi.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Feb 2008, Paul Jackson wrote:

> +enum {
> +	MPOL_DEFAULT,
> +	MPOL_PREFERRED,
> +	MPOL_BIND,
> +	MPOL_INTERLEAVE,
> +	MPOL_MAX,	/* always last member of enum */
> 
> Aren't the values that these constants take part of the
> user visible kernel API?
> 
> In other words, if someone added another MPOL_* in the middle
> of this enum, it would break mbind/set_mempolicy/get_mempolicy
> users, right:
> 
> +enum {
> +	MPOL_DEFAULT,
> +	MPOL_PREFERRED,
> +	MPOL_YET_ANOTHER_FLAG,		/* <== added flag ... oops */
> +	MPOL_BIND,
> +	MPOL_INTERLEAVE,
> +	MPOL_MAX,	/* always last member of enum */
> 

I don't suspect that a kernel developer is going to make such an egregious 
error.  The user would need to be using a new linux/mempolicy.h with an 
old kernel to get the wrong behavior.

> I'm thinking that we should still specify the specific value
> of each of these flags, by way of documenting these necessary
> values, as in:
> 
> +enum {
> +	MPOL_DEFAULT = 0,
> +	MPOL_PREFERRED = 1,
> +	MPOL_BIND = 2,
> +	MPOL_INTERLEAVE = 3,
> +	MPOL_MAX,	/* always last member of enum */
> 

That looks overly redundant to me and doesn't protect against adding 
MPOL_YET_ANOTHER_FLAG in the middle of preferred and bind to get two mode 
values with the int value of 1.

		David
