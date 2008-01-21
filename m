Return-Path: <linux-kernel-owner+w=401wt.eu-S1753355AbYAUSaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbYAUSaI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 13:30:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbYAUS3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 13:29:55 -0500
Received: from twinlark.arctic.org ([208.69.40.136]:52982 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbYAUS3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 13:29:54 -0500
Date: Mon, 21 Jan 2008 10:29:52 -0800 (PST)
From: dean gaudet <dean@arctic.org>
To: "Patrick J. LoPresti" <lopresti@gmail.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Fast network file copy; "recvfile()" ?
In-Reply-To: <23986fd90801171253o56f3dbcbqe44d9f29e719cba1@mail.gmail.com>
Message-ID: <alpine.DEB.0.999999.0801211021200.22574@twinlark.arctic.org>
References: <23986fd90801171253o56f3dbcbqe44d9f29e719cba1@mail.gmail.com>
User-Agent: Alpine 0.999999 (DEB 847 2007-12-06)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jan 2008, Patrick J. LoPresti wrote:

> I need to copy large (> 100GB) files between machines on a fast
> network.  Both machines have reasonably fast disk subsystems, with
> read/write performance benchmarked at > 800 MB/sec. Using 10GigE cards
> and the usual tweaks to tcp_rmem etc., I am getting single-stream TCP
> throughput better than 600 MB/sec.
> 
> My question is how best to move the actual file.  NFS writes appear to
> max out at a little over 100 MB/sec on this configuration.

did your "usual tweaks" include mounting with -o tcp,rsize=262144,wsize=262144 ?

i should have kept better notes last time i was experimenting with this,
but from memory here's what i found:

- if i used three NFS clients and was reading from page cache on the
  server i hit 1.2GB/s total throughput from the server.  the client
  NFS code was maxing out one CPU on each of the client machines.

- disk subsystem (sw raid10 far2) was capable of 600MB/s+ when read
  locally on the NFS server, but topped out around ~250MB/s when read
  remotely (no matter how many clients).

my workload was read-intensive so i didn't experiment with writes...

-dean
