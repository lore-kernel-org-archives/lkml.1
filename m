Return-Path: <linux-kernel-owner+w=401wt.eu-S1756419AbZECSn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419AbZECSn3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 14:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754271AbZECSnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 14:43:18 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:41651 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210AbZECSnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 14:43:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=PsN3vzfWIRDxOc4rt5iOSEGFqbi3oChzkAsB8JQ791U4iOndyPg2yTCDeStMr1RUS8
         zVVY3hrLao9kZfpLz92DEbSJOCroKjHqb6ayczGPPbZ003+P151rDf+d3JEmECKGz42v
         Ll9Pssib1cDUcNYRBmvFgMWGnuqw9Psz+x76Y=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: New TRIM/UNMAP tree published (2009-05-02)
Date: Sun, 3 May 2009 20:48:03 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3-00442-ga3668b0; KDE/4.2.2; i686; ; )
Cc: Boaz Harrosh <bharrosh@panasas.com>, Hugh Dickins <hugh@veritas.com>,
       Matthew Wilcox <willy@linux.intel.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>,
       linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Mark Lord <lkml@rtr.ca>
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com> <49FDB21B.3080301@panasas.com> <20090503154216.GU8822@parisc-linux.org>
In-Reply-To: <20090503154216.GU8822@parisc-linux.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200905032048.04219.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 03 May 2009 17:42:16 Matthew Wilcox wrote:
> On Sun, May 03, 2009 at 06:02:51PM +0300, Boaz Harrosh wrote:
> > I agree with Hugh. The allocation is done at, too-low in the food chain.
> > (And that free of buffer at upper layer allocated by lower layer).
> > 
> > I think you need to separate the: "does lld need buffer, what size"
> > from the "here is buffer prepare", so upper layer that can sleep does
> > sleep.
> 
> So you want two function pointers in the request queue relating to discard?
> 
> > In all other buffer needing operations the allocation is done before
> > submission of request, No?
> 
> It's not true for the flush request (the example I quoted).  Obviously,
> the solution adopted here by IDE is Bad and Wrong ...

When speaking about "the solution" do you mean that quick & ugly hack
that I needed to fix the unexpected regression during late -rc cycle? ;)

The proper solution would involve adding 'struct ide_cmd flush_cmd' to
ide_drive_t but I never got to verify/inquiry that is OK with the block
layer (if there can be only one flush rq outstanding or if we can have
both q->pre_flush_rq and q->post_flush_rq queued at the same time)...

Thanks,
Bart
