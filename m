Return-Path: <linux-kernel-owner+w=401wt.eu-S1759383AbXGEKDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759383AbXGEKDL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 06:03:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754278AbXGEKDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 06:03:00 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:46197 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191AbXGEKDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 06:03:00 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Thu, 5 Jul 2007 12:02:58 +0200
User-Agent: KMail/1.9.7
Cc: paulus@samba.org, stern@rowland.harvard.edu, johannes@sipsolutions.net,
       rjw@sisk.pl, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, pavel@ucw.cz, mjg59@srcf.ucam.org,
       benh@kernel.crashing.org
References: <18059.10554.955290.148535@cargo.ozlabs.ibm.com> <200707051048.46202.oliver@neukum.org> <E1I6NAH-00008t-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1I6NAH-00008t-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707051202.59375.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 5. Juli 2007 schrieb Miklos Szeredi:
> > > And teach VFS to block suspension, while waiting on a mutex held by
> > > another process performing a fuse operation.
> > > 
> > > I can already hear the beautiful praise from Al Viro at the sight of
> > > that ;)
> > 
> > There is that.
> > 
> > OK, bite the bullet. Tasks involved in fuse are special. Give them a flag
> > and teach the freezer to put them on ice only after all other task are
> > frozen. In a way they are kernel, there's no use denying that.
> 
> And flag every other process, that the flagged process is
> communicating with?  How are you proposing to do that?
> 
> Quoting Paul:
> 
> "1. The freezer cannot be guaranteed deadlock-free without constructing
>    a dependency graph between tasks (both user and kernel), which is
>    virtually impossible since the dependencies are not externally
>    observable."

A deadlock requires that the circular wait is uninterruptible. Normal IPC
isn't.

What are you doing in the userland portions of fuse? Some kind of IPC
with other tasks? There is a limit to which you can push kernel functionality
into user space.

	Regards
		Oliver

