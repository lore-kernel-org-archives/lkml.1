Return-Path: <linux-kernel-owner+w=401wt.eu-S1753755AbZJEPmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755AbZJEPmn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 11:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753736AbZJEPmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 11:42:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:59033 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753628AbZJEPmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 11:42:42 -0400
Message-ID: <4ACA13A1.4090107@kernel.org>
Date: Tue, 06 Oct 2009 00:41:21 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, mingo@elte.hu, rusty@rustcorp.com.au,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [this_cpu_xx V4 12/20] Move early initialization of pagesets
 out of zone_wait_table_init()
References: <20091001212521.123389189@gentwo.org> <20091001212559.879284755@gentwo.org> <4AC7279B.3050901@kernel.org> <alpine.DEB.1.10.0910051038410.16359@gentwo.org> <4ACA0A4F.3090004@kernel.org> <alpine.DEB.1.10.0910051105070.16359@gentwo.org> <4ACA0EFD.4070607@kernel.org> <alpine.DEB.1.10.0910051126370.16359@gentwo.org>
In-Reply-To: <alpine.DEB.1.10.0910051126370.16359@gentwo.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 05 Oct 2009 15:41:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Tue, 6 Oct 2009, Tejun Heo wrote:
> 
>>> There are various arch implementations that do their own implementation of
>>> setup_per_cpu_areas() at their own time (Check sparc and ia64 for
>>> example).
>> sparc is doing everything on setup_per_cpu_areas().  ia64 is an
>> exception.  Hmmm... I really don't like scattering mostly unrelated
>> init call to every setup_per_cpu_areas() implementation.  How about
>> adding "static bool initialized __initdata" to the function and allow
>> it to be called earlier when necessary (only ia64 at the moment)?
> 
> It would be best to consolidate all setup_per_cpu_areas() to work at the
> same time during bootup. How about having a single setup_per_cpu_areas()
> function and then within the function allow arch specific processing. Try
> to share as much code as possible?

I'm under the impression that ia64 needs its percpu areas setup
earlier during the boot so I'm not sure what you have in mind but as
long as the call isn't scattered over different setup_per_cpu_areas()
implementations, I'm okay.

Thanks.

-- 
tejun

