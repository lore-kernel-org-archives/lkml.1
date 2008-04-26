Return-Path: <linux-kernel-owner+w=401wt.eu-S1759623AbYDZXHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759623AbYDZXHI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 19:07:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752209AbYDZXG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 19:06:57 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:4822 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbYDZXG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 19:06:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Z8t9MZMPrEbdJbtYK0liU7u4StDOj/iRqU4qw/yrMkjfisqZBLTs/WSPYSCdlrVbS1RUEk5urRdZ6cQf7tDgiSG9u09eQviRgPZH7ukUXys4pFkYbyX11H5rricg38V9scsbM7XcGEuAtCpdA0dqFE5uLiAzD8N5luqjbuiJn/E=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] xfs: reduce stack usage in xfs_bmap_btalloc()
Date: Sun, 27 Apr 2008 01:05:17 +0200
User-Agent: KMail/1.8.2
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com,
       Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org
References: <200804261651.02078.vda.linux@googlemail.com> <48137A7E.4000202@sandeen.net>
In-Reply-To: <48137A7E.4000202@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804270105.18096.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 April 2008 20:54, Eric Sandeen wrote:
> > This patch reduces xfs_bmap_btalloc() stack usage by 50 bytes
> > by moving part of its body into a helper function.
> > 
> > This results in some variables not taking stack space in
> > xfs_bmap_btalloc() anymore.
> > 
> > The helper itself does not call anything stack-deep.
> > Stack-deep call to xfs_alloc_vextent() happen
> > in xfs_bmap_btalloc(), as before.
> > 
> > Compile tested only.
> > 
> > Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
> 
> Looks like a very good approach, it pushes a lot of large local vars off
> into the helper.
> 
> There is one build-time problem if DEBUG is turned on:
> 
>         if (args.fsbno != NULLFSBLOCK) {
>                 ap->firstblock = ap->rval = args.fsbno;
>                 ASSERT(nullfb || fb_agno == args.agno ||
>                        (ap->low && fb_agno < args.agno));
> 
> in xfs_bmap_btalloc, which no longer has an fb_agno variable which the
> ASSERT macro uses.

Do you want me to rework and resend the patch?
--
vda
