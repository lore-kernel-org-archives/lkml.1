Return-Path: <linux-kernel-owner+w=401wt.eu-S1753123AbYJUX5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbYJUX5Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 19:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbYJUX5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 19:57:13 -0400
Received: from zombie2.ncsc.mil ([144.51.88.133]:35975 "EHLO zombie2.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070AbYJUX5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 19:57:11 -0400
Subject: Re: Subject: [PATCH 00/16] Squashfs:
	compressed	read-only	filesystem
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       tim.bird@am.sony.com
In-Reply-To: <48FE68E9.2020401@lougher.demon.co.uk>
References: <E1KqrTW-0001x8-3h@dylan>
	 <1224268027.18940.78.camel@moss-terrapins.epoch.ncsc.mil>
	 <48FD2C74.2070608@lougher.demon.co.uk>
	 <1224605348.31157.67.camel@moss-terrapins.epoch.ncsc.mil>
	 <48FE68E9.2020401@lougher.demon.co.uk>
Content-Type: text/plain
Date: Tue, 21 Oct 2008 19:36:59 -0400
Message-Id: <1224632219.31157.91.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-22 at 00:42 +0100, Phillip Lougher wrote:
> David P. Quigley wrote:
> 
> > 
> > Looking through the code I noticed that you give certain object types
> > the same inode number for all instances of it (devices, fifo/sockets).
> > How is this done internally? Do these types of objects occupy the same
> > position on the inode table? If so how do you differentiate between a
> > device and a socket?
> > 
> 
> No, devices and fifo/sockets get their own unique inode numbers:
> 
> root@slackware:/mnt# mount -t squashfs test.sqsh /mnt2 -o loop
> root@slackware:/mnt# ls -li /mnt2
> total 0
> 2 crw-r--r-- 1 root root 1, 1 2008-10-22 00:31 device
> 4 prw-r--r-- 1 root root    0 2008-10-22 00:31 fifo
> 3 srwxr-xr-x 1 root root    0 2008-10-17 16:25 socket
[Snip]
	My mistake I misread your statement in email 0. You said that squashfs
has real inode numbers and that cramfs didn't. Good luck with your
mainlining attempt. Once you get xattr support this would definitely
make life better for people who want to make SELinux enabled LiveCDs and
other small devices.

Dave

