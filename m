Return-Path: <linux-kernel-owner+w=401wt.eu-S1756874AbYDVQTD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874AbYDVQTD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 12:19:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbYDVQSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 12:18:54 -0400
Received: from hu-out-0506.google.com ([72.14.214.237]:50063 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874AbYDVQSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 12:18:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=gKufr+uwshAvru7UNoDLd62bBc2XuUKyDyLLVLaQIfVqLDVm6O5xbPg1ZM3tA5lV9yOjj3e8s6pk6Hj0YU96D8T0DDpMvCkhFiPbbelf2trq47PkqkGX7oEO6PeXbKMeqd4CsE4u8eVqLi1JK8s9uPyXZf1ZbAvWoCxt67NH8Js=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH] xfs: #define out unused parameters of xfs_bmap_add_free and xfs_btree_read_bufl
Date: Tue, 22 Apr 2008 18:17:03 +0200
User-Agent: KMail/1.8.2
Cc: David Chinner <dgc@sgi.com>, Eric Sandeen <sandeen@sandeen.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20080419142329.GA5339@elte.hu> <200804221320.54147.vda.linux@googlemail.com> <20080422142807.GD16895@cs181133002.pp.htv.fi>
In-Reply-To: <20080422142807.GD16895@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804221817.03945.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 April 2008 16:28, Adrian Bunk wrote:
> > xfs_bmap_add_free and xfs_btree_read_bufl functions
> > use some of their parameters only in some cases
> > (e.g. if DEBUG is defined, or on non-Linux OS :)
> > 
> > This patch removes these parameters using #define hack
> > which makes them "disappear" without the need of uglifying
> > every callsite with #ifdefs.
> > 
> > Code size difference on 32-bit x86:
> >  393457    2904    2952  399313   617d1 linux-2.6-xfs6-TEST/fs/xfs/xfs.o
> >  393441    2904    2952  399297   617c1 linux-2.6-xfs7-TEST/fs/xfs/xfs.o
> >...
> 
> Elimination of completely unused parameters makes sense, but IMHO using 
> such #define hacks for minuscule code size and stack usage advantages is 
> not worth it.

In busybox this trick is used extensively.

I don't know how to eliminate these unused parameters with less
intervention, but I also don't want to leave it unfixed.

I want to eventually reach the state with no warnings
about unused parameters.
--
vda
