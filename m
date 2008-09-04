Return-Path: <linux-kernel-owner+w=401wt.eu-S1754671AbYIDTnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671AbYIDTnV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 15:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756627AbYIDTmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 15:42:55 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:52843 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053AbYIDTmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 15:42:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FZfumxUlqlM/VQX6W5N7ZdSy0lBFoMlOqYfKHb3jwn+SqUDvR5EVkH86iWDZ3EhC18
         /MeQ+sm5MCQj7LHVIC+/EOdJmVF/u1k6S+qhHyXVNgV+AkXLPXMdiuRYrDLu/HoTx3j2
         UMf4rypuB+xXUlTirZD/JwMDV07PkhNc/hVkQ=
Date: Thu, 4 Sep 2008 23:44:33 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Eric Valette <eric.valette@free.fr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: CD RW packet driver still oops in  2.6.27-rc5-git5
Message-ID: <20080904194433.GA3655@x200.localdomain>
References: <48C0316E.1030808@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C0316E.1030808@free.fr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2008 at 09:05:18PM +0200, Eric Valette wrote:
> pktcdvd: writer pktcdvd0 mapped to hdc
> ------------[ cut here ]------------
> WARNING: at /usr/src/linux-2.6.23.14/fs/sysfs/dir.c:463
> sysfs_add_one+0x27/0x2f()
> sysfs: duplicate filename '254:0' can not be created
> Modules linked in:
> Pid: 3848, comm: pktsetup Not tainted 2.6.27-rc5-git6 #68
>  [<c01189c1>] warn_slowpath+0x5a/0x7b
>  [<c0230ee0>] idr_get_empty_slot+0x154/0x202
>  [<c0230ee0>] idr_get_empty_slot+0x154/0x202
>  [<c023106d>] ida_get_new_above+0xdf/0x17b
>  [<c0189d7c>] sysfs_ilookup_test+0x0/0xd
>  [<c0165e2f>] ifind+0x15/0x7b
>  [<c0189f2f>] sysfs_find_dirent+0x13/0x23
>  [<c018a0a8>] sysfs_add_one+0x27/0x2f
>  [<c018abe3>] sysfs_do_create_link+0xa2/0xf6
>  [<c018ac47>] sysfs_create_link+0x7/0xc
>  [<c02ca902>] device_add+0x157/0x4fa
>  [<c02cad2d>] device_create_vargs+0x78/0x99
>  [<c02cad6c>] device_create+0x1e/0x22
>  [<c02d9844>] pkt_setup_dev+0x2ea/0x3d7
>  [<c0185801>] show_stat+0x140/0x4fd
>  [<c02d99b2>] pkt_ctl_ioctl+0x81/0x192
>  [<c015f6f5>] vfs_ioctl+0x49/0x5f
>  [<c015f92c>] do_vfs_ioctl+0x221/0x234
>  [<c015f96b>] sys_ioctl+0x2c/0x45
>  [<c0102c39>] sysenter_do_call+0x12/0x25
>  [<c0185801>] show_stat+0x140/0x4fd

This is not an oops as in oops, just sysfs tells that duplicate file
won't be created. Needs fixing, regardless.

