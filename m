Return-Path: <linux-kernel-owner+w=401wt.eu-S1754628AbYCKJlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbYCKJlv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 05:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242AbYCKJln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 05:41:43 -0400
Received: from n6.bullet.mud.yahoo.com ([216.252.100.57]:23998 "HELO
	n6.bullet.mud.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751143AbYCKJln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 05:41:43 -0400
X-Yahoo-Newman-Id: 281921.61210.bm@omp417.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=AJjzTEOUMjPFW3OqZCEYD6TX84RF7QhKCPzr1SH5YCHKZpw/nz2PlZ6tODCEYja83KqDJiv9JRSFuiRKU0TI2C/GVmjsy+6UY5w5dQQbBS9XRhIj9umhu0eSGTSV/L3kj/ok5LxhGInYffUN5wStBF8P5G33cXiVwVH4FtLYoRA=  ;
X-YMail-OSG: BXkiECIVM1kbvF9T6rHLeAEajcftFBmPAcO3N2AX.qAs213Yt7GM8jJKSmHn8JgE6hBGiR.Mfg--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [RFC PATCH] Implement slub fastpath with sequence number
Date: Tue, 11 Mar 2008 20:41:09 +1100
User-Agent: KMail/1.9.5
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
References: <20080311093144.GB30220@Krystal>
In-Reply-To: <20080311093144.GB30220@Krystal>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803112041.09217.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 March 2008 20:31, Mathieu Desnoyers wrote:
> Here is a new version that works. tested on x86. tweaked the bitmasks
> into unions to remove operations from the critical path, but I tried to
> keep that clean. It applies on vm.git HEAD.
>
> It allows the cmpxchg_local to detect object re-use by keeping a counter in
> the freeoffset MSBs.
>
> Whenever an object is freed in the cpu slab cache, the counter is
> incremented. Whenever the alloc/free slow paths are modifying the offset or
> freebase, the sequence counter is also incremented. It is used to make sure
> we know if freebase has been modified in an interrupt nested over the fast
> path.

Wow. I applaud the effort to micro optimise things ;)

But I hope this doesn't get merged until macro-regressions in SLUB
are verified to be fixed. It's pretty clear that SLUB's problem is
not fastpath performance, so I think this would be premature
optimisation.

