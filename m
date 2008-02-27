Return-Path: <linux-kernel-owner+w=401wt.eu-S932411AbYB0XnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411AbYB0XnX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 18:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760714AbYB0XnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 18:43:00 -0500
Received: from sj-iport-3.cisco.com ([171.71.176.72]:3185 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760061AbYB0Xm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 18:42:58 -0500
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH/RFC 1/2] anon-inodes: Remove fd_install() from anon_inode_getfd()
X-Message-Flag: Warning: May contain useful information
References: <20080225191043.GA32342@lst.de> <adak5kqyzv1.fsf@cisco.com>
	<Pine.LNX.4.64.0802271138170.377@alien.or.mcafeemobile.com>
	<adabq62yx5r.fsf@cisco.com>
	<Pine.LNX.4.64.0802271218210.377@alien.or.mcafeemobile.com>
	<ada7igqyurw.fsf@cisco.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 27 Feb 2008 15:42:42 -0800
In-Reply-To: <ada7igqyurw.fsf@cisco.com> (Roland Dreier's message of "Wed, 27 Feb 2008 13:05:55 -0800")
Message-ID: <adar6eyx8y5.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 27 Feb 2008 23:42:42.0550 (UTC) FILETIME=[720DF160:01C8799A]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > http://git.kernel.org/?p=linux/kernel/git/viro/vfs-2.6.git;a=commit;h=49be4f8114e6ff0efdab10ebba2493fb67bc3034

Actually, looking closer at the kvm changes here, I think that
create_vcpu_fd() needs the same treatment as kvm_dev_ioctl_create_vm()
gets in the patch because of the race I mentioned in the changelog
for my patch: otherwise kvm_vcpu_release() could drop the last
reference to vcpu->kvm->filp before the get_file() gets an extra
reference.

I'm beginning to think that moving the fd_install() out of
anon_inode_getfd() really is worth it to make a safer interface.

 - R.
