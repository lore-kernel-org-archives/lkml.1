Return-Path: <linux-kernel-owner+w=401wt.eu-S1759502AbXISLoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759502AbXISLoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 07:44:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754430AbXISLn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 07:43:56 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:49930 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424AbXISLnz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 07:43:55 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: [Jfs-discussion] [2/4] 2.6.23-rc6: known regressions
Date: Wed, 19 Sep 2007 13:44:24 +0200
User-Agent: KMail/1.9.6 (enterprise 20070731.694771)
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       jfs-discussion@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <46E8187E.9000006@googlemail.com> <46E81ACE.6030305@googlemail.com> <1189685917.26427.10.camel@norville.austin.ibm.com>
In-Reply-To: <1189685917.26427.10.camel@norville.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200709191344.25808.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 13 September 2007 schrieb Dave Kleikamp:
> On Wed, 2007-09-12 at 18:58 +0200, Michal Piotrowski wrote:
> 
> > Subject         : umount triggers a warning in jfs and takes almost a minute
> > References      : http://lkml.org/lkml/2007/9/4/73
> > Last known good : ?
> > Submitter       : Oliver Neukum <oliver@neukum.org>
> > Caused-By       : ?
> > Handled-By      : ?
> > Status          : unknown
> 
> I'm still waiting to hear from Oliver whether or not this is actually a
> regression.

OK, I've done test. On 2.6.22 I was unable to trigger the warning.
On 2.6.23-rc6 I get the following warning in about 3/4 of all unmounts:

Sep 19 13:08:04 oenone kernel: WARNING: at fs/jfs/jfs_logmgr.c:1643 jfs_flush_journal()
Sep 19 13:08:04 oenone kernel:
Sep 19 13:08:04 oenone kernel: Call Trace:
Sep 19 13:08:04 oenone kernel:  [<ffffffff8860f962>] :jfs:jfs_flush_journal+0x26a/0x27d
Sep 19 13:08:04 oenone kernel:  [<ffffffff8029fca1>] dispose_list+0xde/0xf7
Sep 19 13:08:04 oenone kernel:  [<ffffffff885fd003>] :jfs:jfs_umount+0x30/0xe5
Sep 19 13:08:04 oenone kernel:  [<ffffffff885f9a31>] :jfs:jfs_put_super+0xd/0x5e
Sep 19 13:08:04 oenone kernel:  [<ffffffff8028ef8f>] generic_shutdown_super+0x60/0xf0
Sep 19 13:08:04 oenone kernel:  [<ffffffff8028f02c>] kill_block_super+0xd/0x1e
Sep 19 13:08:04 oenone kernel:  [<ffffffff8028f0f7>] deactivate_super+0x6a/0x82
Sep 19 13:08:04 oenone kernel:  [<ffffffff802a2184>] sys_umount+0x249/0x25a
Sep 19 13:08:04 oenone kernel:  [<ffffffff802616ff>] audit_syscall_entry+0x141/0x174
Sep 19 13:08:04 oenone kernel:  [<ffffffff8020be8c>] tracesys+0xdc/0xe1
Sep 19 13:08:04 oenone kernel:

This is on a partition of a usb mass storage device with 2K sector size.
IMHO it is a regression. I am recompiling with CONFIG_JFS_DEBUG.

	Regards
		Oliver

