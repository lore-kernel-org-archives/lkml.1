Return-Path: <linux-kernel-owner+w=401wt.eu-S933849AbXGMH1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933849AbXGMH1b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 03:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753676AbXGMH1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 03:27:23 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53231 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751117AbXGMH1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 03:27:23 -0400
Date: Fri, 13 Jul 2007 00:27:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: NeilBrown <neilb@suse.de>
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: Re: [PATCH 012 of 20] knfsd: nfsd4: make readonly access depend on
 pseudoflavor
Message-Id: <20070713002704.2287f5a3.akpm@linux-foundation.org>
In-Reply-To: <1070710022615.13375@suse.de>
References: <20070710121949.12548.patches@notabene>
	<1070710022615.13375@suse.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007 12:26:15 +1000 NeilBrown <neilb@suse.de> wrote:

> +static inline int EX_RDONLY(struct svc_export *exp, struct svc_rqst *rqstp)
> +{
> +	struct exp_flavor_info *f;
> +	struct exp_flavor_info *end = exp->ex_flavors + exp->ex_nflavors;
> +
> +	for (f = exp->ex_flavors; f < end; f++) {
> +		if (f->pseudoflavor == rqstp->rq_flavor)
> +			return f->flags & NFSEXP_READONLY;
> +	}
> +	return exp->ex_flags & NFSEXP_READONLY;
> +}

It is fortunate that this inlined monster has only one callsite.

otoh, given that it has only one callsite, perhaps it should be private
to fs/nfsd/vfs.c.
