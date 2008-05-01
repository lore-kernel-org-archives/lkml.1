Return-Path: <linux-kernel-owner+w=401wt.eu-S1765085AbYEATxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765085AbYEATxV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 15:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762083AbYEATxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 15:53:04 -0400
Received: from mylar.outflux.net ([69.93.193.226]:33799 "EHLO
	mylar.outflux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760239AbYEATxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 15:53:02 -0400
Date: Thu, 1 May 2008 12:51:52 -0700
From: Kees Cook <kees@canonical.com>
To: John Johansen <jjohansen@suse.de>
Cc: Chris Mason <chris.mason@oracle.com>, jeffschroeder@computer.org,
       linux-fsdevel@vger.kernel.org, kernel-team@lists.ubuntu.com,
       linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
       Tim Gardner <tim.gardner@canonical.com>
Subject: Re: Btrfs v0.14 Released
Message-ID: <20080501195152.GM12850@outflux.net>
References: <200804291601.32945.chris.mason@oracle.com> <c24352ca0805010939q31f743aev17cc7f98d2ad0c71@mail.gmail.com> <481A14BA.9090305@canonical.com> <200805011517.55698.chris.mason@oracle.com> <481A1BB9.8050109@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <481A1BB9.8050109@canonical.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, May 01, 2008 at 01:36:25PM -0600, Tim Gardner wrote:
> Chris Mason wrote:
> > On Thursday 01 May 2008, Tim Gardner wrote:
> > 
> > [ btrfs oops on ubuntu ]
> > 
> >>>>  This is because ubuntu kernels ship with apparmor, you'll need this
> >>>> patch:
> >>>>
> >>>>  If there is a #ifdef IM_A_UBUNTU_KERNEL I can use, I'll do it.  Jeff
> >>>> Mahoney has a similar patch for SUSE that I've been meaning to merge,
> >>>> but I wanted to lookup some way to check for ubuntu as well.
> >>>>
> >>>>  -chris
> >>>>
> >>>>  diff -r e7da2489b19b file.c
> >>>>  --- a/file.c    Wed Apr 30 13:59:35 2008 -0400
> >>>>  +++ b/file.c    Thu May 01 12:25:11 2008 -0400
> >>>>  @@ -852,7 +852,7 @@ static ssize_t btrfs_file_write(struct f
> >>>>                 goto out_nolock;
> >>>>         if (count == 0)
> >>>>                 goto out_nolock;
> >>>>  -       err = remove_suid(fdentry(file));
> >>>>  +       err = remove_suid(&file->f_path);
> >>>>         if (err)
> >>>>                 goto out_nolock;
> >>>>         file_update_time(file);
> >> Couldn't you #ifdef based on CONFIG_SECURITY_APPARMOR ? This ought to
> >> work for Hardy. However the next development kernel (Intrepid) does not
> >> have the APPARMOR patches, so just knowing that its an UBUNTU kernel is
> >> not specific enough.
> > 
> > I've been assuming the apparmor patches change remove_suid even when they are 
> > not enabled in the config.
> > 
> > -chris
> > 
> 
> Lets get Kees involved. He developed the patch set for Hardy. I would
> hope that if CONFIG_SECURITY_APPARMOR=n then the source would default to
> its normal state.

I can't claim to have developed the patches, only helping coordinate
their merging into Ubuntu.  John Johansen is the real person we should
check with -- he did all the heavy lifting -- now added to discussion.
(Hi John!)

-Kees

-- 
Kees Cook
Ubuntu Security Team
