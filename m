Return-Path: <linux-kernel-owner+w=401wt.eu-S1761225AbXH2Wgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761225AbXH2Wgw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 18:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757046AbXH2Wgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 18:36:45 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:40584 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756934AbXH2Wgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 18:36:44 -0400
Subject: Re: [-mm PATCH]  Memory controller improve user interface
From: Dave Hansen <haveblue@us.ibm.com>
To: balbir@linux.vnet.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux MM Mailing List <linux-mm@kvack.org>,
       David Rientjes <rientjes@google.com>,
       Linux Containers <containers@lists.osdl.org>,
       Paul Menage <menage@google.com>
In-Reply-To: <46D5F2BB.8010203@linux.vnet.ibm.com>
References: <20070829111030.9987.8104.sendpatchset@balbir-laptop>
	 <1188413148.28903.113.camel@localhost>
	 <46D5ED5C.9030405@linux.vnet.ibm.com>
	 <1188425894.28903.140.camel@localhost>
	 <46D5F2BB.8010203@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Wed, 29 Aug 2007 15:36:40 -0700
Message-Id: <1188427000.28903.148.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-30 at 03:57 +0530, Balbir Singh wrote:
> True, mmap() is a good example of such an interface for developers, I
> am not sure about system admins though.
> 
> To quote Andrew
> <quote>
> Reporting tools could run getpagesize() and do the arithmetic, but we
> generally try to avoid exposing PAGE_SIZE, HZ, etc to userspace in this
> manner.
> </quote>

Well, rounding to PAGE_SIZE exposes PAGE_SIZE as well, just in a
non-intuitive fashion. :)

If we're going to modify what the user specifies, we should probably at
least mandate that writes are only a "suggestion" and users must read
back the value to ensure what actually got committed.

If we're going to round in any direction, shouldn't we round up?  If a
user specifies 4097 bytes and uses two pages, we don't want to complain
when they hit that second page.  

-- Dave

