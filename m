Return-Path: <linux-kernel-owner+w=401wt.eu-S933753AbXFEWn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933753AbXFEWn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 18:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758215AbXFEWnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 18:43:17 -0400
Received: from smtp-out.google.com ([216.239.45.13]:9497 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763433AbXFEWnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 18:43:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=lwASzttvphcbP4F9Lk5Ia5fMTTs4kIbyV+ZRhbMUOuVzDs+jbeD7a5R3+yRb0o3du
	tGUfWqocX1RphZRZlommQ==
Date: Tue, 5 Jun 2007 15:42:57 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <clameter@sgi.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Christoph Lameter <clameter@cthulhu.engr.sgi.com>,
       Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] cpusets: do not allow TIF_MEMDIE tasks to allocate
 globally
In-Reply-To: <Pine.LNX.4.64.0706051540001.5948@schroedinger.engr.sgi.com>
Message-ID: <alpine.DEB.0.99.0706051542320.14176@chino.kir.corp.google.com>
References: <alpine.DEB.0.99.0706051537450.13200@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0706051540001.5948@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2007, Christoph Lameter wrote:

> On Tue, 5 Jun 2007, David Rientjes wrote:
> 
> > Reverts git commit c596d9f320aaf30d28c1d793ff3a976dee1db8f5.
> > 
> > OOM-killed tasks, marked as TIF_MEMDIE, should not be able to access 
> > memory outside its cpuset because it could potentially cause other 
> > exclusive cpusets to OOM themselves.
> 
> Those terminating tasks need that memory to terminate properly right?
> 

No, they need access only to the memory reserves provided by the 
difference in their low and no watermarks on a per-cpuset basis.
