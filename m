Return-Path: <linux-kernel-owner+w=401wt.eu-S2992765AbXEBG0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992765AbXEBG0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 02:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992823AbXEBG0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 02:26:00 -0400
Received: from smtp-out.google.com ([216.239.45.13]:58581 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992765AbXEBGZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 02:25:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=S0/YaC6o5S3KC85IBDcc8BehWYst2jI96Yw+8jE6fcKk4zG7dOBRFJD+3o9jnNQ11
	wI4ZcWowgGGWiTXBkXj5A==
Date: Tue, 1 May 2007 23:25:38 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 01/10] compiler: define __attribute_unused__
In-Reply-To: <Pine.LNX.4.64.0705012254160.21685@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0705012320560.21985@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0705012118130.19277@chino.kir.corp.google.com>
 <1178084403.28659.222.camel@localhost.localdomain>
 <Pine.LNX.4.64.0705012254160.21685@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2007, David Rientjes wrote:

> The patched version makes this:
> 
> 	int type __attribute_unused__ = 0;
> 
> which definitely tells you that you're using a compiler attribute that 
> will be attached to that automatic.  In your case:
> 
> 	int type __unneeded = 0;
> 
> doesn't say anything in this case.  It doesn't resemble any attribute that 
> a programmer might be familiar with and begs the question of why we've 
> declared it if it's truly "unneeded"?
> 

One possible way to remedy this situation is with __needed and 
__maybe_unneeded.

__needed would be defined to __attribute__ ((used)), which would apply to 
functions only and specify that its code needs to be emitted anyway even 
though it appears to be unreferenced.  This is needed for gcc >=3.4.  In 
gcc <3.4, this gets defined to be __attribute__ ((unused)) to simply 
suppress the warning.  So now all functions that are unreferenced except 
in inline assembly get __needed appended.

__maybe_unneeded would be defined to __attribute__ ((unused)).  It can 
apply to either functions or variables to suppress the warning if they are 
unused.
