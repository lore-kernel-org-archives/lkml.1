Return-Path: <linux-kernel-owner+w=401wt.eu-S1758690AbYJOONl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690AbYJOONl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 10:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756828AbYJOOIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 10:08:46 -0400
Received: from mx2.compro.net ([216.54.166.4]:18317 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756824AbYJOOIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 10:08:45 -0400
X-Greylist: delayed 855 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Oct 2008 10:08:45 EDT
X-IronPort-AV: E=Sophos;i="4.33,416,1220241600"; 
   d="scan'208";a="2958792"
Message-ID: <48F5F614.3080008@compro.net>
Date: Wed, 15 Oct 2008 09:54:28 -0400
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Kaz Kylheku <kkylheku@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: GPL question: using large contiguous memory in proprietary driver.
References: <3f43f78b0810141456r159d71e7h9763e50e7dbc0c51@mail.gmail.com>
In-Reply-To: <3f43f78b0810141456r159d71e7h9763e50e7dbc0c51@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kaz Kylheku wrote:
> Hi all,
> 
> I have the following question. Suppose that some proprietary driver
> (otherwise completely clean, based only on non-GPL symbols)
> requires a large buffer of physically contiguous memory.
> 
> A GPL-ed driver could get this memory by having some boot-time
> code compiled into the kernel which calls bootmem_alloc during
> kernel initialization. This function would stash the address of the
> memory into some global variable which is exported for the
> module to use.
> 
> How do you solve this problem in a proprietary driver? It seems
> like the above solution taints the kernel, because the kernel
> provides a symbol which exists only for the sake of supporting
> a proprietary driver.
> 
> Would it be okay to have a mechanism like this:
> Suppose that  on the kernel command line, you could
> request a boot-time memory allocation and give it a name.
> For instance, the parameter:
> 
>    boot_alloc=foo,8192K
> 
> would create an 8192 kilobyte allocation, and associate it
> with the string "foo".   A non-GPL function would be provided to
> find the address of this memory, using the string "foo"
> as the key. The proprietary driver would document the
> requirement that it needs a memory region of at least
> 8192K, under the name "foo".
> 
> Help! :)

Hardware with scatter/gatcher capabilites would be best. But short
of that, you could just use the bigphysarea patch. GOOGLE for it and you'll
find a version suitable for most kernel versions. I've been using it for years with
a GPL driver but even if the driver wasn't GPL I would still be using it.

I sure wish it could be included in the kernel??

There really aren't many good reasons not to GPL your driver BTW.

Mark
