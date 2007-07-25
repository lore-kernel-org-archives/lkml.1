Return-Path: <linux-kernel-owner+w=401wt.eu-S1765283AbXGYHtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765283AbXGYHtY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 03:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763343AbXGYHsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 03:48:40 -0400
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:49805 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762999AbXGYHsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 03:48:38 -0400
Subject: Re: [PATCH 0/3] readahead drop behind and size adjustment
From: Eric St-Laurent <ericstl34@sympatico.ca>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Fengguang Wu <fengguang.wu@gmail.com>, Dave Jones <davej@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel <linux-kernel@vger.kernel.org>, riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tim Pepper <lnxninja@us.ibm.com>, Chris Snook <csnook@redhat.com>
In-Reply-To: <46A6F732.3080905@yahoo.com.au>
References: <20070721210005.000228000@chello.nl>
	 <20070722023923.GA6438@mail.ustc.edu.cn> <20070722024428.GA724@redhat.com>
	 <20070722081010.GA6317@mail.ustc.edu.cn>
	 <1185093236.6344.87.camel@localhost.localdomain>
	 <46A46E4B.7050007@yahoo.com.au> <1185338106.7105.44.camel@perkele>
	 <46A6DD7F.1050505@yahoo.com.au> <1185344325.7105.91.camel@perkele>
	 <46A6F732.3080905@yahoo.com.au>
Content-Type: text/plain
Date: Wed, 25 Jul 2007 03:48:31 -0400
Message-Id: <1185349711.7105.154.camel@perkele>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-25-07 at 17:09 +1000, Nick Piggin wrote:

> 
> A new list could be a possibility. One problem with adding lists is just
> trying to work out how to balance scanning rates between them, another
> problem is CPU overhead of moving pages from one to another... 

Disk sizes seem to increase more rapidly that the ability to read them
quickly.  Fortunately the processing power increase greatly too.

It may be a good idea to spend more CPU cycles to better decide how the
VM should juggle with this data. We've got to keep those multi-cores cpu
busy.


> but don't
> let me stop you if you want to jump in and try something :)
> 

Well I might try a few things along the way.

But I prefer the thorough approach versus tinkering... 

- Read all research, check competition
- Build test virtual machines, with benchmarks and typical workloads
- Add (or use) some instrumentation to the pagecache
- Code a simulator
- Try all algorithms, tune them

This is way overkill for a part-time hobby.

If we don't see much work on this area it's surely because it's really
not a problem anymore for most workloads. Database have their own cache
management and disk scheduling, file servers just add more ram or
processors, etc.


> OK here is one which just changes the rate that the active and inactive
> lists get scanned. Data corruption bugs should be minimal ;)
> 

Will test.


- Eric


