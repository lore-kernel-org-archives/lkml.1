Return-Path: <linux-kernel-owner+w=401wt.eu-S1760277AbYDZXqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760277AbYDZXqW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 19:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752692AbYDZXqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 19:46:15 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:28831 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbYDZXqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 19:46:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=BdjfRnitkTIv9mLmrFc8WhCDGPEvqkk/QLzidZGgyiFvMed3BKFGpfcAcWNaegcZioKLY6oaJddeZD5g1FhssO5IxVsDvl5rWlf/OGpK1YfbCVRsXdVlEsdV6oyNUvwf/CZACWvhVEtvYQAFRNJSxWhy7OY7mqAOAlSr/70BEsY=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: reduce stack usage in xfs_bmap_btalloc()
Date: Sun, 27 Apr 2008 01:45:11 +0200
User-Agent: KMail/1.8.2
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com,
       Eric Sandeen <sandeen@sandeen.net>, Adrian Bunk <bunk@kernel.org>,
       linux-kernel@vger.kernel.org
References: <200804261651.02078.vda.linux@googlemail.com> <20080426200347.GA21021@infradead.org>
In-Reply-To: <20080426200347.GA21021@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804270145.11632.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 April 2008 22:03, Christoph Hellwig wrote:
> On Sat, Apr 26, 2008 at 04:51:02PM +0200, Denys Vlasenko wrote:
> > Hi David,
> > 
> > This patch reduces xfs_bmap_btalloc() stack usage by 50 bytes
> > by moving part of its body into a helper function.
> > 
> > This results in some variables not taking stack space in
> > xfs_bmap_btalloc() anymore.
> 
> I think this is a good idea, although I'd rather split the function at
> a local boundary.  The patch below (which passes xfsqa) does that
> by splitting out the handling of the most complicated nullfb case
> out.  It probably won't help reducing stack useage as much as yours,
> but it helps beeing able to read the code a little better.

It saves only 16 bytes of stack.
--
vda
