Return-Path: <linux-kernel-owner+w=401wt.eu-S1765917AbZDCN5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765917AbZDCN5y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 09:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764627AbZDCN5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 09:57:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41584 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765326AbZDCN5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 09:57:31 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090403134927.GA31907@infradead.org>
References: <20090403134927.GA31907@infradead.org> <20090403094138.9510.80681.stgit@warthog.procyon.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: dhowells@redhat.com, nickpiggin@yahoo.com.au, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/4] CacheFiles: Use the ->write() file op rather than a special kernel aop
Date: Fri, 03 Apr 2009 14:57:19 +0100
Message-ID: <11023.1238767039@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> wrote:

> > +			if (!aops->bmap)
> >  				goto check_error;
> 
> What are you doing using bmap?  You really shouldn't call into it from
> anywhere but FIBMAP.  Yes, swap currently does but it's a major pain
> in the neck and Peter has been working on a proper interface for swap
> for a while.

Checking to see whether there's a hole in the file.  If there's a hole, that
represents data I need to fetch; if there isn't that represents data I have in
the cache.  I don't care _where_ the data is, only whether it exists or not.

David
