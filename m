Return-Path: <linux-kernel-owner+w=401wt.eu-S1757563AbXHTJgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563AbXHTJgt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 05:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751421AbXHTJgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 05:36:40 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:44370 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbXHTJgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 05:36:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RmBZ/Jgv0tCZ2nttZ1aufD4XWfbA9oXhQvQvf+7es945rkfuYxMZfrEnolMXCN2xsrMtDgG8MzD0iu8iTBu0ohqo12FxiWgi/Ry8suJ3Q1s89OyQaksgpRI9+kqpD6ESNCQaOISje4RDjVFRSemppiuXwFuzou90oIDSF87H0hM=
Message-ID: <91b13c310708200236l6089f1cdt336a3ce5072c97cf@mail.gmail.com>
Date: Mon, 20 Aug 2007 17:36:37 +0800
From: "rae l" <crquan@gmail.com>
To: "Steven Whitehouse" <swhiteho@redhat.com>
Subject: Re: [Cluster-devel] Re: [gfs2][RFC] readdir caused ls process into D (uninterruptible) state, under testing with Samba 3.0.25
Cc: cluster-devel@redhat.com,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <1187364432.8765.916.camel@quoit>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <91b13c310708160120v7379d867k73ecf1995719d694@mail.gmail.com>
	 <1187252928.8765.881.camel@quoit>
	 <91b13c310708170043n49c90a79n4d3fed177b9b93b2@mail.gmail.com>
	 <1187364432.8765.916.camel@quoit>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/17/07, Steven Whitehouse <swhiteho@redhat.com> wrote:
...
> > the stack trace of the 'D' state `ls`:
> >
> >  =======================
> > ls            D F89B83F8  2200 12018      1 (NOTLB)
> >        f3eeadd4 00000082 f6a425c0 f89b83f8 f3eead9c f6a425d4 f6f32d80 f573a93c
> >        00010000 f89b83f3 00000000 c40a2030 c3fa9fa0 c40aaa70 c40aab7c 00000e89
> >        b2a4b036 000002e4 c40a2030 f3eeae1c 00000000 c3f85e98 f8e11e09 f8e11e0e
> > Call Trace:
> >  [<f89b83f8>] gdlm_bast+0x0/0x93 [lock_dlm]
> >  [<f89b83f3>] gdlm_ast+0x0/0x5 [lock_dlm]
> >  [<f8e11e09>] holder_wait+0x0/0x8 [gfs2]
> >  [<f8e11e0e>] holder_wait+0x5/0x8 [gfs2]
>                 ^^^^ This function doesn't exist in recent kernels, so I
> guess you are using an older kernel. Which version is it?
Sorry for the late,
The kernel I'm testing is 2.6.21.7, just because our testing cluster
suite is from the last month when cluster-2.01 from here didn't come
out,
ftp://sources.redhat.com/pub/cluster/releases/

So now we were keeping testing on kernel 2.6.21.y series, just for its
stability, I don't know how about the stability of 2.6.22.y, I haven't
tested it yet.

So the problem I said has been fixed in later kernel after 2.6.22,
please feel free to let me know.

>
> >  [<c0303adf>] __wait_on_bit+0x2c/0x51
> >  [<c0303b73>] out_of_line_wait_on_bit+0x6f/0x77
> >  [<f8e11e09>] holder_wait+0x0/0x8 [gfs2]
> >  [<c012dd7d>] wake_bit_function+0x0/0x3c
> >  [<c012dd7d>] wake_bit_function+0x0/0x3c
> >  [<f8e11e4d>] wait_on_holder+0x3c/0x40 [gfs2]
> >  [<f8e12a9a>] glock_wait_internal+0x81/0x1a3 [gfs2]
> >  [<f8e12d64>] gfs2_glock_nq+0x5e/0x79 [gfs2]
> >  [<f8e1fc02>] gfs2_getattr+0x72/0xb5 [gfs2]
> >  [<f8e1fbfb>] gfs2_getattr+0x6b/0xb5 [gfs2]
> >  [<c0166946>] do_path_lookup+0x17a/0x1c3
> >  [<f8e1fb90>] gfs2_getattr+0x0/0xb5 [gfs2]
> >  [<c0161f92>] vfs_getattr+0x3e/0x51
> >  [<c016201e>] vfs_lstat_fd+0x2b/0x3d
> >  [<c0166946>] do_path_lookup+0x17a/0x1c3
> >  [<c0171e40>] mntput_no_expire+0x11/0x6e
> >  [<c016260b>] sys_lstat64+0xf/0x23
> >  [<c01681a0>] sys_symlinkat+0x81/0xb5
> >  [<c01030b8>] sysenter_past_esp+0x5d/0x81
> >  [<c0300000>] __ipv6_addr_type+0x88/0xb8
> >
> > the system is still running, so the mormal 'R' and 'S' state process
> > are ignored, But it turns out that it's not the readdir's fault from
> > this call trace, but gdlm_bast's problem in lock_dlm module.
> >
> Yes, it does look a bit odd. There was a bug fix (which has only very
> recently made it into Linus' kernel as of the last GFS2 pull a few days
> ago) which fixes a problem in the DLM, although this doesn't look like
> that, at least at first sight.
>
> The other thing which you can check is the glock state which you can
> find in /sys/kernel/debug/gfs2/<fsname>/glocks on each node. The list is
> usually quite large, so its best to just email a url where it can be
> found. That will tell you which processes own which locks and thus what
> is holding the lock which is causing the problem. Likewise there is also
> a debugfs file which contains the locks from the DLM's point of view
> too.
I'll try it. Thanks.

>
> Steve.
>
>
>

-- 
Denis Cheng
