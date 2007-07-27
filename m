Return-Path: <linux-kernel-owner+w=401wt.eu-S937437AbXG0RKD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937437AbXG0RKD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 13:10:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758929AbXG0RJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 13:09:53 -0400
Received: from mx2.netapp.com ([216.240.18.37]:58877 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754829AbXG0RJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 13:09:52 -0400
X-IronPort-AV: E=Sophos;i="4.16,589,1175497200"; 
   d="scan'208";a="86623831"
Subject: Re: NFSv4 poops itself
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Jeff Garzik <jeff@garzik.org>,
       "Dr. J. Bruce Fields" <bfields@fieldses.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
In-Reply-To: <1185543187.6586.10.camel@localhost>
References: <46A9EAB0.3090306@garzik.org>
	 <1185543187.6586.10.camel@localhost>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Network Appliance Inc
Date: Fri, 27 Jul 2007 13:09:38 -0400
Message-Id: <1185556178.6586.40.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 27 Jul 2007 17:09:39.0886 (UTC) FILETIME=[EAE0BCE0:01C7D070]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-27 at 09:33 -0400, Trond Myklebust wrote:
> On Fri, 2007-07-27 at 08:53 -0400, Jeff Garzik wrote:
> > Background:
> > 
> > Server: x86-64 dual core Intel, kernel 2.6.23-rc1 (my home fileserver)
> > 	Exporting NFS/NFSv4 mounts.  Client count: 1  Uptime: 4 days
> > 
> > Client: x86-64 dual core Intel, kernel 2.6.23-rc1 (my main workstation)
> > 	NFS mount setup:
> > 	pretzel:/ on /g type nfs4 (rw,noatime,proto=tcp,addr=10.10.10.1)
> > 	Uptime: 4 days
> > 
> > 	Home directory mounted via NFSv4.
> > 
> > Problem:
> > 
> > My workstation has been happily talking to my file server for several 
> > days without incident.  An hour ago, my numeric keypad stopping working 
> > (unrelated problem... USB or X bug?).  The solution to the keypad 
> > problem is usually to log out of X and log back in, or worse case, reboot.
> > 
> > So, I log out, and log back in.  At first, a few shell windows open and 
> > successfully initialize themselves (read bash profile over NFS, etc.) 
> > Then, as more shell windows open, things start hanging.  I can easily 
> > switch to console and ssh to the fileserver, so it is clear this is an 
> > NFS hang.
> > 
> > No adverse messages at all on the client.
> > 
> > On the server, I see NFSv4 spamming dmesg with hundreds of thousands of 
> > messages:
> > 
> > Jul 27 08:20:53 pretzel kernel: NFSD: preprocess_seqid_op: old stateid!
> > Jul 27 08:21:24 pretzel last message repeated 167966 times
> > Jul 27 08:21:55 pretzel last message repeated 173628 times
> > Jul 27 08:21:55 pretzel kernel: NFSD: preprocess_seqid_op: old stateid!
> > Jul 27 08:22:26 pretzel last message repeated 171286 times
> > Jul 27 08:23:27 pretzel last message repeated 344461 times
> > Jul 27 08:23:30 pretzel last message repeated 18656 times

Jeff and Bruce, could you please try to reproduce the problem after
either applying patches 001 to 004 or just the single NFS_ALL patch
from 

   http://client.linux-nfs.org/Linux-2.6.x/2.6.23-rc1/

Cheers
  Trond
