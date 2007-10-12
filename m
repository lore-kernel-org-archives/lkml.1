Return-Path: <linux-kernel-owner+w=401wt.eu-S1761457AbXJLVtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761457AbXJLVtr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 17:49:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759539AbXJLVpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 17:45:51 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:47685 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760300AbXJLVpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 17:45:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=COj8IzTg60YZn2+7+aUZ0IXLTYZ2QYtXCnl+H/R57nd9ag/LDAFJyRxUvMVYJRMcDc6rkRhkLCwfqA8e4BdnAjLjq7OOSrDscrQ7l3OMnC9hQtxr9DvqkzpCtPPcW8a/G80zhTJZv2mvzL7gMunQJNBuYyckzJGMv59zIkTc0qE=
Message-ID: <84144f020710121445p23fcc21am18482e01856cdc35@mail.gmail.com>
Date: Sat, 13 Oct 2007 00:45:48 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Hugh Dickins" <hugh@veritas.com>
Subject: Re: msync(2) bug(?), returns AOP_WRITEPAGE_ACTIVATE to userland
Cc: "Ryan Finnie" <ryan@finnie.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Erez Zadok" <ezk@cs.sunysb.edu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, cjwatson@ubuntu.com, linux-mm@kvack.org
In-Reply-To: <Pine.LNX.4.64.0710120129080.16588@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200710071920.l97JKJX5018871@agora.fsl.cs.sunysb.edu>
	 <20071011144740.136b31a8.akpm@linux-foundation.org>
	 <cfa94dc20710111512j9b6c038qf89c516ecd605411@mail.gmail.com>
	 <Pine.LNX.4.64.0710120129080.16588@blonde.wat.veritas.com>
X-Google-Sender-Auth: 5e3e3e8d36160be5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hugh,

On 10/12/07, Hugh Dickins <hugh@veritas.com> wrote:
> But I keep suspecting that the answer might be the patch below (which
> rather follows what drivers/block/rd.c is doing).  I'm especially
> worried that, rather than just AOP_WRITEPAGE_ACTIVATE being returned
> to userspace, bad enough in itself, you might be liable to hit that
> BUG_ON(page_mapped(page)).  shmem_writepage does not expect to be
> called by anyone outside mm/vmscan.c, but unionfs can now get to it?

Doesn't msync(2) get to it via mm/page-writeback.c:write_cache_pages()
without unionfs even?

                                       Pekka
