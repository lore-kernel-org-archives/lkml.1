Return-Path: <linux-kernel-owner+w=401wt.eu-S1757380AbXKGH3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380AbXKGH3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 02:29:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755414AbXKGH3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 02:29:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:57645 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754774AbXKGH3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 02:29:04 -0500
From: Neil Brown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 7 Nov 2007 18:28:55 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18225.26935.146395.366451@notabene.brown>
Cc: Al Boldi <a1426z@gawab.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Massive slowdown when re-querying large nfs dir
In-Reply-To: message from Andrew Morton on Tuesday November 6
References: <200711050758.38090.a1426z@gawab.com>
	<200711061428.11453.a1426z@gawab.com>
	<20071106221939.cfa79f9e.akpm@linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday November 6, akpm@linux-foundation.org wrote:
> > On Tue, 6 Nov 2007 14:28:11 +0300 Al Boldi <a1426z@gawab.com> wrote:
> > Al Boldi wrote:
> > > There is a massive (3-18x) slowdown when re-querying a large nfs dir (2k+
> > > entries) using a simple ls -l.
> > >
> > > On 2.6.23 client and server running userland rpc.nfs.V2:
> > > first  try: time -p ls -l <2k+ entry dir>  in ~2.5sec
> > > more tries: time -p ls -l <2k+ entry dir>  in ~8sec
> > >
> > > first  try: time -p ls -l <5k+ entry dir>  in ~9sec
> > > more tries: time -p ls -l <5k+ entry dir>  in ~180sec
> > >
> > > On 2.6.23 client and 2.4.31 server running userland rpc.nfs.V2:
> > > first  try: time -p ls -l <2k+ entry dir>  in ~2.5sec
> > > more tries: time -p ls -l <2k+ entry dir>  in ~7sec
> > >
> > > first  try: time -p ls -l <5k+ entry dir>  in ~8sec
> > > more tries: time -p ls -l <5k+ entry dir>  in ~43sec
> > >
> > > Remounting the nfs-dir on the client resets the problem.
> > >
> > > Any ideas?
> > 
> > Ok, I played some more with this, and it turns out that nfsV3 is a lot 
> > faster.  But, this does not explain why the 2.4.31 kernel is still over 
> > 4-times faster than 2.6.23.
> > 
> > Can anybody explain what's going on?
> > 
> 
> Sure, Neil can! ;)

Nuh.
He said "userland rpc.nfs.Vx".  I only do "kernel-land NFS".  In these
days of high specialisation, each line of code is owned by a different
person, and finding the right person is hard....

I would suggest getting a 'tcpdump -s0' trace and seeing (with
wireshark) what is different between the various cases.

NeilBrown
