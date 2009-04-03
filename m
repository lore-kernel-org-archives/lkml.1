Return-Path: <linux-kernel-owner+w=401wt.eu-S1764305AbZDCNtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764305AbZDCNtm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 09:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759375AbZDCNtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 09:49:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47821 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758249AbZDCNtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 09:49:31 -0400
Date: Fri, 3 Apr 2009 09:49:27 -0400
From: Christoph Hellwig <hch@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: nickpiggin@yahoo.com.au, hch@infradead.org, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/4] CacheFiles: Use the ->write() file op rather than
	a special kernel aop
Message-ID: <20090403134927.GA31907@infradead.org>
References: <20090403094138.9510.80681.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090403094138.9510.80681.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 03, 2009 at 10:41:38AM +0100, David Howells wrote:
> +			if (!aops->bmap)
>  				goto check_error;

What are you doing using bmap?  You really shouldn't call into it from
anywhere but FIBMAP.  Yes, swap currently does but it's a major pain
in the neck and Peter has been working on a proper interface for swap
for a while.

> +	if (IS_ERR(file)) {
> +		ret = PTR_ERR(file);

		goto out_something;

> +	} else {
> +		ret = -EIO;
> +		if (file->f_op->write) {

	if (!file->f_op->write)
		goto out_fput;

