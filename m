Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932852Ab0CJXF4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 18:05:56 -0500
Received: from smtp-out.google.com ([216.239.33.17]:25155 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757385Ab0CJXFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 18:05:55 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=QqCt9k+2P3qLLobghH59c0StF9mBk5ZcnwArOHjFMkRKJwjaLvQBNqSW1/SncYlN5
	Gc6J0BpmtW61jZ6sy4BKg==
Date: Wed, 10 Mar 2010 15:05:47 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Greg KH <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] numa: fix BUILD_BUG_ON for node_read_distance
In-Reply-To: <20100310225841.GA6536@suse.de>
Message-ID: <alpine.DEB.2.00.1003101501330.15549@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1003101449480.21849@chino.kir.corp.google.com> <20100310225841.GA6536@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Mar 2010, Greg KH wrote:

> > node_read_distance() has a BUILD_BUG_ON() to prevent buffer overruns when
> > the number of nodes printed will exceed the buffer length.
> > 
> > Each node only needs four chars: three for distance (maximum distance is
> > 255) and one for a seperating space or a trailing newline.
> 
> Is this causing a problem as-is today that we need to resolve for
> 2.6.34?  Or is this 2.6.35 material?
> 

It's not needed at least for x86 for 2.6.34 since the max 
CONFIG_NODES_SHIFT is 9.  I don't know about other architectures with 
different ranges or page sizes.

I'm going to push a change to the x86 maintainers to increase that max 
CONFIG_NODES_SHIFT to 10 hopefully for 2.6.35, that's where we run into 
this error.

> Who chose this original number, and why is it off by 1/2?
> 

It's earlier than the git history, but there's no reason to divide 
PAGE_SIZE in half.  We've been running machines with this patch for well 
over a year and /sys/devices/system/node/nodeN/distance works just fine 
with 1K nodes.
