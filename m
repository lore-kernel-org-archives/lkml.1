Return-Path: <linux-kernel-owner+w=401wt.eu-S1753470AbZJEPNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470AbZJEPNg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 11:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753290AbZJEPNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 11:13:36 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:33170 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753279AbZJEPNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 11:13:35 -0400
Date: Mon, 5 Oct 2009 11:06:31 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <tj@kernel.org>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, mingo@elte.hu, rusty@rustcorp.com.au,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [this_cpu_xx V4 12/20] Move early initialization of pagesets
 out of zone_wait_table_init()
In-Reply-To: <4ACA0A4F.3090004@kernel.org>
Message-ID: <alpine.DEB.1.10.0910051105070.16359@gentwo.org>
References: <20091001212521.123389189@gentwo.org> <20091001212559.879284755@gentwo.org> <4AC7279B.3050901@kernel.org> <alpine.DEB.1.10.0910051038410.16359@gentwo.org> <4ACA0A4F.3090004@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Oct 2009, Tejun Heo wrote:

> > Because it has to be called immediately after per cpu areas become
> > available. Otherwise page allocator uses will fail.
>
> But... setup_per_cpu_area() isn't supposed to call page allocator and
> start_kernel() is the only caller of setup_per_cpu_areas().

setup_per_cpu_areas() is not calling the page allocator. However, any
caller after that can call the page allocator.

There are various arch implementations that do their own implementation of
setup_per_cpu_areas() at their own time (Check sparc and ia64 for
example).


