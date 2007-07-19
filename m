Return-Path: <linux-kernel-owner+w=401wt.eu-S939498AbXGSQqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939498AbXGSQqQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 12:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764386AbXGSQqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 12:46:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52057 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764106AbXGSQp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 12:45:59 -0400
Date: Thu, 19 Jul 2007 12:39:15 -0400
From: Don Zickus <dzickus@redhat.com>
To: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
Cc: vgoyal@in.ibm.com, Neil Horman <nhorman@redhat.com>,
       Bernhard Walle <bwalle@suse.de>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, Dan Aloni <da-x@monatomic.org>
Subject: Re: Determine version of kernel that produced vmcore
Message-ID: <20070719163915.GN9623@redhat.com>
References: <20070716123633.GA10920@in.ibm.com> <20070718230740oomichi@mail.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070718230740oomichi@mail.jp.nec.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2007 at 11:07:40PM +0900, Ken'ichi Ohmichi wrote:
> The content of mkdfinfo file has been increasing whenever adding
> features and correcting bugs. The content is increasing even now.
> And, the feature addition is done not only for new kernels but also
> for old upstream kernels. When the content of mkdfinfo file is taken 
> into the kernel and fixed, the feature addition in the future is
> remarkably limited. So makedumpfile needs mkdfinfo file outside of
> the kernel.
> 
> I propose the solution including Dan's, Vivek's and Bernhard's opinions.
> How about the following sequence for distributors ?
> (It is not necessary to rebuild 2nd-kernel initrd even if 1st-kernel changes.
>  A new option "--mkdfinfo" is added to kexec command.)
> 
> * On the kernel building system
>   1. Create the kernel files.
>      # cd linux-2.6.xx
>      # make
>   2. Create the mkdfinfo file from the vmlinux.
>      # makedumpfile -g mkdfinfo-2.6.xx -x vmlinux

I am not a big fan of this approach as it forces distros to require
kexec-tools when building a kernel.  Even Joe Hacker who wants a custom
kernel (and not interested in kexec) would have to not only download the
kernel.src.rpm but kexec-tools just to build a kernel that probably
doesn't have kexec enabled.

I had to deal with a similar experience when providing a build dependency
on the unifdef package when create the kernel-headers rpm for RHEL-5.  A
lot of people were confused and upset by this dependency.  Luckily
upstream resolved this by just putting similar code in the kernel/scripts
directory and thus removing the dependency (well not for RHEL-5).  I would
rather not have to deal with this again unless I know there is a more
permanent solution that would remove this dependency.

After talking to Dave Anderson about this more, I start to understand why
Ken'ichi prefers to implement the new features in userspace instead of the
kernel (it makes things automatically work with older kernels), but I
still am not a big fan of it.  I was hoping for a complete in kernel
solution (that way you never need the vmlinux file).  Perhaps makedumpfile
can support both vmlinux files (if provided) or interface with the kernel
(if the vmlinux is not provided?).

Just my input.  I might as well argue with Ken'ichi here than the
bugzilla. :-)

Cheers,
Don
