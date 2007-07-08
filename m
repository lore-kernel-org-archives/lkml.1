Return-Path: <linux-kernel-owner+w=401wt.eu-S1757324AbXGHSZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324AbXGHSZZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 14:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754604AbXGHSZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 14:25:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754592AbXGHSZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 14:25:12 -0400
Message-ID: <46912BF5.8080201@redhat.com>
Date: Sun, 08 Jul 2007 11:24:53 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Al Viro <viro@ftp.linux.org.uk>,
       Markus Trippelsdorf <markus@trippelsdorf.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc6(mm1) Unable to handle kernel NULL pointer dereference
 - git-bisect result
References: <20070708051452.GA4140@gentoox2.trippelsdorf.de> <20070708012016.455ce8d5.akpm@linux-foundation.org> <20070708100911.GA4196@gentoox2.trippelsdorf.de> <20070708152808.GA5902@gentoox2.trippelsdorf.de> <469119A3.6030409@redhat.com> <20070708173416.GG21668@ftp.linux.org.uk> <469121DA.6030600@redhat.com> <alpine.LFD.0.999.0707081058120.31544@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707081058120.31544@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Linus Torvalds wrote:
> notify_change() does *not* do permission checks for 
> ATTR_CTIME/MTIME/ATIME.

Then I don't understand

        /* Check for setting the inode time. */
        if (ia_valid & (ATTR_MTIME_SET | ATTR_ATIME_SET)) {
                if (current->fsuid != inode->i_uid && !capable(CAP_FOWNER))
                        goto error;
        }

in inode_change_ok.  This seems to me exactly like the check needed.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGkSv12ijCOnn/RHQRAkp8AJ9q9vuy1ACjiYHteRac4Q86WO5wlgCfbr11
I0d6V5VGJGmpkuc9NsO6lkE=
=imhB
-----END PGP SIGNATURE-----
