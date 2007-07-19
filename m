Return-Path: <linux-kernel-owner+w=401wt.eu-S936949AbXGSIaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936949AbXGSIaN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 04:30:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758954AbXGSI35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 04:29:57 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46336 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759191AbXGSI34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 04:29:56 -0400
Date: Thu, 19 Jul 2007 09:29:51 +0100
From: Christoph Hellwig <hch@infradead.org>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, NeilBrown <neilb@suse.de>,
       andros@citi.umich.edu, "J. Bruce Fields" <bfields@citi.umich.edu>,
       nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [NFS] [PATCH 5/5] knfsd: clean up EX_RDONLY
Message-ID: <20070719082951.GB2507@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	NeilBrown <neilb@suse.de>, andros@citi.umich.edu,
	"J. Bruce Fields" <bfields@citi.umich.edu>,
	nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <2ac9f179334dc7894bb58b1c2fb62837a07fbbdf.1184798679.git.bfields@citi.umich.edu> <986bf36dcb843bf352799fad5c20f1764748ce22.1184798679.git.bfields@citi.umich.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <986bf36dcb843bf352799fad5c20f1764748ce22.1184798679.git.bfields@citi.umich.edu>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2007 at 06:57:30PM -0400, J. Bruce Fields wrote:
> From: J. Bruce Fields <bfields@citi.umich.edu>
> 
> Share a little common code, reverse the arguments for consistency, drop
> the unnecessary "inline", and lowercase the name.

Ah, sorry - didn't notice this was a separate patch.

> @@ -1845,7 +1838,7 @@ nfsd_permission(struct svc_rqst *rqstp, struct svc_export *exp,
>  	 */
>  	if (!(acc & MAY_LOCAL_ACCESS))
>  		if (acc & (MAY_WRITE | MAY_SATTR | MAY_TRUNC)) {
> -			if (EX_RDONLY(exp, rqstp) || IS_RDONLY(inode))
> +			if (exp_rdonly(rqstp, exp) || IS_RDONLY(inode))

In fact with just a singler caller left and reduced to a one-liner we
could kill this function completely..
