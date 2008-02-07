Return-Path: <linux-kernel-owner+w=401wt.eu-S1756597AbYBGFno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597AbYBGFno (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 00:43:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754865AbYBGFnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 00:43:19 -0500
Received: from mx2.suse.de ([195.135.220.15]:58584 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754764AbYBGFnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 00:43:18 -0500
Date: Wed, 6 Feb 2008 21:47:38 -0800
From: Greg KH <gregkh@suse.de>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org
Subject: Re: partition sysfs OOPS in current GIT
Message-ID: <20080207054738.GB20902@suse.de>
References: <20080206235902.GA15719@suse.de> <20080206.160231.45881964.davem@davemloft.net> <20080207000959.GA16601@suse.de> <20080206.200618.11213859.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080206.200618.11213859.davem@davemloft.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2008 at 08:06:18PM -0800, David Miller wrote:
> 
> Greg, I'm pretty sure I know what's happening.
> 
> For whatever reason we're invoking dev_attr_show() on attribute_group
> objects.

Ugh, that makes sense.

> The reason it probably only crashes on sparc64 is because perhaps at
> that dev_attr->show offset on x86 there are zero bytes there instead
> of a pointer, so the NULL check here in dev_attr_show() masks the bug.
> 
> The problem with all of this "container_of() this", "container_of()
> that" is that we lose real type checking.  So unless we add magic
> cookies to verify or other hacks, functions never really know if the
> container they are being passed really is a subset object of the type
> they expect.

We are supposed to be careful about this, but bad things are known to
happen :)

> Can you read the code instead of asking more information from me to
> try and figure out why the attribute showing paths might be
> misconfigured for these block device objects after the changeset in
> question?  I can do this, but you're more likely to find the problem
> quickly than I am.

Yes, I'll look into it tonight if I get this -stable push out in time,
or if not, first thing in the morning.

> I redid the bisect to make sure it absolutely was that specific
> changeset, and it is.

Thanks for doing that, I'll let you know when I have a patch to test.

greg k-h
