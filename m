Return-Path: <linux-kernel-owner+w=401wt.eu-S1757741AbYE3K25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757741AbYE3K25 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 06:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755583AbYE3K2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 06:28:04 -0400
Received: from smtp2f.orange.fr ([80.12.242.151]:3023 "EHLO smtp2f.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753998AbYE3K2A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 06:28:00 -0400
X-ME-UUID: 20080530060108722.B0715700008B@mwinf2f03.orange.fr
Message-ID: <483F981E.3040004@cosmosbay.com>
Date: Fri, 30 May 2008 08:01:02 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <clameter@sgi.com>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>
Subject: Re: [patch 00/41] cpu alloc / cpu ops v3: Optimize per cpu access
References: <20080530035620.587204923@sgi.com>	<20080529215827.b659d032.akpm@linux-foundation.org>	<Pine.LNX.4.64.0805292159360.12107@schroedinger.engr.sgi.com> <20080529222143.5d7aa1e5.akpm@linux-foundation.org>
In-Reply-To: <20080529222143.5d7aa1e5.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton a écrit :
>
> It was just an example.  There will be others.
>
> 	tcp_v4_md5_do_add
> 	->tcp_alloc_md5sig_pool
> 	  ->__tcp_alloc_md5sig_pool
>
> does an alloc_percpu for each md5-capable TCP connection.  I think - it
> doesn't matter really, because something _could_.  And if something
> _does_, we're screwed.
>   
Last time I took a look on this stuff, this was a percpu allocation for 
all connections, not for each TCP session.
(It should be static, instead of dynamic )

Really, percpu allocations are currently not frequent at all.

vmalloc()/vfreee() are way more frequent and still use a list.





