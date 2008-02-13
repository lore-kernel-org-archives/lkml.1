Return-Path: <linux-kernel-owner+w=401wt.eu-S1763025AbYBMGXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763025AbYBMGXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 01:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823AbYBMGXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 01:23:09 -0500
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:48536 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752600AbYBMGXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 01:23:08 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=lK8uxOHZBH9PIpRL9w8vChZXmVkQV/dPnbAjf+KBdcA3+UX6ZBT9Tf/w/ydl50n/guXJ1RRUmqpnP1/6Z+aMmsaFipCyMdiFxJVPa3pdHzTfA6EDRY1latLp/eUriptPgEuM+twQsFZ7PgworxwFYMOSaHA5y5Fcbx6hNDxiOxc=  ;
X-YMail-OSG: h_mt79IVM1nbCfesTPQX6MfgDZPL5nNhh2pfuqxXRTKqdbH94PpIVbs6VS6Ifg8uyBTYJmb6Kw--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Max Krasnyansky <maxk@qualcomm.com>
Subject: Re: [git pull for -mm] CPU isolation extensions (updated2)
Date: Wed, 13 Feb 2008 17:22:50 +1100
User-Agent: KMail/1.9.5
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, pj@sgi.com, a.p.zijlstra@chello.nl, gregkh@suse.de,
       rusty@rustcorp.com.au
References: <47B11C45.6060408@qualcomm.com> <200802131511.28643.nickpiggin@yahoo.com.au> <47B288E4.2080403@qualcomm.com>
In-Reply-To: <47B288E4.2080403@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802131722.51117.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 February 2008 17:06, Max Krasnyansky wrote:
> Nick Piggin wrote:

> > But don't let me dissuade you from making these good improvements
> > to Linux as well :) Just that it isn't really going to be hard-rt
> > in general.
>
> Actually that's the cool thing about CPU isolation. Get rid of all latency
> sources from the CPU(s) and you get youself as hard-RT as it gets.

Hmm, maybe. Removing all sources of latency from the CPU kind of
implies that you have to audit the whole kernel for source of
latency.

> I mean I _already_ have multi-core hard-RT systems that show ~1.2 usec
> worst case and ~200nsec average latency. I do not even need Adeos/Xenomai
> or Preemp-RT just a few very small patches. And it can be used for non RT
> stuff too.

OK, but you then are very restricted in what you can do, and easily
can break it especially if you run any userspace on that CPU. If
you just run a kernel module that, after setup, doesn't use any
other kernel resources except interrupt handling, then you might be
OK (depending on whether even interrupt handling can run into
contended locks)...

If you started doing very much more, then you can easily run into
trouble.
