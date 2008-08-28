Return-Path: <linux-kernel-owner+w=401wt.eu-S1755408AbYH1SOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbYH1SOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 14:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753498AbYH1SOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 14:14:09 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:53925 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbYH1SOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 14:14:08 -0400
To: tj@kernel.org
CC: greg@kroah.com, fuse-devel@lists.sourceforge.net, miklos@szeredi.hu,
       linux-kernel@vger.kernel.org
In-reply-to: <48B6E801.9080102@kernel.org> (message from Tejun Heo on Thu, 28
	Aug 2008 20:01:37 +0200)
Subject: Re: [PATCH 5/7] FUSE: implement ioctl support
References: <1219945263-21074-1-git-send-email-tj@kernel.org> <1219945263-21074-6-git-send-email-tj@kernel.org> <20080828175116.GB18461@kroah.com> <48B6E79E.6020702@kernel.org> <48B6E801.9080102@kernel.org>
Message-Id: <E1KYm0D-0003q0-IQ@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 28 Aug 2008 20:13:49 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2008, Tejun Heo wrote:
> Tejun Heo wrote:
> > Greg KH wrote:
> >> Why do we need ioctls?  For CUSE?  In that case, would we need to copy
> >> the memory from userspace, into the kernel, and then back out into
> >> userspace again?  Can't we just have a "pass-through" type fixed ioctl
> >> instead?
> > 
> > Can you elaborate a bit?  How the fixed ioctl would know how much to
> > copy in and out and from where?
> 
> If you're worried about the double copying due to performance reasons,
> what we can do is implementing userspace to userspace copying.  I just
> took easier path of copying twice as u-u copy can't be done using the
> existing FUSE mechanics.

How about not copying anything in the kernel, just passing the virtual
address to the filesystem?  It can get/modify the data of the calling
task by mapping /proc/pid/mem.  Ugly, yes, but ioctls are inherently
ugly.

Miklos
