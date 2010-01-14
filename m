Return-Path: <linux-kernel-owner+w=401wt.eu-S1754929Ab0ANDnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab0ANDnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 22:43:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753656Ab0ANDnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 22:43:15 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:39363 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab0ANDnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 22:43:15 -0500
Date: Thu, 14 Jan 2010 03:43:10 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
       Dustin Kirkland <kirkland@canonical.com>,
       ecryptfs-devel@lists.launchpad.net, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] ecryptfs: Fix refcnt leak on ecryptfs_follow_link()
	error path
Message-ID: <20100114034310.GG19799@ZenIV.linux.org.uk>
References: <87my0kjxpd.fsf@devron.myhome.or.jp> <20100113194458.GB4673@ZenIV.linux.org.uk> <87tyupfjk2.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tyupfjk2.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 14, 2010 at 12:32:13PM +0900, OGAWA Hirofumi wrote:
> Al Viro <viro@ZenIV.linux.org.uk> writes:
> 
> > On Tue, Jan 12, 2010 at 03:36:14AM +0900, OGAWA Hirofumi wrote:
> >> 
> >> If ->follow_link handler return the error, it should decrement
> >> nd->path refcnt. But, ecryptfs_follow_link() doesn't decrement.
> >> 
> >> This patch fix it by using usual nd_set_link() style error handling,
> >> instead of playing with nd->path.
> >
> > Applied.
> 
> Sigh, sorry. I introduced new bug by this patch. Please apply this too.

I'll fold it.  BTW, while we are at it, there's a leak in configfs/symlink.c
get_target() as well ;-/
