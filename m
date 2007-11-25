Return-Path: <linux-kernel-owner+w=401wt.eu-S1757914AbXKYXRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914AbXKYXRt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 18:17:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756709AbXKYXRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 18:17:42 -0500
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:48651 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755741AbXKYXRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 18:17:41 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=FH/gUxhg7hKkXZ7TBjWjHnVJ2M482+c4guAadN5ae4YZx06VSq/QILRpNqEOc8FHWWRhl0Nsfq6LsQB2VBT0cdSzLFqC+OKtMjkZgQYVHg2zHwOwBJf4iXxF4Fu+CKjHZy52vWlrMOofKezViQIpdCkUrwCSlbD/2ZlYY4TcHoY=  ;
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 1/9]: introduce radix_tree_gang_lookup_range
Date: Mon, 26 Nov 2007 10:17:24 +1100
User-Agent: KMail/1.9.5
Cc: xfs-oss <xfs@oss.sgi.com>, lkml <linux-kernel@vger.kernel.org>
References: <20071122003211.GG114266761@sgi.com>
In-Reply-To: <20071122003211.GG114266761@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711261017.24694.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 November 2007 11:32, David Chinner wrote:
> Introduce radix_tree_gang_lookup_range()
>
> The inode clustering in XFS requires a gang lookup on the radix tree to
> find all the inodes in the cluster.  The gang lookup has to set the
> maximum items to that of a fully populated cluster so we get all the
> inodes in the cluster, but we only populate the radix tree sparsely (on
> demand).
>
> As a result, the gang lookup can search way, way past the index of end
> of the cluster because it is looking for a fixed number of entries to
> return.
>
> We know we want to terminate the search at either a specific index or a
> maximum number of items, so we need to add a "last_index" parameter to
> the lookup.

Yeah, this fixes one downside of the gang lookup API. For consistency
it would be nice to do this for the tag lookup API as well...


> Furthermore, the existing radix_tree_gang_lookup() can use this same
> function if we define a RADIX_TREE_MAX_INDEX value so the search is not
> limited by the last_index.

Nit: should just define it to be ULONG_MAX.

>
> Signed-off-by: Dave Chinner <dgc@sgi.com>

Otherwise, Acked-by: Nick Piggin <npiggin@suse.de>
