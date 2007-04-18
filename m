Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381AbXDRRBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbXDRRBl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 13:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbXDRRBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 13:01:41 -0400
Received: from adelie.ubuntu.com ([82.211.81.139]:51188 "EHLO
	adelie.ubuntu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbXDRRBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 13:01:40 -0400
X-Greylist: delayed 2151 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Apr 2007 13:01:40 EDT
Subject: Re: [RFC] [PATCH] Allow overriding module parameters from kernel
	command_line
From: Ben Collins <ben.collins@ubuntu.com>
To: Kyle McMartin <kyle@canonical.com>
Cc: linux-kernel@vger.kernel.org, alan@redhat.com
In-Reply-To: <20070418155552.GA3744@athena.road.mcmartin.ca>
References: <20070418155552.GA3744@athena.road.mcmartin.ca>
Content-Type: text/plain
Date: Wed, 18 Apr 2007 12:25:48 -0400
Message-Id: <1176913548.6036.193.camel@cunning>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-18 at 11:55 -0400, Kyle McMartin wrote:
> With the move to initramfs and heavily modular configs, which include
> loading storage drivers from early userspace, it's becoming harder
> to provide users with a way of overriding module parameters at boot.
> 
> Currently, users would have to break into the initramfs, edit the
> modprobe options, and then let boot continue. They have a much easier time
> dealing with adding options on the command line from Grub or what have you.
> 
> I hacked out this patch quickly to re-parse saved_command_line[] when we
> load a module in an attempt to rectify this.
> 
> (The specific use-case I was looking at here was HPA commands failing on
>  sata_nv controllers, and needing to pass the adma=0 option to the module...
>  Users had a hard time testing without an easy way of overriding the module.)
> 
> Clearly this is not entirely optimal, because we're parsing command_line
> after the module params are parsed. This ends of being a policy decision,
> whether the /sbin/modprobe commandline should override the kernel
> command_line, or vice versa.
> 
> Anyway, please comment...

Just pasting my comments to kyle on IRC for benefit of discussion:

"I'm of the opinion that cmdline args from the kernel should override
modprobe args...mainly because adding those args to the kernel cmdline
is clearly an attempt to override userspace"

"maybe have some sysfs attr to disable this feature, so userspace can go
back to normal after whatever needed fixing"

The use case for us is that we've had to add a couple of initramfs
scripts to parse common module params (all_generic_ide for example).

We'd like to move away from this and have a clear way of passing any
module param on the kernel command line. Workarounds for users are much
easier than having to roll new CDs for every little quirk. Plus it's
easier for testing (if the quirk is a bug that keeps them from
installing at all, then we can't just hand them new kernels very
easily).


-- 
Ubuntu:    http://www.ubuntu.com/
Linux1394: http://www.linux1394.org/

