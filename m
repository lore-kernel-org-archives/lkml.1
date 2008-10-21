Return-Path: <linux-kernel-owner+w=401wt.eu-S1755393AbYJUXmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbYJUXmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 19:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbYJUXmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 19:42:24 -0400
Received: from anchor-post-32.mail.demon.net ([194.217.242.90]:4783 "EHLO
	anchor-post-32.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752021AbYJUXmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 19:42:23 -0400
Message-ID: <48FE68E9.2020401@lougher.demon.co.uk>
Date: Wed, 22 Oct 2008 00:42:33 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
CC: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       tim.bird@am.sony.com
Subject: Re: Subject: [PATCH 00/16] Squashfs: compressed	read-only	filesystem
References: <E1KqrTW-0001x8-3h@dylan>	 <1224268027.18940.78.camel@moss-terrapins.epoch.ncsc.mil>	 <48FD2C74.2070608@lougher.demon.co.uk> <1224605348.31157.67.camel@moss-terrapins.epoch.ncsc.mil>
In-Reply-To: <1224605348.31157.67.camel@moss-terrapins.epoch.ncsc.mil>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David P. Quigley wrote:

> 
> Looking through the code I noticed that you give certain object types
> the same inode number for all instances of it (devices, fifo/sockets).
> How is this done internally? Do these types of objects occupy the same
> position on the inode table? If so how do you differentiate between a
> device and a socket?
> 

No, devices and fifo/sockets get their own unique inode numbers:

root@slackware:/mnt# mount -t squashfs test.sqsh /mnt2 -o loop
root@slackware:/mnt# ls -li /mnt2
total 0
2 crw-r--r-- 1 root root 1, 1 2008-10-22 00:31 device
4 prw-r--r-- 1 root root    0 2008-10-22 00:31 fifo
3 srwxr-xr-x 1 root root    0 2008-10-17 16:25 socket

struct squashfs_ipc_inode {
         __le16                  inode_type;
         __le16                  mode;
         __le16                  uid;
         __le16                  guid;
         __le32                  mtime;
         __le32                  inode_number;
         __le32                  nlink;
};

struct squashfs_dev_inode {
         __le16                  inode_type;
         __le16                  mode;
         __le16                  uid;
         __le16                  guid;
         __le32                  mtime;
         __le32                  inode_number;
         __le32                  nlink;
         __le32                  rdev;
};


> I use to work on Unionfs and we used CVS initially for our SCM. When we
> started working on mainlining Unionfs we moved over to a GIT based
> system and we found it worked a lot better. You might want to consider
> moving your patches to a GIT tree that you make publically available so
> people can just clone, compile, and test them. I don't see anything that
> stops Squashfs from being compiled and loaded as a module so it might
> not be necessary but it makes it easier for people who want to test the
> code or even contribute patches.


Yeah, Git is much better than CVS, however, I've got nowhere to host a 
public Git repository.  If someone were to offer hosting I'd be only too 
happy to move over to Git.

Phillip
