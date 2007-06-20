Return-Path: <linux-kernel-owner+w=401wt.eu-S1755656AbXFTWZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656AbXFTWZU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 18:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752385AbXFTWZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 18:25:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168AbXFTWZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 18:25:04 -0400
Date: Thu, 21 Jun 2007 00:24:37 +0200
From: Karel Zak <kzak@redhat.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
Subject: Re: Adding subroot information to /proc/mounts, or obtaining that through other means
Message-ID: <20070620222437.GY7226@petra.dvoda.cz>
References: <467994BD.6000403@zytor.com> <20070620210343.GQ21478@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070620210343.GQ21478@ftp.linux.org.uk>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2007 at 10:03:43PM +0100, Al Viro wrote:
> On Wed, Jun 20, 2007 at 01:57:33PM -0700, H. Peter Anvin wrote:
> > ... or, alternatively, add a subfield to the first field (which would
> > entail escaping whatever separator we choose):
> > 
> > /dev/md6 /export ext3 rw,data=ordered 0 0
> > /dev/md6:/users/foo /home/foo ext3 rw,data=ordered 0 0
> > /dev/md6:/users/bar /home/bar ext3 rw,data=ordered 0 0
> 
> Hell, no.  The first field is in principle impossible to parse unless
> you know the fs type.
> 
> How about making a new file with sane format?  From the very
> beginning.  E.g. mountpoint + ID + relative path + type + options,
> where ID uniquely identifies superblock (e.g. numeric st_dev)
> and backing device (if any) is sitting among the options...

 Yeah. How about include propagation trees to this file?

 mountpoint + ID + relative path + type + options + propagation-flag +
 {peer,master}-mount-id

 / 0xa917800 / ext3 rw PRIVATE
 /mnt 0xa917100 / ext3 rw SHARED peer:0xa917100
 /tmp 0xa917f00 /1 ext3 rw SLAVE master:0xa917100



    Karel


-- 
 Karel Zak  <kzak@redhat.com>
