Return-Path: <linux-kernel-owner+w=401wt.eu-S933947AbXFEX0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933947AbXFEX0p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 19:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763545AbXFEX0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 19:26:36 -0400
Received: from smtp-out.google.com ([216.239.45.13]:13298 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762844AbXFEX0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 19:26:36 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=P/iYw2HeutaiTjcl34AME9D8xMjzVigfCmkJhOfMp0WNVd92hJvyUfZR0YMZhk8j1
	gJ65hcwfVxLsITcBH1cUA==
Date: Tue, 5 Jun 2007 16:25:48 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <clameter@sgi.com>
cc: Paul Jackson <pj@sgi.com>, akpm@linux-foundation.org, ak@suse.de,
       clameter@cthulhu.engr.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] cpusets: do not allow TIF_MEMDIE tasks to allocate
 globally
In-Reply-To: <Pine.LNX.4.64.0706051619130.6192@schroedinger.engr.sgi.com>
Message-ID: <alpine.DEB.0.99.0706051620580.17032@chino.kir.corp.google.com>
References: <alpine.DEB.0.99.0706051537450.13200@chino.kir.corp.google.com>
 <20070605160149.348b5c4a.pj@sgi.com> <alpine.DEB.0.99.0706051608090.16201@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0706051619130.6192@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2007, Christoph Lameter wrote:

> But the alternative is that the exiting process does not save its 
> data.
> 

The same condition that occurs when there is a system-wide OOM, yes.  
Exclusive cpusets cannot be violated for such allocations outside of the 
obvious GFP_ATOMIC exception.

> What is this very small exclusive cpuset?
> 

That's arbitrary.  The idea is that an exclusive cpuset should not 
encounter memory pressure because another exclusive cpuset encountered an 
OOM condition because its zones happened to be higher on the zonelist.  
Notice how, without this change, it's possible to allocate on a node 
outside our mems_allowed before we use our own memory reserves.

		David
