Return-Path: <linux-kernel-owner+w=401wt.eu-S1760844AbXHMW2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760844AbXHMW2F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 18:28:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753000AbXHMW1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 18:27:45 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:23352 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbXHMW1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 18:27:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Wf5AlMSs8MNd3Qj7AvD8ySfyYoV+jd3Kn13bn8+5o0Zi7JQ6npSA7vbx3LXaRG2LJlF2GCKlgC/vVkYI2XXngyxLrVExyfOFVPkIYbWX+3tB6JVbfiBUk5bap0M4Ua28LcVe7SApqr6ZX/dPPWjq2VV5waUDCB9HWFOZ6xhTw5M=
Message-ID: <f9d2a5e10708131527j6081875gf9708fde7fce674@mail.gmail.com>
Date: Mon, 13 Aug 2007 15:27:37 -0700
From: "Russ Dill" <russ.dill@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: Process stuck in md_wakeup_thread
Cc: linux-kernel@vger.kernel.org, "Neil Brown" <neilb@suse.de>
In-Reply-To: <20070812012305.1c717196.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <loom.20070811T042748-157@post.gmane.org>
	 <20070812012305.1c717196.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/12/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Sat, 11 Aug 2007 02:34:34 +0000 (UTC) Russ Dill <Russ.Dill@gmail.com> wrote:
>
> > On 2.6.22 from debian (stock), I have a process (dpkg) stuck with the following
> > calltrace:
> >
> > SysRq : Show Blocked State
> >
> >                          free                        sibling
> >   task             PC    stack   pid father child younger older
> > dpkg          D 00000003     0 26040  20765 (NOTLB)
> >        e57d5e30 00200082 00000000 00000003 dfc48ba8 00000000 dfc48ba8 00000000
> >        00000007 e0af45c0 e8ce17aa 0002827f 00051ec2 e0af46cc c1809980 00000000
> >        e8ce1324 0002827f 00200082 f881cd4c 00200286 f8ba2c85 c1809980 e57d5e60
> > Call Trace:
> >  [<f881cd4c>] md_wakeup_thread+0x26/0x28 [md_mod]
> >  [<f8ba2c85>] raid5_unplug_device+0x4e/0x5a [raid456]
>
> The above is stack gunk.
>
> >  [<c02a786e>] io_schedule+0x1d/0x27
> >  [<c014f3c5>] sync_page+0x0/0x3b
> >  [<c014f3fd>] sync_page+0x38/0x3b
> >  [<c02a7a6f>] __wait_on_bit_lock+0x2a/0x52
> >  [<c014f3b7>] __lock_page+0x58/0x5e
> >  [<c01333aa>] wake_bit_function+0x0/0x3c
> >  [<c0155daa>] truncate_inode_pages_range+0x201/0x256
> >  [<c0155e16>] truncate_inode_pages+0x17/0x1a
> >  [<f8c867eb>] reiserfs_delete_inode+0x36/0xdd [reiserfs]
> >  [<f8c867b5>] reiserfs_delete_inode+0x0/0xdd [reiserfs]
> >  [<c017acc5>] generic_delete_inode+0xa0/0x105
> >  [<c017a4ad>] iput+0x60/0x62
> >  [<c0172f41>] do_unlinkat+0xb6/0x126
> >  [<c0103d7e>] syscall_call+0x7/0xb
> >  =======================
> >
> > My system is still up and running.
> >
>
> It's stuck waiting for a page to come unlocked.  The most likely
> explanation is that an IO got lost.
>

I'm not sure how an IO becomes lost. I'm not running on exotic
hardware or anything. What can I do to provide more useful debugging
output in case this occurs again?
