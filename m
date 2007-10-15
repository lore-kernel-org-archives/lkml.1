Return-Path: <linux-kernel-owner+w=401wt.eu-S1764652AbXJOLsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764652AbXJOLsH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 07:48:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759166AbXJOLrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 07:47:55 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:41468 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757050AbXJOLrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 07:47:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=JLNBFDqHTEUMXYQwTrI1SukuiDzNze2Yu11VVk0w8d0VADdKpxcJa6D2fkQwDE2E3SWUX5xD0OCjWkgMd2wg72TMSXQpp2zw7nWhr10PVtQQMI78erBiv0WkB/T/al2AuhP2nQ6f9JIA+aSMvKxfnZ68Z054n1m5INyOEafBgVI=
Message-ID: <84144f020710150447o94b1babo8b6e6a647828465f@mail.gmail.com>
Date: Mon, 15 Oct 2007 14:47:52 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Erez Zadok" <ezk@cs.sunysb.edu>
Subject: Re: msync(2) bug(?), returns AOP_WRITEPAGE_ACTIVATE to userland
Cc: "Hugh Dickins" <hugh@veritas.com>, "Ryan Finnie" <ryan@finnie.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       cjwatson@ubuntu.com, linux-mm@kvack.org
In-Reply-To: <200710142232.l9EMW8kK029572@agora.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0710142049000.13119@sbz-30.cs.Helsinki.FI>
	 <200710142232.l9EMW8kK029572@agora.fsl.cs.sunysb.edu>
X-Google-Sender-Auth: b53b24ca58b034e7
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10/15/07, Erez Zadok <ezk@cs.sunysb.edu> wrote:
> Pekka, with a small change to your patch (to handle time-based cache
> coherency), your patch worked well and passed all my tests.  Thanks.
>
> So now I wonder if we still need the patch to prevent AOP_WRITEPAGE_ACTIVATE
> from being returned to userland.  I guess we still need it, b/c even with
> your patch, generic_writepages() can return AOP_WRITEPAGE_ACTIVATE back to
> the VFS and we need to ensure that doesn't "leak" outside the kernel.

I wonder whether _not setting_ BDI_CAP_NO_WRITEBACK implies that
->writepage() will never return AOP_WRITEPAGE_ACTIVATE for
!wbc->for_reclaim case which would explain why we haven't hit this bug
before. Hugh, Andrew?

And btw, I think we need to fix ecryptfs too.

                                           Pekka
