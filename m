Return-Path: <linux-kernel-owner+w=401wt.eu-S1758186AbYB1Hwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186AbYB1Hwg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 02:52:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753000AbYB1Hw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 02:52:27 -0500
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:52170
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbYB1Hw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 02:52:27 -0500
Message-ID: <47C66839.7080607@qumranet.com>
Date: Thu, 28 Feb 2008 09:52:25 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Davide Libenzi <davidel@xmailserver.org>, Christoph Hellwig <hch@lst.de>,
       linux-fsdevel@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kvm-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH/RFC 1/2] anon-inodes: Remove fd_install() from anon_inode_getfd()
References: <20080225191043.GA32342@lst.de> <adak5kqyzv1.fsf@cisco.com>	<Pine.LNX.4.64.0802271138170.377@alien.or.mcafeemobile.com>	<adabq62yx5r.fsf@cisco.com>	<Pine.LNX.4.64.0802271218210.377@alien.or.mcafeemobile.com>	<ada7igqyurw.fsf@cisco.com> <adar6eyx8y5.fsf@cisco.com>
In-Reply-To: <adar6eyx8y5.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
>  > http://git.kernel.org/?p=linux/kernel/git/viro/vfs-2.6.git;a=commit;h=49be4f8114e6ff0efdab10ebba2493fb67bc3034
>
> Actually, looking closer at the kvm changes here, I think that
> create_vcpu_fd() needs the same treatment as kvm_dev_ioctl_create_vm()
> gets in the patch because of the race I mentioned in the changelog
> for my patch: otherwise kvm_vcpu_release() could drop the last
> reference to vcpu->kvm->filp before the get_file() gets an extra
> reference.
>
> I'm beginning to think that moving the fd_install() out of
> anon_inode_getfd() really is worth it to make a safer interface.
>   

It makes is less usable, though (since the last step needs to be taken 
by the caller.

We might add a int (*prepare_file)(...) parameter which 
anon_inode_getfd() uses to munge the file before installing it.

-- 
error compiling committee.c: too many arguments to function

