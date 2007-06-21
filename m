Return-Path: <linux-kernel-owner+w=401wt.eu-S1759205AbXFURgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759205AbXFURgV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 13:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756402AbXFURgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 13:36:07 -0400
Received: from terminus.zytor.com ([192.83.249.54]:48577 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878AbXFURgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 13:36:05 -0400
Message-ID: <467AB5EE.3030909@zytor.com>
Date: Thu, 21 Jun 2007 10:31:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Ram Pai <linuxram@us.ibm.com>
CC: Al Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
Subject: Re: Adding subroot information to /proc/mounts, or obtaining that
 through other means
References: <467994BD.6000403@zytor.com>	 <20070620210343.GQ21478@ftp.linux.org.uk>  <46799A31.10301@zytor.com> <1182442837.3342.13.camel@ram.us.ibm.com>
In-Reply-To: <1182442837.3342.13.camel@ram.us.ibm.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ram Pai wrote:
> 
> Peter, I am not working on it currently. But i am interested in getting
> it done. I have the seed set of patches which had Al Viro's ideas
> incorporated. Infact those patches were sent on lkml 2 months back.
> Shall we start with those patches?
> 

Okay, so what I see in your patches are:

> > path-from-root: mount point of the mount from /
> > path-from-root-of-its-sb: path from its own root dentry.
> > propagation-flag: SHARED, SLAVE, UNBINDABLE, PRIVATE
> > peer-mount-id: the mount-id of its peer mount (if this mount is shared)
> > master-mount-id: the mount-id of its master mount (if this mount is
slave)

Other than cosmetic, I don't see anything terribly wrong with this,
although getting a flag when the directory is overmounted would be nice.

I guess I suggest a single comma-separated field with flags and optional
":argument":

	private
	shared:<peer>
	slave:<master>
	unbindable
	overmounted

So we could end up with something like:

rootfs / rootfs rw 0 0 0:1 / 1 private,overmounted

... where 1 is the mnt_id (sequence number).

[Please see my other comments in this thread... basically I believe we
should just add fields to /proc/mounts.]

	-hpa
