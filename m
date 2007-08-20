Return-Path: <linux-kernel-owner+w=401wt.eu-S1760595AbXHTP6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760595AbXHTP6u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 11:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759704AbXHTP6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 11:58:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759318AbXHTP6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 11:58:40 -0400
Subject: Re: [Cluster-devel] Re: [gfs2][RFC] readdir caused ls process into
	D (uninterruptible) state, under testing with Samba 3.0.25
From: Steven Whitehouse <swhiteho@redhat.com>
To: rae l <crquan@gmail.com>
Cc: cluster-devel@redhat.com, Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <91b13c310708200236l6089f1cdt336a3ce5072c97cf@mail.gmail.com>
References: <91b13c310708160120v7379d867k73ecf1995719d694@mail.gmail.com>
	 <1187252928.8765.881.camel@quoit>
	 <91b13c310708170043n49c90a79n4d3fed177b9b93b2@mail.gmail.com>
	 <1187364432.8765.916.camel@quoit>
	 <91b13c310708200236l6089f1cdt336a3ce5072c97cf@mail.gmail.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Mon, 20 Aug 2007 16:51:45 +0100
Message-Id: <1187625105.8765.937.camel@quoit>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2007-08-20 at 17:36 +0800, rae l wrote:
> On 8/17/07, Steven Whitehouse <swhiteho@redhat.com> wrote:
> ...
> > > the stack trace of the 'D' state `ls`:
> > >
> > >  =======================
> > > ls            D F89B83F8  2200 12018      1 (NOTLB)
> > >        f3eeadd4 00000082 f6a425c0 f89b83f8 f3eead9c f6a425d4 f6f32d80 f573a93c
> > >        00010000 f89b83f3 00000000 c40a2030 c3fa9fa0 c40aaa70 c40aab7c 00000e89
> > >        b2a4b036 000002e4 c40a2030 f3eeae1c 00000000 c3f85e98 f8e11e09 f8e11e0e
> > > Call Trace:
> > >  [<f89b83f8>] gdlm_bast+0x0/0x93 [lock_dlm]
> > >  [<f89b83f3>] gdlm_ast+0x0/0x5 [lock_dlm]
> > >  [<f8e11e09>] holder_wait+0x0/0x8 [gfs2]
> > >  [<f8e11e0e>] holder_wait+0x5/0x8 [gfs2]
> >                 ^^^^ This function doesn't exist in recent kernels, so I
> > guess you are using an older kernel. Which version is it?
> Sorry for the late,
> The kernel I'm testing is 2.6.21.7, just because our testing cluster
> suite is from the last month when cluster-2.01 from here didn't come
> out,
> ftp://sources.redhat.com/pub/cluster/releases/
> 
> So now we were keeping testing on kernel 2.6.21.y series, just for its
> stability, I don't know how about the stability of 2.6.22.y, I haven't
> tested it yet.
> 
> So the problem I said has been fixed in later kernel after 2.6.22,
> please feel free to let me know.
> 
I suspect that it might have been, but I can't say for certain. We've
fixed a number of things which look very similar, but not exactly like
the bug you seem to have hit. In the latest Linus' kernels there is a
fix for a problem in the DLM which it would be worth trying so if you
are in a position to test something more recent, then I would suggest
that as a first course of action.

Let me know if that doesn't solve the problem,

Steve.


