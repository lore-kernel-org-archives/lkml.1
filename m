Return-Path: <linux-kernel-owner+w=401wt.eu-S1755304AbZELPL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbZELPL1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 11:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753916AbZELPLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 11:11:14 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:51899 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbZELPLN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 11:11:13 -0400
MIME-Version: 1.0
In-Reply-To: <1242132344.31807.48.camel@localhost.localdomain>
References: <20090509143742.GA27663@kroah.com> <1242063630.6624.22.camel@moss-terrapins.epoch.ncsc.mil> 
	<20090511175626.GA4758@kroah.com> <1242074517.6624.183.camel@moss-terrapins.epoch.ncsc.mil> 
	<ac3eb2510905111405y5541117euf84dd38d39012bd0@mail.gmail.com> 
	<1242132344.31807.48.camel@localhost.localdomain>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 12 May 2009 17:10:53 +0200
Message-ID: <ac3eb2510905120810n101dff08yfa945a2ab4b17168@mail.gmail.com>
Subject: Re: [patch 00/13] devtmpfs patches
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: "David P. Quigley" <dpquigl@tycho.nsa.gov>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Jan Blunck <jblunck@suse.de>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12, 2009 at 14:45, Stephen Smalley <sds@tycho.nsa.gov> wrote:

> I don't think merely changing the fstype will suffice; that merely lets
> us assign a different default security context to inodes in the
> filesystem (e.g. device_t vs tmpfs_t), but doesn't address the fact that
> use of devtmpfs rather than just udev seems to alter the permission
> checking upon an open(2) by mingetty, thereby breaking existing
> policies.

It will be its own filesystem type and no longer be auto-mounted in
initramfs at all. There is an option to request an auto-mount it for
the case the kernel mounted the rootfs. This is to allow the rescue
setup to work.

> Previously mingetty didn't require permissions to mknod; with
> devtmpfs, it does.  I'm wondering if devtmpfs is internally performing
> operations that ought to be done in kernel context rather than the
> context of the userspace process that initiated the open(2).

How may that look like?

> Also, I was wondering why the existing restorecon -R /dev that is
> performed by /etc/rc.sysinit to fix up the security contexts on the
> initial /dev tree prior to policy load doesn't seem to be getting
> applied when devtmpfs is enabled.  Does devtmpfs pass through setxattr()
> requests to the underlying tmpfs mount?

It's a plain tmpfs, nothing different from a manual mounted one, just
that the kernel has created the instance and remembered the vfs mount
to put stuff into it, regardless of where is is mounted, or maybe not
mounted at all.

Thanks,
Kay
