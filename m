Return-Path: <linux-kernel-owner+w=401wt.eu-S1757948AbXKGJhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948AbXKGJhG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 04:37:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbXKGJgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 04:36:54 -0500
Received: from [212.12.190.111] ([212.12.190.111]:56399 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750695AbXKGJgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 04:36:53 -0500
From: Al Boldi <a1426z@gawab.com>
To: Neil Brown <neilb@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Massive slowdown when re-querying large nfs dir
Date: Wed, 7 Nov 2007 12:36:26 +0300
User-Agent: KMail/1.5
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200711050758.38090.a1426z@gawab.com> <20071106221939.cfa79f9e.akpm@linux-foundation.org> <18225.26935.146395.366451@notabene.brown>
In-Reply-To: <18225.26935.146395.366451@notabene.brown>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200711071236.26780.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Brown wrote:
> On Tuesday November 6, akpm@linux-foundation.org wrote:
> > > On Tue, 6 Nov 2007 14:28:11 +0300 Al Boldi <a1426z@gawab.com> wrote:
> > > Al Boldi wrote:
> > > > There is a massive (3-18x) slowdown when re-querying a large nfs dir
> > > > (2k+ entries) using a simple ls -l.
> > > >
> > > > On 2.6.23 client and server running userland rpc.nfs.V2:
> > > > first  try: time -p ls -l <2k+ entry dir>  in ~2.5sec
> > > > more tries: time -p ls -l <2k+ entry dir>  in ~8sec
> > > >
> > > > first  try: time -p ls -l <5k+ entry dir>  in ~9sec
> > > > more tries: time -p ls -l <5k+ entry dir>  in ~180sec
> > > >
> > > > On 2.6.23 client and 2.4.31 server running userland rpc.nfs.V2:
> > > > first  try: time -p ls -l <2k+ entry dir>  in ~2.5sec
> > > > more tries: time -p ls -l <2k+ entry dir>  in ~7sec
> > > >
> > > > first  try: time -p ls -l <5k+ entry dir>  in ~8sec
> > > > more tries: time -p ls -l <5k+ entry dir>  in ~43sec
> > > >
> > > > Remounting the nfs-dir on the client resets the problem.
> > > >
> > > > Any ideas?
> > >
> > > Ok, I played some more with this, and it turns out that nfsV3 is a lot
> > > faster.  But, this does not explain why the 2.4.31 kernel is still
> > > over 4-times faster than 2.6.23.
> > >
> > > Can anybody explain what's going on?
> >
> > Sure, Neil can! ;)

Thanks Andrew!

> Nuh.
> He said "userland rpc.nfs.Vx".  I only do "kernel-land NFS".  In these
> days of high specialisation, each line of code is owned by a different
> person, and finding the right person is hard....
>
> I would suggest getting a 'tcpdump -s0' trace and seeing (with
> wireshark) what is different between the various cases.

Thanks Neil for looking into this.  Your suggestion has already been answered 
in a previous post, where the difference has been attributed to "ls -l" 
inducing lookup for the first try, which is fast, and getattr for later 
tries, which is super-slow.

Now it's easy to blame the userland rpc.nfs.V2 server for this, but what's 
not clear is how come 2.4.31 handles getattr faster than 2.6.23?


Thanks!

--
Al

