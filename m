Return-Path: <linux-kernel-owner+w=401wt.eu-S1755325AbYEADvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325AbYEADvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 23:51:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758795AbYEADvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 23:51:18 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46774 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758425AbYEADvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 23:51:17 -0400
Date: Wed, 30 Apr 2008 20:44:49 -0700
From: Greg KH <greg@kroah.com>
To: Jason Baron <jbaron@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/3] dynamic_printk: new feature
Message-ID: <20080501034449.GD6339@kroah.com>
References: <20080429183935.GA8717@redhat.com> <20080430124506.0dd2a473.akpm@linux-foundation.org> <20080430210147.GA5616@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430210147.GA5616@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First off, I agree with Andrew, this is a very welcome thing to do.  If
there's anything I can do to help this out, please let me know.

On Wed, Apr 30, 2008 at 05:01:50PM -0400, Jason Baron wrote:
> On Wed, Apr 30, 2008 at 12:45:06PM -0700, Andrew Morton wrote:
> > We're now in the situation where numerous different subsystems have
> > implemented private mechnisms for tuning their printk verbosity levels.
> > 
> > Have you taken a look across the tree with a view to converting some of
> > them?  If so, how sizeable/messy/feasible would that task be?
> > 
> > 
> 
> i really only focused on pr_debug()/dev_dbg(), with an eye towards
> widening the scope as we go...but I agree that it would be nice to
> understand the scope for the start...i find ~5000 call sites to
> dprintk(), which would be ideal candidates for this type of
> infrastructure.

That's a good first start :)

Lots of the existing printk() type wrappers can also use the dev_*
versions as well (like the ALSA ones for example.)  So it might be
easier to focus on the existing users of these two functions, and then
work to convert the other different variants over to the dev_printk ones
where possible and d_printk where not (you don't always have a struct
device to use at the moment, which is required by dev_printk)

If you want to start with the USB core and drivers, I'll be glad to help
ensure those patches go in as well.

thanks,

greg k-h
