Return-Path: <linux-kernel-owner+w=401wt.eu-S1760563AbXHKLTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760563AbXHKLTq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 07:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756980AbXHKLTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 07:19:39 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:43211 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756710AbXHKLTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 07:19:38 -0400
Date: Sat, 11 Aug 2007 15:22:00 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Christoph Hellwig <hch@infradead.org>, xemul@openvz.org, akpm@osdl.org,
       devel@openvz.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, sukadev@us.ibm.com
Subject: Re: [PATCH 3/20] Introduce MS_KERNMOUNT flag
Message-ID: <20070811112200.GA121@tv-sign.ru>
References: <46BC506B.mailGIV1AXDXM@openvz.org> <20070811034721.GB22216@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070811034721.GB22216@infradead.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11, Christoph Hellwig wrote:
>
> On Fri, Aug 10, 2007 at 03:47:55PM +0400, xemul@openvz.org wrote:
> > This flag tells the .get_sb callback that this is a kern_mount() call
> > so that it can trust *data pointer to be valid in-kernel one. If this
> > flag is passed from the user process, it is cleared since the *data
> > pointer is not a valid kernel object.
> > 
> > Running a few steps forward - this will be needed for proc to create the
> > superblock and store a valid pid namespace on it during the namespace
> > creation. The reason, why the namespace cannot live without proc mount
> > is described in the appropriate patch.
> 
> I don't like this at all.  We should never pass kernel and userspace
> addresses through the same pointer.  Maybe add an additional argument
> to the get_sb prototype instead.  But this whole idea of mounting /proc
> from kernelspace sounds like a really bad idea to me.  /proc should
> never be mounted from the kernel but always normally from userspace.

Can't comment because I don't understand vfs at all, and perhaps I just
misunderstood you.

But could you clarify? We already create internal proc mount from kernel
space, proc_root_init() does this. With this series we are doing the same
when a new namespace is created.

Thanks,

Oleg.

