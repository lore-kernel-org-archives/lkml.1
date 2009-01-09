Return-Path: <linux-kernel-owner+w=401wt.eu-S1753547AbZAIB4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbZAIB4k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 20:56:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbZAIB4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 20:56:32 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:45940 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbZAIB4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 20:56:32 -0500
Date: Thu, 8 Jan 2009 20:56:29 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, pq@iki.fi,
       srostedt@redhat.com
Subject: Re: [PATCH 3/3] mmiotrace: count events lost due to not recording
In-Reply-To: <20090108171048.5e138f8d.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0901082054000.18713@gandalf.stny.rr.com>
References: <20090109002747.240318148@goodmis.org> <20090109002840.800960698@goodmis.org> <20090108171048.5e138f8d.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 8 Jan 2009, Andrew Morton wrote:
> 
> y:/usr/src/linux-2.6.28> grep -r "atomic_t.*=.*ATOMIC_INIT" . | wc -l
> 110
> 
> become cleanup fodder.


[linus.git]$ git grep "atomic_t.*=.*ATOMIC_INIT([^0]" |wc -l
13
[linus.git]$ git grep "atomic_t.*=.*ATOMIC_INIT(0" |wc -l
104
[linus.git]$ git grep "atomic_t.*=.*ATOMIC_INIT" |wc -l
117

OK, in current linus.git we have 117 atomic_t using ATOMIC_INIT, where 13 
actually need the init (non zero). But 104 need to be cleaned up ;-)

-- Steve

