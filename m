Return-Path: <linux-kernel-owner+w=401wt.eu-S1754034AbXE3S3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbXE3S3V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 14:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753869AbXE3S3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 14:29:12 -0400
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:57282 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843AbXE3S3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 14:29:12 -0400
Date: Wed, 30 May 2007 14:29:09 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH][RFC] security: revalidate rw permissions for sys_splice
 and  sys_vmsplice
In-Reply-To: <20070530111743.e638c841.akpm@linux-foundation.org>
Message-ID: <Line.LNX.4.64.0705301425570.17724@d.namei>
References: <Line.LNX.4.64.0705291617260.9955@d.namei> <20070530071500.GU15559@kernel.dk>
 <20070530111743.e638c841.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007, Andrew Morton wrote:

> On Wed, 30 May 2007 09:15:01 +0200
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Tue, May 29 2007, James Morris wrote:
> > > Revalidate read/write permissions for splice(2) and vmslice(2), in case 
> > > security policy has changed since the files were opened.
> > 
> > I guess it was inevitably going to happen :-)
> > 
> > Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> > 
> 
> Probably acked-by was more appropriate.
> 
> James, is this considered needed-for-2.6.22?

No, it's tightening things up.  We don't have full revocation in any case, 
and the primary security check is performed on open.

> > +	ret = security_file_permission(out, MAY_WRITE);
> > +	if (unlikely(ret < 0))
> > +		return ret;
> 
> 
> ot: all the unlikely()s are irksome.  I wonder if there was some way of
> doing this in security_file_permission() instead.  eg:

This is the only place where we do this -- it's to remain consistent with 
the surrounding splice code, which does this for other checks.  Given that 
it's calling out to a typically non-trivial security module, it may be 
better to remove the unlikelys here.



- James
-- 
James Morris
<jmorris@namei.org>
