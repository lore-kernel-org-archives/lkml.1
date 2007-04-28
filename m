Return-Path: <linux-kernel-owner+w=401wt.eu-S1753865AbXD1LEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbXD1LEZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 07:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753967AbXD1LEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 07:04:25 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:21865 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865AbXD1LEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 07:04:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=O0st7RqjFhZweDWElCEai46PjZeRu4i9Trgrk+WCI8+F2otr+vmJvMXxNhWX0omLMiaiL8o+n43FSIcsEqO+Go+pQOvn6SScCZyqTvWer+VefL9qesU4n7XeaaVuOAV3H1W3+GwqfH5V6epYf4pU/7tZeXJ7tqzdSgFBdKQHJY8=
Date: Sat, 28 Apr 2007 19:58:38 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, William Irwin <wli@holomorphy.com>
Subject: Re: [PATCH] hugetlbfs: fix error path in module_init
Message-ID: <20070428105838.GA3792@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
	William Irwin <wli@holomorphy.com>
References: <20070428071923.GB9545@APFDCB5C> <b6fcc0a0704280044i3ff820b6w343bd73c7a08f708@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6fcc0a0704280044i3ff820b6w343bd73c7a08f708@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2007 at 11:44:43AM +0400, Alexey Dobriyan wrote:
> On 4/28/07, Akinobu Mita <akinobu.mita@gmail.com> wrote:
> >init_hugetlbfs_fs() needs to unregister hugetlbfs
> >when kern_mount() returns error.
> 
> HUGETLBFS is bool, so __init function should panic more and
> __exit function should be removed. Or someone is planning
> making it tristate?

Seems reasonable to make it panic. Because hugetlbfs_vfsmount
is not initialized when error happen, and shmget() (ipc/shm.c)
can cause NULL pointer dereference by hugetlb_zero_setup().

Or we can add NULL check for hugetlbfs_vfsmount in hugetlbfs_vfsmount().

