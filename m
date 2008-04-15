Return-Path: <linux-kernel-owner+w=401wt.eu-S1763628AbYDOE6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763628AbYDOE6h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 00:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932071AbYDOE6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 00:58:25 -0400
Received: from relay1.sgi.com ([192.48.171.29]:60618 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932066AbYDOE6Z (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 00:58:25 -0400
Date: Tue, 15 Apr 2008 14:58:03 +1000
From: David Chinner <dgc@sgi.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH-possible bugfix] xfs: ensure extents are read as be64
Message-ID: <20080415045803.GE103491721@sgi.com>
References: <1208230131.11920.59.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208230131.11920.59.camel@brick>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 08:28:51PM -0700, Harvey Harrison wrote:
> The debug code reads the extents in cpu-order rather than BE.  Make the
> debug code match.

xfs_validate_extents() is reading in-core extents which have already
been byte-swapped when they were read into memory.

FWIW, when changing anything to do with endian conversion, please
ensure you run:

$ make C=2 CHECKFLAGS="-D__CHECK_ENDIAN__"

over the change. This change would introduce errors because:

typedef struct xfs_bmbt_rec_host {
        __uint64_t              l0, l1;
} xfs_bmbt_rec_host_t;

is not defined with __beXX types like the disk format version of this
structure which is:

typedef struct xfs_bmbt_rec_64 {
        __be64                  l0, l1;
} xfs_bmbt_rec_64_t;

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
