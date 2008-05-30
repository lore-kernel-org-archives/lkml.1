Return-Path: <linux-kernel-owner+w=401wt.eu-S1755039AbYE3Oip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039AbYE3Oip (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 10:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752394AbYE3Oih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 10:38:37 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54256 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752007AbYE3Oig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 10:38:36 -0400
Message-ID: <48401169.3050706@sgi.com>
Date: Fri, 30 May 2008 07:38:33 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 00/41] cpu alloc / cpu ops v3: Optimize per cpu access
References: <20080530035620.587204923@sgi.com> <20080529215827.b659d032.akpm@linux-foundation.org> <Pine.LNX.4.64.0805292159360.12107@schroedinger.engr.sgi.com> <20080529222143.5d7aa1e5.akpm@linux-foundation.org> <Pine.LNX.4.64.0805292224540.12329@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0805292224540.12329@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Thu, 29 May 2008, Andrew Morton wrote:
...
>> Plus who knows what lies ahead of us?
> 
> Well invariably we will end up with cpu area defragmentation.... Sigh.
> 
>> I don't think there is presently any upper limit on alloc_percpu()?  It
>> uses kmalloc() and kmalloc_node()?
>>
>> Even if there is some limit, is it an unfixable one?
> 
> No there is no limit. It just wastes lots of space (pointer arrays, 
> alignment etc) that we could use to configure sufficiently large per cpu 
> areas.

Is there any reason why the per_cpu area couldn't be made extensible?  Maybe
a simple linked list of available areas?  (And use a config variable and/or
boot param for initial size and increment size?)  [Ignoring the problem of
reclaiming the space...]
