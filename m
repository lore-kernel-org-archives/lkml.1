Return-Path: <linux-kernel-owner+w=401wt.eu-S1753960AbYKPPIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbYKPPIb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 10:08:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbYKPPIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 10:08:21 -0500
Received: from 1wt.eu ([62.212.114.60]:1264 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054AbYKPPIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 10:08:20 -0500
Date: Sun, 16 Nov 2008 16:07:56 +0100
From: Willy Tarreau <w@1wt.eu>
To: Bernhard Walle <bwalle@suse.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       crash-utility@redhat.com
Subject: Re: [PATCH 2/3] Add dev.mem.restricted sysctl
Message-ID: <20081116150756.GA24654@1wt.eu>
References: <1226846868-9595-1-git-send-email-bwalle@suse.de> <1226846868-9595-3-git-send-email-bwalle@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226846868-9595-3-git-send-email-bwalle@suse.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 16, 2008 at 03:47:47PM +0100, Bernhard Walle wrote:
> When CONFIG_STRICT_DEVMEM is set, live debugging is not possible with the
> crash utility (see http://people.redhat.com/~anderson). For distributors
> who ship a generic kernel it's difficult: Disabling CONFIG_STRICT_DEVMEM
> is possible, but in general the protection provided by CONFIG_STRICT_DEVMEM
> is useful. However, live debugging should be still neceessary.
> 
> This patch now adds a dev.mem.restricted sysctl that defaults to 0 (off).
> When set to 1 (on), /dev/mem access is unrestricted and crash can be used.

I like your approach. I use /dev/mem a lot for debugging purposes, and
even sometimes to recover important data from memory after a crash has
occurred. Having the ability to inspect memory again by setting a sysctl
seems very appealing to me.

> >From a security point of view the sysctl should be no problem. It's already
> possible to circumvent that restriction if you have root access by loading
> a kernel module that installs a kretprobe that returns 1 for the check function.

I agree.

> I thought of a command line parameter first, but we already have lots of
> command line parameters and rebooting the machine is more difficult than
> just setting a sysctl to 1. It may be possible to implement setting that
> variable in the tools automatically, but that's out of the scope of that
> patch for the kernel and should also not be discussed on LKML.

Rebooting the machine voids any ability to debug or recover data, so the
sysctl is the way to go IMHO.

Regards,
Willy

