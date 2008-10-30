Return-Path: <linux-kernel-owner+w=401wt.eu-S1757931AbYJ3Rnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931AbYJ3Rnu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 13:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756947AbYJ3RnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 13:43:14 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34110 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715AbYJ3RnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 13:43:13 -0400
To: stern@rowland.harvard.edu
CC: miklos@szeredi.hu, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       ncunningham@crca.org.au, linux-pm@lists.linux-foundation.org
In-reply-to: <Pine.LNX.4.44L0.0810301301540.2513-100000@iolanthe.rowland.org>
	(message from Alan Stern on Thu, 30 Oct 2008 13:07:27 -0400 (EDT))
Subject: Re: [linux-pm] Freezer: Don't count threads waiting for frozen
 filesystems.
References: <Pine.LNX.4.44L0.0810301301540.2513-100000@iolanthe.rowland.org>
Message-Id: <E1KvbXx-0002dH-4j@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 30 Oct 2008 18:43:01 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2008, Alan Stern wrote:
> Okay.  Don't forget things like ioctl for sockets -- they often involve 
> doing I/O directly to the network interface device.

Yeah, ioctls should probably just always be protected (at least
initially), regardless of what type of file they are done on.

> What happens to a task accessing a non-regular file on a fuse 
> filesystem?  :-)

The same as on any other filesystem, i.e. the fs is only involved as
far as calling init_special_inode(), the rest is taken care of by the
VFS.

Tejun Heo recently posted patches to fuse which enable emulating a
char device from userspace.  That is another matter, obviously we'd
want to keep the "allow suspend during I/O" property of fuse in that
case, even though there's a char device involved (but no hardware, at
least not on that level).

Miklos
