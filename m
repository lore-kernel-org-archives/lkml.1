Return-Path: <linux-kernel-owner+w=401wt.eu-S1755965AbYCKU4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbYCKU4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 16:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbYCKU4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 16:56:13 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:42091 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbYCKU4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 16:56:12 -0400
Date: Tue, 11 Mar 2008 13:41:54 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Akinobu Mita <akinobu.mita@gmail.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, William Irwin <wli@holomorphy.com>,
       Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 4/5] shmem: use call_once()
In-Reply-To: <961aa3350803110529o61fe42e8q27ab10e0cb8f9bb6@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0803111323130.18261@blonde.site>
References: <20080310145704.GA6396@APFDCB5C> <20080310150026.GA6407@APFDCB5C>
  <20080310150148.GB6407@APFDCB5C> <20080310150308.GC6407@APFDCB5C> 
 <Pine.LNX.4.64.0803102211240.6396@blonde.site>
 <961aa3350803110529o61fe42e8q27ab10e0cb8f9bb6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2008, Akinobu Mita wrote:
> 2008/3/11, Hugh Dickins <hugh@veritas.com>:
> > On Tue, 11 Mar 2008, Akinobu Mita wrote:
> >  > This patch defers mounting tmpfs till shmem_file_setup() is
> >  > called first time by using call_once().
> >
> > Please explain why we might need this patch: is something changing
> >  elsewhere?  Or are you misled by that "module_init(init_tmpfs)"
> >  into thinking that mm/shmem.c is sometimes built modular?
> 
> If no processes call shmem_file_setup() (via shm_get(2)), it is unnecessary
                                       or shmem_zero_setup, not very common
> to do vfs_kern_mount(&tmpfs_fs_type, ...) unconditionary in boot-time.
> So I thought it is suitable example to demonstrate how to use "call_once()"
> in this patch set.

Oh, I see, thanks.  Well, I don't feel all that strongly about it; but
on the whole I'd prefer we leave it as part of the __init, than change
it around to provide this example (and risk introducing some weird issue
e.g. related to its "dev"?).  I guess the same should go for the huge
and the tiny, whereas you have better justification in the idr case.
Call me over-cautious.

Hugh
