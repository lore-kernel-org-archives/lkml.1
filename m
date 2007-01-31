Return-Path: <linux-kernel-owner+w=401wt.eu-S1030299AbXAaUFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030299AbXAaUFS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 15:05:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030211AbXAaUFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 15:05:17 -0500
Received: from kanga.kvack.org ([66.96.29.28]:49277 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030299AbXAaUFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 15:05:15 -0500
Date: Wed, 31 Jan 2007 15:05:02 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: Zach Brown <zach.brown@oracle.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, linux-aio@kvack.org,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0 of 4] Generic AIO by scheduling stacks
Message-ID: <20070131200502.GO1344@kvack.org>
References: <patchbomb.1170193181@tetsuo.zabbo.net> <1170209044.26655.364.camel@localhost.localdomain> <6CDD5D9D-E031-499D-9A8A-5A8522C66D37@oracle.com> <20070131175118.GN1344@kvack.org> <FA6A1934-9D3D-456E-BDF6-3530D74BB657@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FA6A1934-9D3D-456E-BDF6-3530D74BB657@oracle.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 31, 2007 at 11:25:30AM -0800, Zach Brown wrote:
> >without linking it into the system lists.  The reason I don't think  
> >this
> >approach works (and I looked at it a few times) is that many things  
> >end
> >up requiring special handling: things like permissions, signals,  
> >FPU state,
> >segment registers....
> 
> Can you share a specific example of the special handling required?

Take FPU state: memory copies and RAID xor functions use MMX/SSE and 
require that the full task state be saved and restored.

Task priority is another.  POSIX AIO lets you specify request priority, and 
it really is needed for realtime workloads where things like keepalive 
must be processed at a higher priority.  This is especially important on 
embedded systems which don't have a surplus of CPU cycles.

		-ben
-- 
"Time is of no importance, Mr. President, only life is important."
Don't Email: <dont@kvack.org>.
