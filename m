Return-Path: <linux-kernel-owner+w=401wt.eu-S1754733AbZEIPk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbZEIPk1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 11:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbZEIPkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 11:40:13 -0400
Received: from cantor.suse.de ([195.135.220.2]:58641 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbZEIPkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 11:40:12 -0400
Message-ID: <4A05A3A5.7050707@suse.com>
Date: Sat, 09 May 2009 11:39:17 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, reiserfs-devel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.30-rc: reiserfs_delete_xattrs log spam (bug 13122)
References: <4A057951.8040501@s5r6.in-berlin.de> <tkrat.fe49a8c298128f65@s5r6.in-berlin.de> <20090509130152.GD8633@ZenIV.linux.org.uk>
In-Reply-To: <20090509130152.GD8633@ZenIV.linux.org.uk>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Al Viro wrote:
> On Sat, May 09, 2009 at 02:44:25PM +0200, Stefan Richter wrote:
>> On  9 May, Stefan Richter wrote:
>>> I just switched from 2.6.29.1 to 2.6.30-rc5, and I'm getting the same as 
>>> the reporter of http://bugzilla.kernel.org/show_bug.cgi?id=13122 alias
>>> http://marc.info/?l=linux-kernel&m=123990989515105, i.e. repetitions of
>>>  >>>
>>> May  9 14:27:22 stein REISERFS warning (device sda1): jdm-20004 
>>> reiserfs_delete_xattrs: Couldn't delete all xattrs (-13)
>>> May  9 14:27:22 stein
>>> <<<
>>>
>>> This happens in irregular intervals, but a lot of times --- presumably 
>>> when certain files are accessed.  I'm on a recently set-up Gentoo 
>>> machine.  I created its root filesystem using the Gentoo x86-64 minimal 
>>> boot CD; my guess is that the kernel of the boot CD had 
>>> CONFIG_REISERFS_FS_XATTR enabled.  All kernels which I used since then 
>>> have it disabled:  2.6.27-gentoo-r8, 2.6.29.1, now 2.6.30-rc5.
>> PS:  Also, the following came up at this (= first) boot of 2.6.30-rc, as
>> a warm reboot from 2.6.29.1. I have no idea whether it's connected to
>> the issue.
> 
> That WARN_ON() is fixed in the patches in VFS queue; should be gone in
> -next and I'm going to push a bunch of fixes to Linus today, this one
> among them.
> 
> The first one you've reported is a different story.  Could you try to
> bisect it?

Ok, I've looked into it some more.

The issue is that with xattrs disabled, reiserfs_permission isn't built.
The ACL part of it doesn't matter, but the IS_PRIVATE check does. What's
happening is that with generic_permission, a regular user doesn't have
permission to traverse the privroot. Thus, the -EACCES.

I'll post a patch this afternoon.

- -Jeff

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkoFo6QACgkQLPWxlyuTD7I1gwCfbPa4ipt7FB/gq2Xxsrxkq/K6
YggAmwf5eTyGGVwNeUmqp8yPNGc2mFbb
=Gobs
-----END PGP SIGNATURE-----
