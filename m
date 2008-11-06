Return-Path: <linux-kernel-owner+w=401wt.eu-S1752315AbYKFRcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315AbYKFRcw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 12:32:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751350AbYKFRcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 12:32:32 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50673 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbYKFRcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 12:32:31 -0500
Date: Thu, 6 Nov 2008 12:32:24 -0500
From: Christoph Hellwig <hch@infradead.org>
To: "J.R. Mauro" <jrm8005@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>, Greg KH <greg@kroah.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       "William L. Irwin" <wli@holomorphy.com>, sparclinux@vger.kernel.org
Subject: Re: sparc/staging compile error
Message-ID: <20081106173224.GA25767@infradead.org>
References: <20081106163626.2306ad75.sfr@canb.auug.org.au> <20081106063709.GB7728@kroah.com> <18706.51153.342079.586525@cargo.ozlabs.ibm.com> <3aaafc130811060606p1dfbf12cr8c0dc8cd310d0279@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3aaafc130811060606p1dfbf12cr8c0dc8cd310d0279@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 09:06:36AM -0500, J.R. Mauro wrote:
> static int poch_ioctl(struct inode *inode, struct file *filp,
>                       unsigned int cmd, unsigned long arg)
> {
> /* ---snip---*/
>         case POCH_IOC_SYNC_GROUP_FOR_USER:
>         case POCH_IOC_SYNC_GROUP_FOR_DEVICE:
>                 vms = find_vma(current->mm, arg);
>                 if (!vms)
>                         /* Address not mapped. */
>                         return -EINVAL;
>                 if (vms->vm_file != filp)
>                         /* Address mapped from different device/file. */
>                         return -EINVAL;
> 
>                 flush_cache_range(vms, arg, arg + channel->group_size);

This doesn't look like something a driver should ever do.  Could someone
explain what it's trying to do from a high level point of view?

