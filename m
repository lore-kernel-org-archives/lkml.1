Return-Path: <linux-kernel-owner+w=401wt.eu-S1752730AbYJ0L6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730AbYJ0L6T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 07:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbYJ0L6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 07:58:08 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:46878 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781AbYJ0L6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 07:58:07 -0400
Date: Mon, 27 Oct 2008 12:57:00 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH 2/2] x86: replace BIO_VMERGE_BOUNDARY with BIOVEC_PHYS_MERGEABLE
Message-ID: <20081027115659.GZ22217@kernel.dk>
References: <49057A15.7030007@goop.org> <20081027173739Q.fujita.tomonori@lab.ntt.co.jp> <49058774.3030506@goop.org> <20081027183604V.fujita.tomonori@lab.ntt.co.jp> <20081027094111.GU22217@kernel.dk> <4905A961.9000603@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4905A961.9000603@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27 2008, Jeremy Fitzhardinge wrote:
> Jens Axboe wrote:
> >Pretty much baffles me as well, xen should just need to do
> >
> >#define BIOVEC_PHYS_MERGEABLE(vec1, vec2)       0
> >  
> 
> It needs to be a runtime switch, since we only want to do this when 
> actually running under Xen.  Also, its possible that the two pages might 
> actually be physically contiguous, so they could be merged anyway.

Alright, then add a xen_biovec_phys_mergeable(vec1, vec2) in the xen
code that actually checks this for real. You can add your switch there
as well. Then put the BIOVEC_PHYS_MERGEABLE() in the xen arch includes,
done.

What Tomo is saying is that this has nothing to do with virtual merging,
and he's right.

-- 
Jens Axboe

