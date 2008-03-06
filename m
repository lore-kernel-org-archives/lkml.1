Return-Path: <linux-kernel-owner+w=401wt.eu-S1765302AbYCFBiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765302AbYCFBiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 20:38:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758438AbYCFBhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 20:37:55 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753563AbYCFBhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 20:37:55 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Dave Jones <davej@codemonkey.org.uk>
X-Fcc: ~/Mail/linus
Cc: sam@ravnborg.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: rfc: nonint_oldconfig
In-Reply-To: Dave Jones's message of  Wednesday, 5 March 2008 13:56:30 -0500 <20080305185630.GD16181@codemonkey.org.uk>
References: <20080305185630.GD16181@codemonkey.org.uk>
X-Zippy-Says: If I am elected no one will ever have to do their laundry again!
Message-Id: <20080306013722.4895D2700FD@magilla.localdomain>
Date: Wed,  5 Mar 2008 17:37:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There's also an additional target that does the same, but
> ignores any options defined in the local configs that the kernel
> being configured doesn't know about.

I added this one (loose_nonint_oldconfig target, -B option to conf).
It is the noninteractive equivalent of taking your old .config after a
source upgrade, running 'make oldconfig' and hitting return a lot.
(If options from your old .config went away, you get harmless warnings.
If new options appeared, you get the defaults for those.)
That's what I do in my hand builds after a git pull (hit return a lot).

The benefit of 'make loose_nonint_oldconfig' is it lets me do the same
thing with scripted rpm builds made from fresh git snapshot code.  These
builds use a .config chosen for the Fedora production kernel, but a new
code snapshot (sometimes with and sometimes without the Fedora patches to
the kernel).  The Fedora patches sometimes add nonstandard config options,
and the bleeding edge kernel snapshot I try sometimes had added new config
options that Fedora's kernel configs do not yet set or clear explicitly.

For development, it is very handy to just get a build that approximates the
Fedora config for the stable kernel but uses the latest development kernel
source.  99% of the time the default for new options works fine for my
purposes.  When a new kernel is imported for proper Fedora builds, then
we'll update the standard configs with tested settings for the new source.
Having to tweak those every time I want to spin a testing kernel rpm would
be a waste.


Thanks,
Roland
