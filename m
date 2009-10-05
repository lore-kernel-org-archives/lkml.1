Return-Path: <linux-kernel-owner+w=401wt.eu-S1752888AbZJEPW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbZJEPW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 11:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751788AbZJEPW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 11:22:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:52087 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021AbZJEPW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 11:22:56 -0400
Message-ID: <4ACA0EFD.4070607@kernel.org>
Date: Tue, 06 Oct 2009 00:21:33 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, mingo@elte.hu, rusty@rustcorp.com.au,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [this_cpu_xx V4 12/20] Move early initialization of pagesets
 out of zone_wait_table_init()
References: <20091001212521.123389189@gentwo.org> <20091001212559.879284755@gentwo.org> <4AC7279B.3050901@kernel.org> <alpine.DEB.1.10.0910051038410.16359@gentwo.org> <4ACA0A4F.3090004@kernel.org> <alpine.DEB.1.10.0910051105070.16359@gentwo.org>
In-Reply-To: <alpine.DEB.1.10.0910051105070.16359@gentwo.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 05 Oct 2009 15:21:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Tue, 6 Oct 2009, Tejun Heo wrote:
> 
>>> Because it has to be called immediately after per cpu areas become
>>> available. Otherwise page allocator uses will fail.
>> But... setup_per_cpu_area() isn't supposed to call page allocator and
>> start_kernel() is the only caller of setup_per_cpu_areas().
> 
> setup_per_cpu_areas() is not calling the page allocator. However, any
> caller after that can call the page allocator.
> 
> There are various arch implementations that do their own implementation of
> setup_per_cpu_areas() at their own time (Check sparc and ia64 for
> example).

sparc is doing everything on setup_per_cpu_areas().  ia64 is an
exception.  Hmmm... I really don't like scattering mostly unrelated
init call to every setup_per_cpu_areas() implementation.  How about
adding "static bool initialized __initdata" to the function and allow
it to be called earlier when necessary (only ia64 at the moment)?

Thanks.

-- 
tejun
