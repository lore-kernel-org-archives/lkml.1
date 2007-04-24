Return-Path: <linux-kernel-owner+w=401wt.eu-S1753255AbXDXGBL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbXDXGBL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 02:01:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753948AbXDXGBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 02:01:11 -0400
Received: from smtp-out.google.com ([216.239.45.13]:51120 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbXDXGBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 02:01:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=mLR3QX/c7aHCzW9jbn/uHDZT4Fn/ZQE71DIIo4fluLvnxWMXijx4L74l4CXBrGVNs
	ivRaZEGZ574DUKbUr/T7g==
Date: Mon, 23 Apr 2007 23:00:10 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <clameter@sgi.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] oom: kill all threads that share mm with killed task
In-Reply-To: <Pine.LNX.4.64.0704232242580.5109@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0704232258150.14417@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0704232134430.11399@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0704232242580.5109@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2007, Christoph Lameter wrote:

> Obvious fix. It was broken by
>  
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=f2a2a7108aa0039ba7a5fe7a0d2ecef2219a7584
> Dec 7. So its in 2.6.20 and later. Candiate for stable?
> 

I agree it's obvious enough that it should be included in stable.  
Otherwise the entire iteration becomes a big no-op and it won't alleviate 
the OOM condition in one call to out_of_memory() because there may be 
outstanding tasks with the shared ->mm.

		David
