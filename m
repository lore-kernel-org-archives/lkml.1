Return-Path: <linux-kernel-owner+w=401wt.eu-S932458AbXDVIU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458AbXDVIU6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 04:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932279AbXDVIU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 04:20:57 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:42583 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932244AbXDVIU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 04:20:56 -0400
To: ebiederm@xmission.com
CC: jengelh@linux01.gwdg.de, akpm@linux-foundation.org, miklos@szeredi.hu,
       serue@us.ibm.com, viro@ftp.linux.org.uk, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
In-reply-to: <m17is5igtb.fsf@ebiederm.dsl.xmission.com>
Subject: Re: [patch 7/8] allow unprivileged mounts
References: <20070420102532.385211890@szeredi.hu>
	<20070420102652.075606533@szeredi.hu>
	<20070421005513.e230aa88.akpm@linux-foundation.org>
	<m1bqhhked1.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.61.0704211743100.9989@yvahk01.tjqt.qr>
	<m1zm51is2h.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.61.0704211905230.9989@yvahk01.tjqt.qr> <m17is5igtb.fsf@ebiederm.dsl.xmission.com>
Message-Id: <E1HfXIY-0004Js-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sun, 22 Apr 2007 10:19:54 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > On Apr 21 2007 10:57, Eric W. Biederman wrote:
> >>
> >>> tmpfs!
> >>
> >>tmpfs is a possible problem because it can consume lots of ram/swap. 
> >>Which is why it has limits on the amount of space it can consume. 
> >
> > Users can gobble up all RAM and swap already today. (Unless they are
> > confined into an rlimit, which, in most systems, is not the case.)
> > And in case /dev/shm exists, they can already fill it without running
> > into an rlimit early.
> 
> There are systems that care about rlimits and there is strong intersection
> between caring about rlimits and user mounts.  Although I do agree that
> it looks like we have gotten lazy with the default mount options for
> /dev/shm.
> 
> Going a little farther any filesystem that is safe to put on a usb
> stick and mount automatically should ultimately be safe for unprivileged
> mounts as well.

Actually, that's not as simple.

For the usb stick or cdrom you need physical access to the machine.
And once you have that you basically have full control over the system
anyway.

But with block filesystems, the user would still need access to the
device (currently kernel doesn't even check this I think).

So it may make sense to mark all block based filesystems safe, and
defer permission checking to user access on the block device.

But the safe flag is still needed for filesystems, which don't have
such an additional access checking, such as network filesystems.

Miklos
