Return-Path: <linux-kernel-owner+w=401wt.eu-S933910AbZHEA35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933910AbZHEA35 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 20:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933871AbZHEA3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 20:29:54 -0400
Received: from tundra.namei.org ([65.99.196.166]:49525 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933870AbZHEA3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 20:29:52 -0400
Date: Wed, 5 Aug 2009 10:29:29 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: torvalds@osdl.org, akpm@linux-foundation.org, serue@us.ibm.com,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 4/6] KEYS: Add garbage collection for dead, revoked and
 expired keys. [ver #2]
In-Reply-To: <20090804203938.25094.21014.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.LRH.2.00.0908051028100.29562@tundra.namei.org>
References: <20090804203923.25094.78702.stgit@warthog.procyon.org.uk> <20090804203938.25094.21014.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Aug 2009, David Howells wrote:

> +void key_schedule_gc(time_t gc_at)
> +{
> +	unsigned long expires;
> +	time_t now = current_kernel_time().tv_sec;
> +
> +	kenter("%ld", gc_at - now);
> +
> +	gc_at += key_gc_delay;
> +
> +	if (now >= gc_at) {

Should you be using time_after() and friends for these comparisons?


-- 
James Morris
<jmorris@namei.org>
