Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753247AbYLRUGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbYLRUGV (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 15:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751442AbYLRUGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 15:06:06 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:31461 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbYLRUGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 15:06:05 -0500
Subject: Re: sshd segmentation fault on ia64 on 28-rc7-mmotm-081203
	-	bisected
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Franck Bui-Huu <vagabon.xyz@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <494AAA5C.6060601@gmail.com>
References: <1228322600.6693.61.camel@lts-notebook>
	 <1228940487.6139.68.camel@lts-notebook>  <494AAA5C.6060601@gmail.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Thu, 18 Dec 2008 15:05:44 -0500
Message-Id: <1229630744.6667.3.camel@lts-notebook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-12-18 at 20:54 +0100, Franck Bui-Huu wrote:
> Hello,
> 
> [ Sorry for the late reply ]
> 
> Lee Schermerhorn wrote:
> > On Wed, 2008-12-03 at 11:43 -0500, Lee Schermerhorn wrote:
> >> I couldn't find anything on the list about this.
> >>
> >> I've built and booted 28-rc7-mmotm-081203 on both x86_64 and ia64.  I
> >> can ssh into the x86_64 platform fine.  On the ia64, I'm seeing sshd
> >> [from RHEL5 distro] seg faulting.  [Same sshd worked on the
> >> 28-rc6-mmotm-081201 kernel.]
> >>
> >> Has anyone else seen this?
> >>
> > 
> > I finally got around to bisecting this--sshd fails with SEGV on ia64--on
> > mmotm-081208.  It appears to be caused by the patch duo:
> > 
> > do_mpage_readpage-remove-first_logical_block-parameter.patch
> > do_mpage_readpage-remove-first_logical_block-parameter-fix.patch
> 
> Unfortunately I don't see why this patch causes such breakage.
> 
> Could you apply the following patch with the previous patch applied
> and see if sshd still segfaults ?
> 
> It basically reverts:
> 
>    do_mpage_readpage-remove-first_logical_block-parameter-fix.patch
> 
> Therefore I can see which part of the patch is broken.

Will do, but I won't get to this before our lab shuts down for the rest
of the year.

> 
> Also can you tell me what the block size used by the file system
> hosting sshd ?

4K block size and fragment size, ext3.  system page size is 16K [ia64].

Lee

