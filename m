Return-Path: <linux-kernel-owner+w=401wt.eu-S1753402AbYJ0LoH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbYJ0LoH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 07:44:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbYJ0Lnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 07:43:55 -0400
Received: from gw.goop.org ([64.81.55.164]:52621 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541AbYJ0Lnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 07:43:55 -0400
Message-ID: <4905A961.9000603@goop.org>
Date: Mon, 27 Oct 2008 22:43:29 +1100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH 2/2] x86: replace BIO_VMERGE_BOUNDARY with BIOVEC_PHYS_MERGEABLE
References: <49057A15.7030007@goop.org> <20081027173739Q.fujita.tomonori@lab.ntt.co.jp> <49058774.3030506@goop.org> <20081027183604V.fujita.tomonori@lab.ntt.co.jp> <20081027094111.GU22217@kernel.dk>
In-Reply-To: <20081027094111.GU22217@kernel.dk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> Pretty much baffles me as well, xen should just need to do
>
> #define BIOVEC_PHYS_MERGEABLE(vec1, vec2)       0
>   

It needs to be a runtime switch, since we only want to do this when 
actually running under Xen.  Also, its possible that the two pages might 
actually be physically contiguous, so they could be merged anyway.

    J
