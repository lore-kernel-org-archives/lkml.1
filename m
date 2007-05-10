Return-Path: <linux-kernel-owner+w=401wt.eu-S1759285AbXEJLAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759285AbXEJLAM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 07:00:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754343AbXEJK77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 06:59:59 -0400
Received: from mail.exanet.com ([212.143.73.109]:45772 "EHLO mr.exanet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141AbXEJK76 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 06:59:58 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] NLM program ID for user space NLM server
Date: Thu, 10 May 2007 13:59:57 +0300
Message-ID: <A6FDE6B975803043804A49F12F49028E0F59CC@hawk.exanet-il.co.il>
In-Reply-To: <17986.60861.587591.548652@notabene.brown>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] NLM program ID for user space NLM server
Thread-Index: AceS6myfOMuIA90NTXqXI5zAdP9FpAABy6uw
From: "Menny Hamburger" <menny@exanet.com>
To: "Neil Brown" <neilb@suse.de>
Cc: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We have a our own userland NFSD and NLM service running that implement
all the NLM/NFS functionality.
We do not want to modify the way the client does his mounts.

M.



-----Original Message-----
From: Neil Brown [mailto:neilb@suse.de] 
Sent: Thursday, May 10, 2007 12:03 PM
To: Menny Hamburger
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NLM program ID for user space NLM server

On Thursday May 10, menny@exanet.com wrote:
> Hi,
> 
> Since the current kernel cannot be compiled with NFS client and 
> without lockd, it is not possible to register a user space NLM server 
> Without colliding with the kernel service registered in 
> .../fs/lockd/lockd.c.

This doesn't make any sense to me at all.
You can certainly have the NFS client compiled and even running without
lockd running (if you mount with "-o nolock") and in that case you are
free you register your owner user-space NLM server (though I'm not sure
what good it would do you).

And if you want to mount an NFS filesystem without "-o nolock", then you
really need the kernel lockd running, or locking will not work.

Can you explain what you are trying to do - I'm curious.

>  
> +#ifndef
>  #define NLM_PROGRAM		100021
> +#endif

Uhm...  Do you mean

  +#ifndef NLM_PROGRAM

??  Still not sure how that helps.

NeilBrown
