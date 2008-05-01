Return-Path: <linux-kernel-owner+w=401wt.eu-S1761102AbYEAAXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761102AbYEAAXt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 20:23:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754936AbYEAAXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 20:23:40 -0400
Received: from vps1.tull.net ([66.180.172.116]:49730 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751522AbYEAAXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 20:23:40 -0400
X-Spam-Check-By: mail.local.tull.net
Date: Thu, 1 May 2008 10:23:29 +1000
From: Nick Andrew <nick@nick-andrew.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>
Subject: Re: [patch 0/3] dynamic_printk: new feature
Message-ID: <20080501002329.GD3914@tull.net>
References: <20080429183935.GA8717@redhat.com> <20080430124506.0dd2a473.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430124506.0dd2a473.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 12:45:06PM -0700, Andrew Morton wrote:
> > Add the ability to dynamically enable/disable pr_debug()/dev_dbg() in the
> > kernel.

Yes, that's the kind of thing I've been thinking about adding myself.

> > echo "add module_name" > /sys/kernel/debug/dynamic_printk/modules
> > echo "remove module_name" > /sys/kernel/debug/dynamic_printk/modules

How about not just debug messages but setting a loglevel for each module
(and/or subsystem?); kernel messages emitted beneath the loglevel value
to be discarded.

> We're now in the situation where numerous different subsystems have
> implemented private mechnisms for tuning their printk verbosity levels.

And it grows over time; just in the last week a patch came through to
V4L ...

	From: Andy Walls <awalls@radix.net>

	Replace the unconditional printk() messages with printk() messages that are
	enabled/disabled by a "debug" module parameter.

	[...]
	+#define dprintk(level, fmt, arg...)

> Have you considered the feasibility of ploddingly converting each of those
> drivers, one at a time over to the new infrastructure?  Because that's what
> we should do, I'm afraid.

I can help with that.

Nick.
-- 
PGP Key ID = 0x418487E7                      http://www.nick-andrew.net/
PGP Key fingerprint = B3ED 6894 8E49 1770 C24A  67E3 6266 6EB9 4184 87E7
