Return-Path: <linux-kernel-owner+w=401wt.eu-S1764167AbZAIBLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764167AbZAIBLi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 20:11:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757953AbZAIBL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 20:11:28 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59705 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752568AbZAIBL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 20:11:28 -0500
Date: Thu, 8 Jan 2009 17:10:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, pq@iki.fi,
       srostedt@redhat.com
Subject: Re: [PATCH 3/3] mmiotrace: count events lost due to not recording
Message-Id: <20090108171048.5e138f8d.akpm@linux-foundation.org>
In-Reply-To: <20090109002840.800960698@goodmis.org>
References: <20090109002747.240318148@goodmis.org>
	<20090109002840.800960698@goodmis.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Jan 2009 19:27:50 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> +static atomic_t dropped_count;

Formally, this should be

	static atomic_t dropped_count = ATOMIC_INIT(0);

but no atomic_t implementations need that, and I'm sure that if one
turns up wchih _does_ need it (say, it has a spinlock inside its
atomic_t) then the kernel would break all over the place.

So perhaps we should formally state that the all-zeroes pattern is an
acceptable way of initialising an atomic_t.


In which case these:

y:/usr/src/linux-2.6.28> grep -r "atomic_t.*=.*ATOMIC_INIT" . | wc -l
110

become cleanup fodder.
