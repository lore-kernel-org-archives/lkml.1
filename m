Return-Path: <linux-kernel-owner+w=401wt.eu-S1755580AbYJWWxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580AbYJWWxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 18:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbYJWWxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 18:53:11 -0400
Received: from ozlabs.org ([203.10.76.45]:49832 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124AbYJWWxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 18:53:11 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 00/35] cpumask: Replace cpumask_t with struct cpumask
Date: Fri, 24 Oct 2008 09:53:15 +1100
User-Agent: KMail/1.9.10
Cc: Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <20081023020826.051012000@polaris-admin.engr.sgi.com> <20081023120322.GC25132@elte.hu>
In-Reply-To: <20081023120322.GC25132@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810240953.15814.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 October 2008 23:03:22 Ingo Molnar wrote:
> I also added "Impact:" lines to every commit - a one-line summary of the
> expected outcome of the change. (Please double-check those impact lines
> - if you see anything odd it means that i missed some detail in the
> commit - that will need to be fixed if it happens.)

Note that "removed" and "deprecated" are using the terms loosely.  No old API 
was removed, and I didn't actually mark anything __deprecated (I just 
documented it in the header).

Here are my revisions:

f1ad2eefc7644467a5b8bec38b540f40260f0f03:
cpumask: cpu_all_mask and cpu_none_mask
    
-Impact: introduce new constants, convert old usage to them
+Impact: introduce new constants, convert core files.


88e316949934e187e4f131d99bf156413632e56b
cpumask: deprecate any_online_cpu() in favour of cpumask_any/cpumask_any_and
    
-Impact: cleanup
+Impact: new API, deprecate old


4d57c437e6d239f46a881fdb04a57fb2664bfc97
cpumask: cpumask_first/cpumask_next
    
-Impact: remove old API, convert all users to new API
+Impact: new API, deprecate old 
(We convert one place only)


dfa1385db10e1b1d5a1687f0184d9c11735192aa
cpumask: for_each_cpu(): for_each_cpu_mask which takes a pointer
    
-Impact: remove old API, convert all users to new API
+Impact: remove old API, convert core trivial users

a55659d4f58eaacde2681298d003bbeeafb16436
cpumask: cpumask_of(): cpumask_of_cpu() which returns a pointer
    
-Impact: cleanup
+Impact: new API, deprecate old API.

Thanks,
Rusty.
