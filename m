Return-Path: <linux-kernel-owner+w=401wt.eu-S1756753AbYD2CMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753AbYD2CMi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 22:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbYD2CMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 22:12:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48481 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbYD2CM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 22:12:29 -0400
Date: Tue, 29 Apr 2008 03:12:28 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: umount(/proc) after CLONE_NEWNS in 2.6.25?
Message-ID: <20080429021228.GK5882@ZenIV.linux.org.uk>
References: <481609A5.1080905@msgid.tls.msk.ru> <20080428182759.GF5882@ZenIV.linux.org.uk> <20080429014718.GI5882@ZenIV.linux.org.uk> <20080429020638.GJ5882@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429020638.GJ5882@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 03:06:38AM +0100, Al Viro wrote:

> > Check the version of umount(8) you've got.  And see if that strace happens
> > to have open of /proc/mounts, without matching close by the time it calls
> > umount().  util-linux-ng 2.13.1 is _that_ dumb...
> 
> Umm...  Looks like something more odd is going on...

... or something much simpler:

; cat /proc/mounts |grep proc
proc /proc proc rw,nosuid,nodev,noexec 0 0
usbfs /proc/bus/usb usbfs rw 0 0
;

and unmounting the stuff mounted under /proc before doing umount /proc
works as expected.  Amazing how well the first cup of coffee helps...
