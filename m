Return-Path: <linux-kernel-owner+w=401wt.eu-S1755818AbXFTVDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818AbXFTVDx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 17:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbXFTVDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 17:03:45 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50566 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221AbXFTVDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 17:03:44 -0400
Date: Wed, 20 Jun 2007 22:03:43 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
Subject: Re: Adding subroot information to /proc/mounts, or obtaining that through other means
Message-ID: <20070620210343.GQ21478@ftp.linux.org.uk>
References: <467994BD.6000403@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <467994BD.6000403@zytor.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2007 at 01:57:33PM -0700, H. Peter Anvin wrote:
> ... or, alternatively, add a subfield to the first field (which would
> entail escaping whatever separator we choose):
> 
> /dev/md6 /export ext3 rw,data=ordered 0 0
> /dev/md6:/users/foo /home/foo ext3 rw,data=ordered 0 0
> /dev/md6:/users/bar /home/bar ext3 rw,data=ordered 0 0

Hell, no.  The first field is in principle impossible to parse unless
you know the fs type.

How about making a new file with sane format?  From the very
beginning.  E.g. mountpoint + ID + relative path + type + options,
where ID uniquely identifies superblock (e.g. numeric st_dev)
and backing device (if any) is sitting among the options...
