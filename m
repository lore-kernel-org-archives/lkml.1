Return-Path: <linux-kernel-owner+w=401wt.eu-S1752557AbXA2SjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557AbXA2SjK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 13:39:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbXA2SjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 13:39:09 -0500
Received: from smtp-out.google.com ([216.239.45.13]:51795 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbXA2SjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 13:39:08 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type:sender;
	b=ShPW6D8XrFd1bGLtA8PCK3J+9MQWi2C7yYIuAgvnHQ06SrtDxnLGkNboOsRWfRq4L
	ggFq/y9x1hbZcU4GH7hjA==
Date: Mon, 29 Jan 2007 10:38:45 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@hadoop0.corp.google.com
To: Andi Kleen <ak@suse.de>
cc: Andrew Morton <akpm@osdl.org>, Rohit Seth <rohitseth@google.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch -mm 3/5] x86_64: fixed-size remaining fake nodes
In-Reply-To: <200701291436.59930.ak@suse.de>
Message-ID: <Pine.LNX.4.56.0701291032160.26116@hadoop0.corp.google.com>
References: <Pine.LNX.4.64N.0701251332280.13206@attu4.cs.washington.edu>
 <Pine.LNX.4.64N.0701251333470.13206@attu4.cs.washington.edu>
 <Pine.LNX.4.64N.0701251334280.13206@attu4.cs.washington.edu>
 <200701291436.59930.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jan 2007, Andi Kleen wrote:

> On Thursday 25 January 2007 22:37, David Rientjes wrote:
> > Any leftover memory is allocated
> > to a final node unless the command-line ends with a comma.
> 
> That sounds like syntactical vinegar and a nasty trap. Remember 
> that venus probe that got lost because of a wrong comma.
> Can you find some nicer syntax for that please? 
> 

The only other appropriate syntax that comes to mind is perhaps a 
command-line that ends with a 0.  For example, numa=fake=2*512,0 would 
allocate two 512M nodes and nothing for the remaining RAM.

> Also it's pretty complex. Are there use cases for all of this? 
> 

There are.  Configurable node sizes (i.e. 'numa=fake=512,4*128', etc) are 
the major concept and help to avoid the overhead associated with something 
like 64 nodes of 64M each on a 4G machine.  We've seen some inefficiencies 
with scanning through so many zone lists on page_alloc when we encounter a 
full node.  Additional support such as 'numa=fake=2*512,*128' are used 
more for machines where you're unsure of their total system RAM in the 
first place but want to make sure you have the node sizes you need.

		David
