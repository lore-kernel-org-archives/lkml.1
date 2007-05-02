Return-Path: <linux-kernel-owner+w=401wt.eu-S1754915AbXEBHWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915AbXEBHWt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 03:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754909AbXEBHWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 03:22:49 -0400
Received: from smtp-out.google.com ([216.239.45.13]:13720 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753AbXEBHWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 03:22:47 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=Xh3SxKBafFPDtmstVkQVr4cAprro9HfeIZfulCT/sqJKuONrYnbjxvSACgKVf0HRy
	5G3sjdTGdmamct0++aKsw==
Date: Wed, 2 May 2007 00:22:24 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 01/10] compiler: define __attribute_unused__
In-Reply-To: <1178089444.28659.246.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0705020020420.22717@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0705012118130.19277@chino.kir.corp.google.com> 
 <1178084403.28659.222.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0705012254160.21685@chino.kir.corp.google.com> 
 <1178087393.28659.238.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0705012336430.22339@chino.kir.corp.google.com>
 <1178089444.28659.246.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007, Rusty Russell wrote:

> 	That sounds exactly right to me!  If the author says it's optional, it
> might be discarded.  If they say it's needed, it won't be.  At least,
> when I'm coding and gcc warns me something is unused, this is the
> decision I have to make ("is this really needed or not?").
> 

Hi Rusty,

There are many instances in the tree of functions that have no callers 
whatsoever because they've been commented out temporarily, disabled 
through configuration, etc.  These are marked __attribute__ ((unused)) 
right now so that the compiler doesn't emit a warning (and with gcc >=3.4 
it doesn't even emit code for them).  What's __optional about these 
functions if they have no callers?  They're unused.  So we cover all our 
bases with __maybe_unused.
