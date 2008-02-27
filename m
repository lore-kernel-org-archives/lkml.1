Return-Path: <linux-kernel-owner+w=401wt.eu-S1756401AbYB0Sw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401AbYB0Sw4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 13:52:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753362AbYB0Swq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 13:52:46 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940AbYB0Swq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 13:52:46 -0500
Date: Wed, 27 Feb 2008 13:52:25 -0500
From: Bill Nottingham <notting@redhat.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC, BAD IDEA] /proc/tty/console
Message-ID: <20080227185225.GB3137@nostromo.devel.redhat.com>
Mail-Followup-To: Randy Dunlap <randy.dunlap@oracle.com>,
	linux-kernel@vger.kernel.org
References: <20080227181857.GA3137@nostromo.devel.redhat.com> <20080227103730.761c35d4.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080227103730.761c35d4.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap (randy.dunlap@oracle.com) said: 
> > I'm not seriously proposing this. But, as far as I can tell, this
> > information isn't exposed to userspace anywhere, and it's a useful
> > thing to know. I'm certainly open for better ideas on how to expose
> > this (sysfs attributes? other?)
> > 
> > ....
> > 
> > The attached patch adds /proc/tty/console. The contents of it are
> > simply a description of the current drivers attached to /dev/console.
> > For example, a boot with 'console=ttyS3,115200n1 console=tty0' would
> > yield:
> > 
> > # cat /proc/tty/console
> > unknown             /dev/tty0
> > serial              /dev/ttyS3
> > 
> 
> So it omits other consoles (non-tty) intentionally?
> or does it include them even though the procfs filename contains "tty"?

It only does consoles that have a tty_driver, as those are the ones I'd
find most interesting.

> Anyway, I'd like to see something like this.
> Compare http://www.xenotime.net/linux/patches/consoles-list.patch
> (April-2006).

Reading that, unless I'm missing something, you'd lose the device name
distinction (i.e., *which* serial port).

Bill
