Return-Path: <linux-kernel-owner+w=401wt.eu-S965409AbXBFApw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965409AbXBFApw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 19:45:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965406AbXBFApv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 19:45:51 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:40596 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965403AbXBFApt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 19:45:49 -0500
Subject: Re: [PATCH[RFC] kill sysrq-u (emergency remount r/o)
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Christoph Hellwig <hch@lst.de>
Cc: akpm@osdl.org, haveblue@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070205173247.GA25790@lst.de>
References: <20070205173247.GA25790@lst.de>
Content-Type: text/plain
Date: Tue, 06 Feb 2007 11:45:44 +1100
Message-Id: <1170722744.6097.45.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Mon, 2007-02-05 at 18:32 +0100, Christoph Hellwig wrote:
> Hi there,
> 
> in two recent discussions (file_list_lock scalability and remount r/o
> on suspend) I stumbled over this emergency remount feature.  It's not
> actually useful because it tries a potentially dangerous remount
> despite writers still beeing in progress, which we can't get rid.
> 
> I've attached one patch in this mail that simply kills the
> functionality, and in a reply to this mail I'll send a second one
> that keeps the sysrq functionality, but removes the force argument
> from do_remount_sb that overrides the still busy check.  This version
> is currently not useful, but makes a lot of sense once Dave Hansens
> per-mountpoint r/o patches get in, as we can check for a real write
> in progress instead of simply a file opened with write permission.
> 
> Any ideas and comments?

I'm not really keen - it sometimes get's invoked here and by others in a
sysrq-s sysrq-u sysrq-b sequence (sync, unmount, reboot) in a context
where things have gone south (particularly if there's some process
stuck). In that context it helps make filesystems cleaner than they'd
otherwise be, and the fact that writers might still be in progress is
irrelevant because the next keypress is going to reboot anyway.

Ok. I'll admit to being a heretic ext3 user, loving not having to fsck
after the above and still getting zero corruption as a result.

Regards,

Nigel

