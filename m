Return-Path: <linux-kernel-owner+w=401wt.eu-S1763972AbYDOFDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763972AbYDOFDa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 01:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753250AbYDOFDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 01:03:22 -0400
Received: from rv-out-0708.google.com ([209.85.198.243]:51986 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753231AbYDOFDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 01:03:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kXAzqfbRvbylHPX6+txlNrqVDNubvlboJPmVAMZ9GOnWqEfZ/TdCdopHheXjKqe940QvE8HWOZiPsxDe0JY3bQcyqdafW4d7yzUahzp3vY2RWmUj/AXGMYZhc21KspBvq5WAY6N4g75CIFz6q0V7fFeBt0ar+LN/sZiPuzA3yjo=
Subject: Re: [PATCH-possible bugfix] xfs: ensure extents are read as be64
From: Harvey Harrison <harvey.harrison@gmail.com>
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080415045803.GE103491721@sgi.com>
References: <1208230131.11920.59.camel@brick>
	 <20080415045803.GE103491721@sgi.com>
Content-Type: text/plain
Date: Mon, 14 Apr 2008 22:03:23 -0700
Message-Id: <1208235803.11920.62.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-15 at 14:58 +1000, David Chinner wrote:
> On Mon, Apr 14, 2008 at 08:28:51PM -0700, Harvey Harrison wrote:
> > The debug code reads the extents in cpu-order rather than BE.  Make the
> > debug code match.
> 
> xfs_validate_extents() is reading in-core extents which have already
> been byte-swapped when they were read into memory.
> 
> FWIW, when changing anything to do with endian conversion, please
> ensure you run:
> 
> $ make C=2 CHECKFLAGS="-D__CHECK_ENDIAN__"
> 
> over the change. This change would introduce errors because:
> 
> typedef struct xfs_bmbt_rec_host {
>         __uint64_t              l0, l1;
> } xfs_bmbt_rec_host_t;
> 
> is not defined with __beXX types like the disk format version of this
> structure which is:
> 
> typedef struct xfs_bmbt_rec_64 {
>         __be64                  l0, l1;
> } xfs_bmbt_rec_64_t;
> 

Sorry for the noise, I didn't notice the (slightly) different struct
types.  Just the very similar looking blocks in both functions.

My Bad,

Harvey

