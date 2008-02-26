Return-Path: <linux-kernel-owner+w=401wt.eu-S1764259AbYBZVDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764259AbYBZVDX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 16:03:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbYBZVDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 16:03:15 -0500
Received: from smtp-out.google.com ([216.239.45.13]:13305 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbYBZVDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 16:03:14 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=NnqWSEPhpemVNMczKNHWBY64I8Z706ROGzHfifxXE/J7WQk96p92Syg5jbX9hEYCn
	6rymnbvfnSsJfCuTmViOQ==
Date: Tue, 26 Feb 2008 13:02:54 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: akpm@linux-foundation.org, clameter@sgi.com, Lee.Schermerhorn@hp.com,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/6] mempolicy: add MPOL_F_STATIC_NODES flag
In-Reply-To: <20080226115627.681dafb9.pj@sgi.com>
Message-ID: <alpine.DEB.1.00.0802261253510.10790@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802250012420.12368@chino.kir.corp.google.com> <alpine.DEB.1.00.0802250013580.12368@chino.kir.corp.google.com> <alpine.DEB.1.00.0802250014170.12368@chino.kir.corp.google.com> <20080226115627.681dafb9.pj@sgi.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008, Paul Jackson wrote:

> >         return do_mbind(start, len, mode, mode_flags, &nodes, flags);
> 
> The intermingling of 'flags', 'mode' and 'mode_flags' to refer to the
> low bits, the high bits or all the bits of the flags field is handled
> fairly carefully in your patch, but can still be a bit difficult to
> keep track of which is which when reading.
> 
> I'll wager not many readers can immediately say what the 'mode',
> 'mode_flags' and 'flags' refer to, in the above code snippet, for
> example.
> 
> Do you have any suggestions on how to further improve the clarity of
> this code?
> 

This is a natural implementation detail to accomodate your insistance that 
the mode and flags be passed as separate actuals throughout many of the 
mm/mempolicy.c functions.

No reader is going to understand immediately what 'mode', 'mode_flags', 
and 'flags' are if you only provide a single line of the code like that. 

It becomes rather obvious what they represent when you read the entire 
sys_mbind() implementation, which is serving a syscall that provides its 
own formal for passing flags.  The name 'mode_flags' is exactly what it 
is: flags for the mempolicy mode.

		David
