Return-Path: <linux-kernel-owner+w=401wt.eu-S934123AbXFFD3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934123AbXFFD3X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 23:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbXFFD3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 23:29:15 -0400
Received: from smtp-out.google.com ([216.239.45.13]:31551 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbXFFD3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 23:29:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=kSDmyLgEjkgwn0zcr+E02FfJXAhiqj5tnKmDQRFwI6KiByeexbpYdV9T/jkrVoi+o
	eb0GHFZvLgBS3SXAwSUoA==
Date: Tue, 5 Jun 2007 20:29:01 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <clameter@sgi.com>
cc: Paul Jackson <pj@sgi.com>, akpm@linux-foundation.org, ak@suse.de,
       clameter@cthulhu.engr.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] cpusets: do not allow TIF_MEMDIE tasks to allocate
 globally
In-Reply-To: <Pine.LNX.4.64.0706051851350.7159@schroedinger.engr.sgi.com>
Message-ID: <alpine.DEB.0.99.0706052026130.30783@chino.kir.corp.google.com>
References: <alpine.DEB.0.99.0706051537450.13200@chino.kir.corp.google.com>
 <20070605160149.348b5c4a.pj@sgi.com> <alpine.DEB.0.99.0706051608090.16201@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0706051619130.6192@schroedinger.engr.sgi.com>
 <alpine.DEB.0.99.0706051620580.17032@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0706051629270.6295@schroedinger.engr.sgi.com>
 <alpine.DEB.0.99.0706051633590.17626@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0706051653330.6473@schroedinger.engr.sgi.com>
 <alpine.DEB.0.99.0706051817380.23799@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0706051826310.6928@schroedinger.engr.sgi.com>
 <alpine.DEB.0.99.0706051837310.23799@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0706051851350.7159@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2007, Christoph Lameter wrote:

> Hmmmm... But we have sent it a SIGKILL. If the process is following 
> conventions then it is exiting. Of course the process could be abusing the 
> system and attempting to OOM the whole system as an act of revenge for 
> being killed but isnt this a bit far fetched?
> 

It's not abusing the system because it was killed, it was killed because 
it was abusing the system and attempted to mlock more memory than allowed 
in its exclusive mems.  So we OOM the task but it can continue mlock'ing 
memory and intrude on the memory of other cpusets because of the 
TIF_MEMDIE exception and our SIGKILL hasn't been handled yet.
