Return-Path: <linux-kernel-owner+w=401wt.eu-S1755391AbXFFHjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391AbXFFHjx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 03:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbXFFHjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 03:39:46 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56491 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751359AbXFFHjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 03:39:46 -0400
Date: Wed, 6 Jun 2007 00:39:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Jackson <pj@sgi.com>
Cc: David Rientjes <rientjes@google.com>, peterz@infradead.org, ak@suse.de,
       clameter@cthulhu.engr.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] cpusets: do not allow TIF_MEMDIE tasks to allocate
 globally
Message-Id: <20070606003920.4374f08a.akpm@linux-foundation.org>
In-Reply-To: <20070606003421.1107a8bf.pj@sgi.com>
References: <alpine.DEB.0.99.0706051537450.13200@chino.kir.corp.google.com>
	<1181110846.7348.154.camel@twins>
	<alpine.DEB.0.99.0706052334280.30783@chino.kir.corp.google.com>
	<1181113753.7348.164.camel@twins>
	<alpine.DEB.0.99.0706060012260.15316@chino.kir.corp.google.com>
	<20070606003421.1107a8bf.pj@sgi.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2007 00:34:21 -0700 Paul Jackson <pj@sgi.com> wrote:

> > a separate exclusive cpuset mlock'd a gigantic amount of 
> > memory and it could not reliably exit because the mlock continued to 
> > allocate outside its own cpuset and eventually OOM'd system-critical tasks 
> > or depleated all system memory.
> 
> Seems like that mlock code is able then to get great globs of memory
> without returning to user space ... perhaps that's where the fix
> should be ... that code should quit chewing up memory if it's
> marked MEMDIE or some such?

yup.  A fix for that is in the pipeline: bale from get_user_pages()
if TIF_MEMDIE is set.
