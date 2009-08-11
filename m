Return-Path: <linux-kernel-owner+w=401wt.eu-S1754908AbZHKOg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbZHKOg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 10:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754821AbZHKOg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 10:36:58 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:44579 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726AbZHKOg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 10:36:57 -0400
Date: Tue, 11 Aug 2009 09:36:43 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH][RFC] security: constify seq_operations
Message-ID: <20090811143643.GA15096@us.ibm.com>
References: <alpine.LRH.2.00.0908112337450.21218@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0908112337450.21218@tundra.namei.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting James Morris (jmorris@namei.org):
> I think it'd be a good idea to constify more of the various operations 
> structs in the kernel -- our coverage of this is spotty.
> 
> The patch below should provide coverage for all of the eligible 
> seq_operations structs in the kernel.  It's derived from the grsecurity 
> patch (which I was reading and noticed how many of these we're missing).
> 
> It's possible something's been missed, or that there are problems in code 
> which I can't test.  Please review/comment/test.
> 
> If it looks ok, I suggest pushing this via -mm.
> 
> Note that there are quite a few other similar ops to be constified, such 
> as file_operations, so if anyone would like to pitch in, please do so.
> 
> ---
> 
> Subject: [PATCH 1/1] security: constify seq_operations
> 
> Make all seq_operations structs const, to help mitigate
> against revectoring user-triggerable function pointers.
> 
> This is derived from the grsecurity patch, although generated
> from scratch because it's simpler than extracting the changes
> from there.
> 
> Signed-off-by: James Morris <jmorris@namei.org>

I think it's a good idea.

I suppose we could add a script to check for any new
seq_ops structs not constified...  something as simple as
find . -type f -print0 | xargs -0 grep 'struct seq_operations' | grep -v const
Though what you have here hits all of those and more.

Acked-by: Serge Hallyn <serue@us.ibm.com>

thanks,
-serge
