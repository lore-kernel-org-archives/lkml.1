Return-Path: <linux-kernel-owner+w=401wt.eu-S1758297AbXISMg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758297AbXISMg3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 08:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753363AbXISMgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 08:36:19 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:34636 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbXISMgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 08:36:17 -0400
Subject: Re: [Jfs-discussion] [2/4] 2.6.23-rc6: known regressions
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       jfs-discussion@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200709191344.25808.oliver@neukum.org>
References: <46E8187E.9000006@googlemail.com>
	 <46E81ACE.6030305@googlemail.com>
	 <1189685917.26427.10.camel@norville.austin.ibm.com>
	 <200709191344.25808.oliver@neukum.org>
Content-Type: text/plain
Date: Wed, 19 Sep 2007 07:36:05 -0500
Message-Id: <1190205365.12900.6.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-19 at 13:44 +0200, Oliver Neukum wrote:
> Am Donnerstag 13 September 2007 schrieb Dave Kleikamp:
> > On Wed, 2007-09-12 at 18:58 +0200, Michal Piotrowski wrote:
> > 
> > > Subject         : umount triggers a warning in jfs and takes almost a minute
> > > References      : http://lkml.org/lkml/2007/9/4/73
> > > Last known good : ?
> > > Submitter       : Oliver Neukum <oliver@neukum.org>
> > > Caused-By       : ?
> > > Handled-By      : ?
> > > Status          : unknown
> > 
> > I'm still waiting to hear from Oliver whether or not this is actually a
> > regression.
> 
> OK, I've done test. On 2.6.22 I was unable to trigger the warning.
> On 2.6.23-rc6 I get the following warning in about 3/4 of all unmounts:
> 
> Sep 19 13:08:04 oenone kernel: WARNING: at fs/jfs/jfs_logmgr.c:1643 jfs_flush_journal()
> Sep 19 13:08:04 oenone kernel:
> Sep 19 13:08:04 oenone kernel: Call Trace:
> Sep 19 13:08:04 oenone kernel:  [<ffffffff8860f962>] :jfs:jfs_flush_journal+0x26a/0x27d
> Sep 19 13:08:04 oenone kernel:  [<ffffffff8029fca1>] dispose_list+0xde/0xf7
> Sep 19 13:08:04 oenone kernel:  [<ffffffff885fd003>] :jfs:jfs_umount+0x30/0xe5
> Sep 19 13:08:04 oenone kernel:  [<ffffffff885f9a31>] :jfs:jfs_put_super+0xd/0x5e
> Sep 19 13:08:04 oenone kernel:  [<ffffffff8028ef8f>] generic_shutdown_super+0x60/0xf0
> Sep 19 13:08:04 oenone kernel:  [<ffffffff8028f02c>] kill_block_super+0xd/0x1e
> Sep 19 13:08:04 oenone kernel:  [<ffffffff8028f0f7>] deactivate_super+0x6a/0x82
> Sep 19 13:08:04 oenone kernel:  [<ffffffff802a2184>] sys_umount+0x249/0x25a
> Sep 19 13:08:04 oenone kernel:  [<ffffffff802616ff>] audit_syscall_entry+0x141/0x174
> Sep 19 13:08:04 oenone kernel:  [<ffffffff8020be8c>] tracesys+0xdc/0xe1
> Sep 19 13:08:04 oenone kernel:
> 
> This is on a partition of a usb mass storage device with 2K sector size.
> IMHO it is a regression. I am recompiling with CONFIG_JFS_DEBUG.

Looks like a regression then.  I'll take a look at the debug output and get back to you.

Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

