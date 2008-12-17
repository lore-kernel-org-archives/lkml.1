Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1751836AbYLQSN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836AbYLQSN5 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 13:13:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750890AbYLQSNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 13:13:47 -0500
Received: from mx2.netapp.com ([216.240.18.37]:4678 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbYLQSNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 13:13:46 -0500
X-IronPort-AV: E=Sophos;i="4.36,238,1228118400"; 
   d="scan'208";a="99729741"
Subject: Re: [PATCH 1/3] SUNRPC: Ensure the server closes sockets in a
 timely fashion
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Tom Tucker <tom@opengridcomputing.com>
Cc: Ian Campbell <ijc@hellion.org.uk>, linux-nfs@vger.kernel.org,
        Max Kellermann <mk@cm4all.com>, linux-kernel@vger.kernel.org,
        gcosta@redhat.com, Grant Coady <grant_lkml@dodo.com.au>,
        "J. Bruce Fields" <bfields@fieldses.org>
In-Reply-To: <49491A50.7000109@opengridcomputing.com>
References: <20081017123207.GA14979@rabbit.intern.cm-ag>
	 <1224484046.23068.14.camel@localhost.localdomain>
	 <1225539927.2221.3.camel@localhost.localdomain>
	 <1225546878.4390.3.camel@heimdal.trondhjem.org>
	 <1227596962.16868.22.camel@localhost.localdomain>
	 <1227619696.7057.19.camel@heimdal.trondhjem.org>
	 <1227620339.9425.99.camel@zakaz.uk.xensource.com>
	 <1227621434.7057.33.camel@heimdal.trondhjem.org>
	 <1227621877.9425.102.camel@zakaz.uk.xensource.com>
	 <1227737539.31008.2.camel@localhost.localdomain>
	 <1228090631.7112.11.camel@heimdal.trondhjem.org>
	 <1228090719.7112.13.camel@heimdal.trondhjem.org>
	 <49491A50.7000109@opengridcomputing.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: NetApp
Date: Wed, 17 Dec 2008 13:08:16 -0500
Message-Id: <1229537296.7257.37.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
X-OriginalArrivalTime: 17 Dec 2008 18:08:48.0577 (UTC) FILETIME=[8252C310:01C96072]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-17 at 09:27 -0600, Tom Tucker wrote:
> > +	if (!test_bit(XPT_LISTENER, &xprt->xpt_flags))
> > +		kernel_sock_shutdown(svsk->sk_sock, SHUT_RDWR);
> 
> How is this different than what happens as an artifact of sock_release?

The point is that it is independent of whether or not something is
holding a reference to the svc_sock.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
