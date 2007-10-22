Return-Path: <linux-kernel-owner+w=401wt.eu-S1751924AbXJVUkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924AbXJVUkf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 16:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbXJVUkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 16:40:17 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:1249 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbXJVUkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 16:40:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=PWXGk2MbnjHr/g7yi397k4XVqSTPqSiBDbSH5nKzij0kTdEDxk2ul3PG+UdWE1CgIVLm/Sd7BQnlXZWeWb+KKUMr9+CSwVqp1ZUoxpZ/aTBtVwLm6F5VrCoZchZnjhHmGSCjK286153cYINcwwzpBkekFLhwOnav3olXhW5zE2o=
Message-ID: <84144f020710221340n6586b6d6web28cea481809b93@mail.gmail.com>
Date: Mon, 22 Oct 2007 23:40:14 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Hugh Dickins" <hugh@veritas.com>
Subject: Re: msync(2) bug(?), returns AOP_WRITEPAGE_ACTIVATE to userland
Cc: "Erez Zadok" <ezk@cs.sunysb.edu>, "Ryan Finnie" <ryan@finnie.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       cjwatson@ubuntu.com, linux-mm@kvack.org
In-Reply-To: <Pine.LNX.4.64.0710222042500.23513@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200710142232.l9EMW8kK029572@agora.fsl.cs.sunysb.edu>
	 <Pine.LNX.4.64.0710222042500.23513@blonde.wat.veritas.com>
X-Google-Sender-Auth: 854f9d4285862608
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hugh,

On 10/22/07, Hugh Dickins <hugh@veritas.com> wrote:
> I don't disagree with your unionfs_writepages patch, Pekka, but I think
> it should be viewed as an optimization (don't waste time trying to write
> a group of pages when we know that nothing will be done) rather than as
> essential.

Ok, so tmpfs needs your fix still.

On 10/22/07, Hugh Dickins <hugh@veritas.com> wrote:
> > So now I wonder if we still need the patch to prevent AOP_WRITEPAGE_ACTIVATE
> > from being returned to userland.  I guess we still need it, b/c even with
> > your patch, generic_writepages() can return AOP_WRITEPAGE_ACTIVATE back to
> > the VFS and we need to ensure that doesn't "leak" outside the kernel.
>
> Can it now?  Current git has a patch from Andrew which bears a striking
> resemblance to that from Pekka, stopping the leak from write_cache_pages.

I don't think it can, it looks ok now.

                             Pekka
