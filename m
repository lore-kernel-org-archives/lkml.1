Return-Path: <linux-kernel-owner+w=401wt.eu-S1764397AbXKQTTC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764397AbXKQTTC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 14:19:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759853AbXKQTSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 14:18:52 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:3735 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759456AbXKQTSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 14:18:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZtOtxSL3hYiq7HsWAJyMHe1bZ4JzXJ1gaKNXqO6aPT0xTByxtPr2gNM8VDLNz1CPEGVevIF5Nc5pXSCPxX9Z9Av2NDr+cHGCAG2nRa8hjbm19CdEQu6nf3wM20Ytns5PBZopH6lzPhQzCr/vrs7udw0PF5uioIWehCmIJvvg2Js=
Message-ID: <64bb37e0711171118t73a7c619p1117a5b150f369b7@mail.gmail.com>
Date: Sat, 17 Nov 2007 20:18:49 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Trond Myklebust" <trond.myklebust@fys.uio.no>
Subject: Re: [BUG] 2.6.24-rc2-mm1 - kernel bug on nfs v4
Cc: "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       nfs@lists.sourceforge.net, "Andy Whitcroft" <apw@shadowen.org>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "Jan Blunck" <jblunck@suse.de>
In-Reply-To: <1195325920.7484.1.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <473DA608.1020804@linux.vnet.ibm.com>
	 <64bb37e0711170953p67d1be49lf4eaa190d662e2b4@mail.gmail.com>
	 <1195325920.7484.1.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 17, 2007 7:58 PM, Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
>
> On Sat, 2007-11-17 at 18:53 +0100, Torsten Kaiser wrote:
> > On Nov 16, 2007 3:15 PM, Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> > > Hi Andrew,
> > >
> > > The kernel enters the xmon state while running the file system
> > > stress on nfs v4 mounted partition.
> > [snip]
> > > 0:mon> t
> > > [c0000000dbd4fb50] c000000000069768 .__wake_up+0x54/0x88
> > > [c0000000dbd4fc00] d00000000086b890 .nfs_sb_deactive+0x44/0x58 [nfs]
> > > [c0000000dbd4fc80] d000000000872658 .nfs_free_unlinkdata+0x2c/0x74 [nfs]
> > > [c0000000dbd4fd10] d000000000598510 .rpc_release_calldata+0x50/0x74 [sunrpc]
> > > [c0000000dbd4fda0] c00000000008d960 .run_workqueue+0x10c/0x1f4
> > > [c0000000dbd4fe50] c00000000008ec70 .worker_thread+0x118/0x138
> > > [c0000000dbd4ff00] c0000000000939f4 .kthread+0x78/0xc4
> > > [c0000000dbd4ff90] c00000000002b060 .kernel_thread+0x4c/0x68
>
> Could you try with the attached patch.
[snip]
> Fix is to move the call to nfs_sb_deactive() into
> nfs_async_unlink_release().

I realley doubt that will fix it.

My stacktrace was like:
run_workqueue
called: rpc_async_schedule
  that called: rpc_release_calldata
    which points to: nfs_async_unlink_release
       that called: nfs_free_unlinkdata

So it does not matter for me if nfs_sb_deactive is called one step earlier.

Currently building with SLAB instead SLUB to see if lockdep tells something...

Torsten
