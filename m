Return-Path: <linux-kernel-owner+w=401wt.eu-S1756722AbZDWLL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722AbZDWLL7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 07:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755761AbZDWLLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 07:11:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58630 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707AbZDWLLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 07:11:47 -0400
Date: Thu, 23 Apr 2009 07:11:47 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Valerie Aurora Henson <vaurora@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Chris Mason <chris.mason@oracle.com>, Theodore Tso <tytso@mit.edu>,
       Eric Sandeen <sandeen@redhat.com>, Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [RFC PATCH] fpathconf() for fsync() behavior
Message-ID: <20090423111147.GC4833@infradead.org>
References: <20090423001257.GA16540@shell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090423001257.GA16540@shell>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 08:12:57PM -0400, Valerie Aurora Henson wrote:
> In the default mode for ext3 and btrfs, fsync() is both slow and
> unnecessary for some important application use cases - at the same
> time that it is absolutely required for correctness for other modes of
> ext3, ext4, XFS, etc.  If applications could easilyl distinguish
> between the two cases, they would be more likely to be correct and
> fast.
> 
> How about an fpathconf() variable, something like _PC_ORDERED?  E.g.:

Before we add any new fpathconf varibale we need a reall (f)pathconf(at)
syscall so that the fs driver can exposed it's characteristics, having
to replicate that information to glibc especially for something required
for data integrity is a receipe for a desaster.
