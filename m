Return-Path: <linux-kernel-owner+w=401wt.eu-S1756588AbYE2S1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588AbYE2S1D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 14:27:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753717AbYE2S0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 14:26:53 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:51599 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859AbYE2S0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 14:26:52 -0400
Date: Thu, 29 May 2008 19:24:44 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Harvey Harrison <harvey.harrison@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, hans-christoph.rohland@sap.com,
       leg@google.com, pbadari@us.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tmpfs: support aio
In-Reply-To: <1212019598.20781.11.camel@brick>
Message-ID: <Pine.LNX.4.64.0805291920120.553@blonde.site>
References: <Pine.LNX.4.64.0805290007320.7969@blonde.site> 
 <20080528165815.f4e4982c.akpm@linux-foundation.org> <1212019598.20781.11.camel@brick>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2008, Harvey Harrison wrote:
> On Wed, 2008-05-28 at 16:58 -0700, Andrew Morton wrote:
> > 
> > 	count = 0;
> > 	retval = generic_segment_checks(iov, &nr_segs, &count, VERIFY_WRITE);
> > 	if (retval)
> > 		return retval;
> > 	if (count == 0)
> > 		return 0;
> > 
> > 	retval = 0;
> 
> retval has to be 0 here, no need to assign it again?

You're right, thanks: it was even more obviously stupid in my patch.
That came from copying generic_file_aio_read, then removing its O_DIRECT
block: though now I look closer, it's actually just as redundant in the
original.  I'll fix that up in the shmem.c and filemap.c patches to follow.

Hugh
