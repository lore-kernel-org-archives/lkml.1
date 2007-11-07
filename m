Return-Path: <linux-kernel-owner+w=401wt.eu-S1757900AbXKGGT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900AbXKGGT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 01:19:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756053AbXKGGTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 01:19:49 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59953 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755884AbXKGGTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 01:19:48 -0500
Date: Tue, 6 Nov 2007 22:19:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Al Boldi <a1426z@gawab.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Neil Brown <neilb@suse.de>
Subject: Re: Massive slowdown when re-querying large nfs dir
Message-Id: <20071106221939.cfa79f9e.akpm@linux-foundation.org>
In-Reply-To: <200711061428.11453.a1426z@gawab.com>
References: <200711050758.38090.a1426z@gawab.com>
	<200711061428.11453.a1426z@gawab.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 6 Nov 2007 14:28:11 +0300 Al Boldi <a1426z@gawab.com> wrote:
> Al Boldi wrote:
> > There is a massive (3-18x) slowdown when re-querying a large nfs dir (2k+
> > entries) using a simple ls -l.
> >
> > On 2.6.23 client and server running userland rpc.nfs.V2:
> > first  try: time -p ls -l <2k+ entry dir>  in ~2.5sec
> > more tries: time -p ls -l <2k+ entry dir>  in ~8sec
> >
> > first  try: time -p ls -l <5k+ entry dir>  in ~9sec
> > more tries: time -p ls -l <5k+ entry dir>  in ~180sec
> >
> > On 2.6.23 client and 2.4.31 server running userland rpc.nfs.V2:
> > first  try: time -p ls -l <2k+ entry dir>  in ~2.5sec
> > more tries: time -p ls -l <2k+ entry dir>  in ~7sec
> >
> > first  try: time -p ls -l <5k+ entry dir>  in ~8sec
> > more tries: time -p ls -l <5k+ entry dir>  in ~43sec
> >
> > Remounting the nfs-dir on the client resets the problem.
> >
> > Any ideas?
> 
> Ok, I played some more with this, and it turns out that nfsV3 is a lot 
> faster.  But, this does not explain why the 2.4.31 kernel is still over 
> 4-times faster than 2.6.23.
> 
> Can anybody explain what's going on?
> 

Sure, Neil can! ;)
