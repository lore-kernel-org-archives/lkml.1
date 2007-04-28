Return-Path: <linux-kernel-owner+w=401wt.eu-S1030843AbXD1BZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030843AbXD1BZu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 21:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030826AbXD1BZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 21:25:50 -0400
Received: from smtp-out.google.com ([216.239.45.13]:63482 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030825AbXD1BZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 21:25:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:subject:from:reply-to:to:cc:in-reply-to:references:
	content-type:organization:date:message-id:mime-version:x-mailer:content-transfer-encoding;
	b=eHDspvxDD/nwd3xHR0r3+usozX+9bzqp3qVcX/BwzNrHX7teRofeKNHLcG2DuRzGv
	r0PLrOBEs3oLkXyn0jLXg==
Subject: Re: Fw: [PATCH] ia64: race flushing icache in do_no_page path
From: Rohit Seth <rohitseth@google.com>
Reply-To: rohitseth@google.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Mike Stroyan <mike.stroyan@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>, "Luck, Tony" <tony.luck@intel.com>,
       linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <4631E49C.2030501@yahoo.com.au>
References: <20070425205548.fd51b301.akpm@linux-foundation.org>
	 <46305A8D.2080003@yahoo.com.au> <20070426173544.GA30744@ldl.fc.hp.com>
	 <4631E49C.2030501@yahoo.com.au>
Content-Type: text/plain
Organization: Google Inc
Date: Fri, 27 Apr 2007 18:24:39 -0700
Message-Id: <1177723479.13482.371.camel@galaxy.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-27 at 21:55 +1000, Nick Piggin wrote:

> That's the theory. However, I'd still like to know how the arch code can
> make the assertion that icache is known to be at all times other than at
> the time of a fault?
> 

Kernel needs to only worry about the updates that it does.  So, if
kernel is writing into a page that is getting marked with execute
permission then it will need to make sure that caches are coherent.
ia64 Kernel keeps track of whether it has done any write operation on a
page or not using PG_arch_1.  And accordingly flushes icaches.

> Ie. what if an operation which causes incoherency is carried out _after_
> an executable mapping is installed for that page.
> 

You mean by user space? If so, then it is user space responsibility to
do the appropriate operations (like flush icache in this case).

-rohit

