Return-Path: <linux-kernel-owner+w=401wt.eu-S1754844AbXFFHe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844AbXFFHe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 03:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbXFFHeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 03:34:21 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:39542 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751738AbXFFHeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 03:34:20 -0400
Date: Wed, 6 Jun 2007 00:34:21 -0700
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: peterz@infradead.org, akpm@linux-foundation.org, ak@suse.de,
       clameter@cthulhu.engr.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] cpusets: do not allow TIF_MEMDIE tasks to allocate
 globally
Message-Id: <20070606003421.1107a8bf.pj@sgi.com>
In-Reply-To: <alpine.DEB.0.99.0706060012260.15316@chino.kir.corp.google.com>
References: <alpine.DEB.0.99.0706051537450.13200@chino.kir.corp.google.com>
	<1181110846.7348.154.camel@twins>
	<alpine.DEB.0.99.0706052334280.30783@chino.kir.corp.google.com>
	<1181113753.7348.164.camel@twins>
	<alpine.DEB.0.99.0706060012260.15316@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> a separate exclusive cpuset mlock'd a gigantic amount of 
> memory and it could not reliably exit because the mlock continued to 
> allocate outside its own cpuset and eventually OOM'd system-critical tasks 
> or depleated all system memory.

Seems like that mlock code is able then to get great globs of memory
without returning to user space ... perhaps that's where the fix
should be ... that code should quit chewing up memory if it's
marked MEMDIE or some such?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
