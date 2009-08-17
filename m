Return-Path: <linux-kernel-owner+w=401wt.eu-S1752287AbZHQNMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287AbZHQNMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 09:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbZHQNMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 09:12:18 -0400
Received: from mx2.netapp.com ([216.240.18.37]:20468 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbZHQNMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 09:12:18 -0400
X-IronPort-AV: E=Sophos;i="4.43,396,1246863600"; 
   d="scan'208";a="226184403"
Subject: Re: [2.6.31-rc5] oops: NFS4 client manager kthread...
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: linux-nfs@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <6278d2220908161540h78f17424m592c5acf3420f906@mail.gmail.com>
References: <6278d2220908161540h78f17424m592c5acf3420f906@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: NetApp
Date: Mon, 17 Aug 2009 09:12:18 -0400
Message-Id: <1250514738.8475.26.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
X-OriginalArrivalTime: 17 Aug 2009 13:12:19.0543 (UTC) FILETIME=[599CD670:01CA1F3C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-08-16 at 23:40 +0100, Daniel J Blueman wrote:
> After losing and regaining ethernet link a few times with 2.6.31-rc5
> [1], I've hit an oops in the NFS4 client manager kthread [2] on my
> client with NFS4 homedir mount.
> 
> Do you have a frequent test-case for when the client's manager kthread
> gets invoked (with and without succeeding callbacks, due to eg a
> firewall)? Server here is unpatched 2.6.30-rc6; I recall seeing
> problems when the manager kthread gets invoked, across quite a few
> kernel releases, just wasn't lucky enough to catch an oops.
> 
> Oppsing in allow_signal() suggests task state corruption perhaps? I'm
> downloading the debug kernel to match up the disassembly and line
> numbers, if that helps? This time, the client had no firewall (but
> have seen other issues when the callback has failed due to the
> firewall).

Those aren't Oopses. They are 'soft lockup' warnings. Basically, they're
saying that the CPU is getting stuck waiting for a spin lock or a mutex.

In this case, it is probably the fact that the state manager is going
nuts trying to recover, while the connection to the server keeps coming
up and going down.

What does 'netstat -t' say when you get into this situation?

Cheers
  Trond

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
