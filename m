Return-Path: <linux-kernel-owner+w=401wt.eu-S1756176AbYDQWGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176AbYDQWGv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 18:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753991AbYDQWGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 18:06:41 -0400
Received: from mx2.netapp.com ([216.240.18.37]:8041 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753983AbYDQWGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 18:06:40 -0400
X-IronPort-AV: E=Sophos;i="4.25,673,1199692800"; 
   d="scan'208";a="32879118"
Subject: Re: SUNRPC: Fix a memory leak in rpc_create()
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Cc: linux-kernel@vger.kernel.org, Chris Wright <chrisw@sous-sol.org>,
       stable@kernel.org, Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <200804172325.39462.s.L-H@gmx.de>
References: <20080417010122.148289106@sous-sol.org>
	 <20080417010354.950049854@sous-sol.org>  <200804172325.39462.s.L-H@gmx.de>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Network Appliance Inc
Date: Thu, 17 Apr 2008 18:06:37 -0400
Message-Id: <1208469997.5375.4.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
X-OriginalArrivalTime: 17 Apr 2008 22:06:38.0726 (UTC) FILETIME=[4F33B260:01C8A0D7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-04-17 at 23:25 +0200, Stefan Lippers-Hollmann wrote:
> Hi
> 
> On Donnerstag, 17. April 2008, you wrote:
> > -stable review patch.  If anyone has any objections, please let us know.
> > ---------------------
> > 
> > From: Chuck Lever <chuck.lever@oracle.com>
> > 
> > upstream commit: ed13c27e546667fb0967ae30f5070cd7f6455f90
> > 
> > Commit 510deb0d was supposed to move the xprt_create_transport() call in
> > rpc_create(), but neglected to remove the old call site.  This resulted in
> > a transport leak after every rpc_create() call.
> > 
> > This leak is present in 2.6.24 and 2.6.25.
> 
> This patch might introduce a regression:
> 

Gah. You're quite right. The commit that introduced the leak was merged
well after 2.6.24 was released despite what the changelog entry says
above:

$ git describe 510deb0d
v2.6.24-3933-g510deb0

I should have double-checked before posting this to stable@kernel.org.
I'm very sorry...

  Trond

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
