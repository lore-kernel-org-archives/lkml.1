Return-Path: <linux-kernel-owner+w=401wt.eu-S1759292AbXEIWRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759292AbXEIWRz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 18:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757162AbXEIWRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 18:17:47 -0400
Received: from mx2.netapp.com ([216.240.18.37]:39234 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756224AbXEIWRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 18:17:46 -0400
X-IronPort-AV: i="4.14,512,1170662400"; 
   d="scan'208"; a="58575878:sNHT142868236"
Subject: Re: [bisect] NFS regression breaks X
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, Chuck Lever <chuck.lever@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       NeilBrown <neilb@suse.de>, Adrian Bunk <bunk@stusta.de>
In-Reply-To: <alpine.LFD.0.98.0705091440461.4062@woody.linux-foundation.org>
References: <46423D62.2070200@garzik.org>
	 <alpine.LFD.0.98.0705091440461.4062@woody.linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Network Appliance Inc
Date: Wed, 09 May 2007 18:17:44 -0400
Message-Id: <1178749064.6760.14.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 09 May 2007 22:17:59.0344 (UTC) FILETIME=[E6C7C300:01C79287]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-09 at 14:51 -0700, Linus Torvalds wrote:
> 
> On Wed, 9 May 2007, Jeff Garzik wrote:
> > 
> > I love bisect :)
> 
> Yeah, me too.
> 
> > bisect has identified the following commit as the one that
> > causes my GNOME login to die, within 10 seconds of logging in:
> > 
> > 	commit 2bea90d43a050bbc4021d44e59beb34f384438db
> 
> Ok, that commit looks nice in many ways, so I'd be loathe to revert it 
> entirely.
> 
> Can you try it with this patch that re-introduces the "total overkill" 
> slack calculations, and probably makes them even worse (there's a few 
> left-shifts added, and now it will left-shift the extra slacktoo).
> 
> But there are also some unexplained changes in that patch, so maybe the 
> size allocation isn't the big problem. For example, now "call_allocate()" 
> will set task->tk_status to zero which is totally strange.
> 
> But if it's the allocation that is too small, this patch may help.
> 
> Trond, Chuck?

We'd really like to fix this by getting the pre-allocation tables right
in nfs4xdr.c. Chuck has already identified one incorrect value:

http://linux-nfs.org/cgi-bin/gitweb.cgi?p=nfs-2.6.git;a=commitdiff;h=6ce7dc940701cf3fde3c6e826a696b333092cbb1;hp=aa3d1faebe6e214cd96be0e587571477ff6fd9fc

that I just asked you to pull as part of a series of bugfixes. I'm
hoping that will suffice to fix Jeff's case too.

Trond
