Return-Path: <linux-kernel-owner+w=401wt.eu-S1752730AbYLBPha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730AbYLBPha (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 10:37:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122AbYLBPhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 10:37:12 -0500
Received: from mx2.netapp.com ([216.240.18.37]:40967 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977AbYLBPhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 10:37:10 -0500
X-IronPort-AV: E=Sophos;i="4.33,702,1220252400"; 
   d="scan'208";a="93481852"
Subject: Re: [PATCH 0/3] NFS regression in 2.6.26?, "task blocked for more
 than 120 seconds"
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Kasparek Tomas <kasparek@fit.vutbr.cz>
Cc: Ian Campbell <ijc@hellion.org.uk>, linux-nfs@vger.kernel.org,
       Max Kellermann <mk@cm4all.com>, linux-kernel@vger.kernel.org,
       gcosta@redhat.com, Grant Coady <grant_lkml@dodo.com.au>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Tom Tucker <tom@opengridcomputing.com>
In-Reply-To: <20081202152256.GI47559@fit.vutbr.cz>
References: <1225539927.2221.3.camel@localhost.localdomain>
	 <1225546878.4390.3.camel@heimdal.trondhjem.org>
	 <1227596962.16868.22.camel@localhost.localdomain>
	 <1227619696.7057.19.camel@heimdal.trondhjem.org>
	 <1227620339.9425.99.camel@zakaz.uk.xensource.com>
	 <1227621434.7057.33.camel@heimdal.trondhjem.org>
	 <1227621877.9425.102.camel@zakaz.uk.xensource.com>
	 <1227737539.31008.2.camel@localhost.localdomain>
	 <1228090631.7112.11.camel@heimdal.trondhjem.org>
	 <1228091380.7112.17.camel@heimdal.trondhjem.org>
	 <20081202152256.GI47559@fit.vutbr.cz>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: NetApp
Date: Tue, 02 Dec 2008 10:37:02 -0500
Message-Id: <1228232222.3090.5.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
X-OriginalArrivalTime: 02 Dec 2008 15:37:08.0292 (UTC) FILETIME=[D5EF3840:01C95493]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-12-02 at 16:22 +0100, Kasparek Tomas wrote:
> On Sun, Nov 30, 2008 at 07:29:40PM -0500, Trond Myklebust wrote:
> > On Sun, 2008-11-30 at 19:17 -0500, Trond Myklebust wrote:
> > > Can you see if the following 3 patches help? They're against 2.6.28-rc6,
> > > but afaics the problems are pretty much the same on 2.6.26.
> > 
> > Sorry... I forgot to add that these 3 patches need to be applied to the
> > nfs server, not the client.
> 
> Hi,
> 
> I have the problem on client side and can not change server (FreeBSD 7.0). 
> these patches does not change the situation (and they are probably not
> supposed to do so, just giving it a try). After few minutes I got this on
> the client with 2.6.28-rc6 with patches:
> 
> tcp   0   0 147.229.12.146:674          147.229.176.14:2049     FIN_WAIT2
> 
> Applying reverse e06799f958bf7f9f8fae15f0c6f519953fb0257c suggested by Ian
> does help on the other side (with 2.6.27.4).

Then I suggest working around the problem by reducing the value of the
sysctl net.ipv4.tcp_fin_timeout on the client.
-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
