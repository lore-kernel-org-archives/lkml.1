Return-Path: <linux-kernel-owner+w=401wt.eu-S1753976AbZCIJvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbZCIJvx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 05:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbZCIJvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 05:51:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63854 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752035AbZCIJvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 05:51:44 -0400
Message-ID: <49B4E6AE.2030302@cn.fujitsu.com>
Date: Mon, 09 Mar 2009 17:51:42 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: LKML <linux-kernel@vger.kernel.org>, martin.petersen@oracle.com
Subject: Re: [PATCH] block: fix memory leak in bio_clone()
References: <49B4DD9C.5030902@cn.fujitsu.com> <20090309092407.GI11787@kernel.dk> <49B4E2BA.3030809@cn.fujitsu.com> <20090309093836.GJ11787@kernel.dk>
In-Reply-To: <20090309093836.GJ11787@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> as the mempool mask. So the leak will not occur, but it does mean that
>>> it isn't honoring the gfp_mask passed in to bio_clone(), which is the
>> I noticed there was a patch to do this, and seems you planed to merge
>> it into .29?
>>
>> "[PATCH] Add gfp_mask to bio_integrity_clone()"
>>
>> http://lkml.org/lkml/2008/10/30/11
> 
> Hmm strange, apparently that never got queued up and I had forgotten all
> about that issue until your email. I'll add it asap.
> 

I found bio_integrity_clone() is not using the gfp_mask passed by bio_clone(),
so I googled it in LKML before I fix it. :)

>>> first bug. The second bug is that it should be using its own bioset, as
>>> it is illegal to do multiple __GFP_WAIT allocations on a single mempool
>>> and always expect progress.
> 
> That one still stands.
> 

Yes, and I'd leave it to you or Martin. ;)

