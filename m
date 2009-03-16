Return-Path: <linux-kernel-owner+w=401wt.eu-S1756563AbZCPQfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563AbZCPQfG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 12:35:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbZCPQez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 12:34:55 -0400
Received: from xylophone.i-cable.com ([203.83.115.99]:41761 "HELO
	xylophone.i-cable.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752706AbZCPQey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 12:34:54 -0400
X-Greylist: delayed 436 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Mar 2009 12:34:53 EDT
Date: Tue, 17 Mar 2009 00:27:20 +0800
From: Zhang Le <r0bertz@gentoo.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, torvalds@osdl.org, alan@redhat.com
Subject: Re: [PATCH] filp->f_pos not correctly updated in proc_task_readdir
Message-ID: <20090316162719.GA7548@adriano.hkcable.com.hk>
References: <1237185871-3343-1-git-send-email-r0bertz@gentoo.org> <20090316083457.GV28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090316083457.GV28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08:34 Mon 16 Mar     , Al Viro wrote:
> On Mon, Mar 16, 2009 at 02:44:31PM +0800, Zhang Le wrote:
> > filp->f_pos only get updated at the end of the function. Thus d_off of those
> > dirents who are in the middle will be 0, and this will cause a problem in
> > glibc's readdir implementation, specifically endless loop. Because when overflow
> > occurs, f_pos will be set to next dirent to read, however it will be 0, unless
> > the next one is the last one. So it will start over again and again.
> 
> Eh...  Here's what's really going on:
> 
> proc_..._fill_cache() API is rather kludgy and far too convoluted.  In
> particular, it calls filldir() and passes file->f_pos to it, expecting
> the caller to update file->f_pos between the calls.  proc_task_readdir()
> uses that sucker, but doesn't update ->f_pos until the very end.  As
> the result, d_off of direntries produced by it gets screwed.
> Broken-by: commit 61a28784028e6d55755e4d0f39bee8d9bf2ee8d9
> Author: Eric W. Biederman <ebiederm@xmission.com>
> Date:   Mon Oct 2 02:18:49 2006 -0700
> 
>     [PATCH] proc: Remove the hard coded inode numbers
> 

Thanks for sharing the insights.

> Patch is fine, but I'd rather rip the layers of ..._fill_cache() abstractions
> out and see what falls out.  Anyway, for -rc your variant is definitely the
> way to go.

So, will you take care of it? Or who else should I ask? Thanks in advance!

Zhang, Le
http://zhangle.is-a-geek.org
