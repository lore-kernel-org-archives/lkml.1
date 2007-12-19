Return-Path: <linux-kernel-owner+w=401wt.eu-S1755632AbXLSSdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632AbXLSSdx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 13:33:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbXLSSdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 13:33:46 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:24428 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbXLSSdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 13:33:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=TKqDDHNYXFKGpAoRW5tn3iVs8CSetDjhOCFk3LAszGQpev/9gCa0Vspd/KoHfFhPWvEI5dI+bg4cPo9Zg7PvBGmQ6QcHv6qY1SeF2t4qT6+mmqRN4A+T6SJm3qOONRjhQ39FKdNkAJgikGsmNGbr9EvkAvGnFIt7YzYk9Z2haCo=
Date: Wed, 19 Dec 2007 19:35:14 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>
Subject: Re: [PATCH 6/6] udf: fix sparse warnings (shadowing & mismatch
	between declaration and definition)
Message-ID: <20071219183511.GC18104@joi>
References: <20071216021741.GG26986@joi> <20071217165017.GJ6979@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071217165017.GJ6979@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2007 at 05:50:17PM +0100, Jan Kara wrote:
> > fix warnings:
> > fs/udf/super.c:1320:24: warning: symbol 'bh' shadows an earlier one
> > fs/udf/super.c:1240:21: originally declared here
> > fs/udf/super.c:1583:4: warning: symbol 'i' shadows an earlier one
> > fs/udf/super.c:1418:6: originally declared here
> > fs/udf/super.c:1585:4: warning: symbol 'i' shadows an earlier one
> > fs/udf/super.c:1418:6: originally declared here
> > fs/udf/super.c:1658:4: warning: symbol 'i' shadows an earlier one
> > fs/udf/super.c:1648:6: originally declared here
> > fs/udf/super.c:1660:4: warning: symbol 'i' shadows an earlier one
> > fs/udf/super.c:1648:6: originally declared here
> > fs/udf/super.c:450:6: warning: symbol 'udf_write_super' was not declared. Should it be static?
> >
> > Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> > CC: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
>   Thanks for the patch.  The 'bh' change is fine. The problems with 'i'
> should be solved differently I think. Those functions UDF_SB_FREE,
> UDF_SB_ALLOC_PARTMAPS should be functions and not macros. Please convert
> those to either inline functions if they are small or to regular
> functions if they are larger.  It won't be completely trivial because of
> the hackery e.g. in UDF_SB_ALLOC_BITMAP. It gets an argument meaning on
> which struct member something should be performed. But for example in
> the UDF_SB_ALLOC_BITMAP case you can simply make the function return the
> pointer to allocated and initialized space and the caller would assign
> it to a proper element of the superblock.
Ok, I'll try to do it.

> This would help the overall
> code quality of UDF (which is sadly quite poor).
If you have other suggestions how to clean up this code, let me know.
I'll see what I can do with them ;)

Marcin
