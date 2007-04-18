Return-Path: <linux-kernel-owner+w=401wt.eu-S1753983AbXDRVpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbXDRVpq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 17:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753979AbXDRVpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 17:45:45 -0400
Received: from smtp.osdl.org ([65.172.181.24]:47539 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753983AbXDRVpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 17:45:44 -0400
Date: Wed, 18 Apr 2007 14:45:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kyle McMartin <kyle@canonical.com>
Cc: linux-kernel@vger.kernel.org, alan@redhat.com, bcollins@ubuntu.com
Subject: Re: [RFC] [PATCH] Allow overriding module parameters from kernel
 command_line
Message-Id: <20070418144512.14528b78.akpm@linux-foundation.org>
In-Reply-To: <20070418155552.GA3744@athena.road.mcmartin.ca>
References: <20070418155552.GA3744@athena.road.mcmartin.ca>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 18 Apr 2007 11:55:52 -0400 Kyle McMartin <kyle@canonical.com> wrote:
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

Similar-but-different: I was trying to persuade a Fedora system to use ext2
for the root filesystem the other day.  Turns out that we somehow managed
to break `rootfstype=' in this situation and it cheerfully continued to use
ext3.

Fixed by changing /etc/fstab and rebuilding initrd, but IMO rootfstype=
should have worked.

