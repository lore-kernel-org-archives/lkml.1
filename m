Return-Path: <linux-kernel-owner+w=401wt.eu-S1757072AbYCKM31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757072AbYCKM31 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 08:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753442AbYCKM3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 08:29:15 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:64034 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbYCKM3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 08:29:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=s/zY8r51D8Hu71vQO33STufJllp141L4epLm0HdvpFgLmxHOycRI5O8NG/bAJRbCa2EfemqX/C/TQpnUAVZ1TrKM3VYdQPUWKheFJ6MhdwoYiwvkimoQ3GczwVLjjiXOtxWUvRPlp0w5X+S1GYZh0V0T8fvFcdC2ZJzKjBhCs5o=
Message-ID: <961aa3350803110529o61fe42e8q27ab10e0cb8f9bb6@mail.gmail.com>
Date: Tue, 11 Mar 2008 21:29:11 +0900
From: "Akinobu Mita" <akinobu.mita@gmail.com>
To: "Hugh Dickins" <hugh@veritas.com>
Subject: Re: [PATCH 4/5] shmem: use call_once()
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0803102211240.6396@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080310145704.GA6396@APFDCB5C> <20080310150026.GA6407@APFDCB5C>
	 <20080310150148.GB6407@APFDCB5C> <20080310150308.GC6407@APFDCB5C>
	 <Pine.LNX.4.64.0803102211240.6396@blonde.site>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/3/11, Hugh Dickins <hugh@veritas.com>:
> On Tue, 11 Mar 2008, Akinobu Mita wrote:
>  > This patch defers mounting tmpfs till shmem_file_setup() is
>  > called first time by using call_once().
>
>
> Please explain why we might need this patch: is something changing
>  elsewhere?  Or are you misled by that "module_init(init_tmpfs)"
>  into thinking that mm/shmem.c is sometimes built modular?
>

If no processes call shmem_file_setup() (via shm_get(2)), it is unnecessary
to do vfs_kern_mount(&tmpfs_fs_type, ...) unconditionary in boot-time.
So I thought it is suitable example to demonstrate how to use "call_once()"
in this patch set.
