Return-Path: <linux-kernel-owner+w=401wt.eu-S1755070AbYE2AGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070AbYE2AGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 20:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684AbYE2AGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 20:06:42 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:7844 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbYE2AGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 20:06:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=LWAYZmWeNPDa5J0mHvCclSAz+COKbdrAblQaTq0gv1cIr10dj4vvh3wu1xcfCO3l/x+c3PEpFOJK4oFmQ6EhBwLwwgJdVKjOGnfcu5bP77CZs1a1KC/gRHe5tmlbSGX8dUIVnb4tGXdzqELaFOlp8aIr4f8Y/ZtBrwqfBfF0iDI=
Subject: Re: [PATCH] tmpfs: support aio
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hugh@veritas.com>, hans-christoph.rohland@sap.com,
       leg@google.com, pbadari@us.ibm.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080528165815.f4e4982c.akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0805290007320.7969@blonde.site>
	 <20080528165815.f4e4982c.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 28 May 2008 17:06:38 -0700
Message-Id: <1212019598.20781.11.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-05-28 at 16:58 -0700, Andrew Morton wrote:
> On Thu, 29 May 2008 00:13:35 +0100 (BST)
> Hugh Dickins <hugh@veritas.com> wrote:
> hm.  This version:
> 
> static ssize_t shmem_file_aio_read(struct kiocb *iocb,
> 		const struct iovec *iov, unsigned long nr_segs, loff_t pos)
> {
> 	struct file *filp = iocb->ki_filp;
> 	ssize_t retval;
> 	unsigned long seg;
> 	size_t count;
> 	loff_t *ppos = &iocb->ki_pos;
> 
> 	count = 0;
> 	retval = generic_segment_checks(iov, &nr_segs, &count, VERIFY_WRITE);
> 	if (retval)
> 		return retval;
> 	if (count == 0)
> 		return 0;
> 
> 	retval = 0;

retval has to be 0 here, no need to assign it again?

Harvey

