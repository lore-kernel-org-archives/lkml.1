Return-Path: <linux-kernel-owner+w=401wt.eu-S1760944AbYGRS4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760944AbYGRS4t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 14:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758813AbYGRS4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 14:56:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:40618 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758147AbYGRS4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 14:56:17 -0400
Date: Fri, 18 Jul 2008 11:46:16 -0700
From: Greg KH <greg@kroah.com>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: torvalds@linux-foundation.org, Randy Dunlap <rdunlap@xenotime.net>,
       linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: debugfs_create_u*() not SMP-safe
Message-ID: <20080718184616.GB17294@kroah.com>
References: <20080718035237.GA7744@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080718035237.GA7744@localhost>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 06:52:37AM +0300, Eduard - Gabriel Munteanu wrote:
> Hi,
> 
> I noticed debugfs_create_u*() functions don't allow for any precautions
> to be taken while doing r/w to the exported variables. Thus any export of a
> variable isn't SMP-safe.

That's true, so don't do multiple writes to a debugfs file at the same
time :)

> As far as I can tell, this only works safely for constant data. Let me
> ask then, what is the purpose of these functions? Are they intended only
> for unreliable data?

This is for _debug_ data, not stuff that is "critical".  This is for
informational or debug purposes only.  If you really care about the data
always being correct here, then don't use debugfs, that's not what it is
for.

Hope this helps,

greg k-h
