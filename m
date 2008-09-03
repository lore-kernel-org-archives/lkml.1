Return-Path: <linux-kernel-owner+w=401wt.eu-S1755469AbYICFZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbYICFZb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 01:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985AbYICFZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 01:25:23 -0400
Received: from abydos.nerdbox.net ([216.151.149.55]:36925 "EHLO
	abydos.NerdBox.Net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbYICFZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 01:25:22 -0400
Date: Tue, 2 Sep 2008 22:25:21 -0700 (PDT)
From: Steve VanDeBogart <vandebo-lkml@NerdBox.Net>
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: jiayingz@google.com, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net, dkegel@google.com
Subject: Re: [uml-devel] [PATCH 4/6] VM: Annotate pagealloc
In-Reply-To: <84144f020808300357l9dddda4y726622641ac7f592@mail.gmail.com>
Message-ID: <alpine.DEB.1.00.0809022209100.15543@abydos.NerdBox.Net>
References: <alpine.DEB.1.00.0808281139420.15543@abydos.NerdBox.Net> <alpine.DEB.1.00.0808291616170.15543@abydos.NerdBox.Net> <84144f020808300357l9dddda4y726622641ac7f592@mail.gmail.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Aug 2008, Pekka Enberg wrote:

> Hi Steve,
>
> On Sat, Aug 30, 2008 at 2:16 AM, Steve VanDeBogart
> <vandebo-lkml@nerdbox.net> wrote:
>> Valgrind annotations for valgrind: memory is addressable once it's been
>> alloced, and unaddressable when it is freed again.  Can't use malloc-like
>> and free-like because valgrind considers a malloc-like chunk indivisible.
>>
>> Signed-off-by: Steve VanDeBogart <vandebo-lkml@nerdbox.net>
>> ---
>>
>> Index: linux-2.6.27-rc5/mm/page_alloc.c
>> @@ -1080,6 +1081,7 @@
>>                if (!page)
>>                        goto failed;
>>        }
>> +       VALGRIND_MAKE_MEM_UNDEFINED(page_address(page), PAGE_SIZE << order);
>
> No SHOUTING macros please, and I think you should just pass page and
> order here and do the calculation elsewhere.

Valgrind provides a header file that defines these annotation functions.
For the ease of tracking changes to this header file, I've made minimal
changes to it (just a couple lines to integrate with Kconfig).  If the
interfaces and/or style is objectionable to the kernel community at
large, than we will have to decide to either wrap the interface that
Valgrind provides or modify the header and track changes manually.

--
Steve
