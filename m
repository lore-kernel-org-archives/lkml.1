Return-Path: <linux-kernel-owner+w=401wt.eu-S933077AbXCFJDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933077AbXCFJDe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 04:03:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933102AbXCFJDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 04:03:34 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:60456 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933077AbXCFJDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 04:03:32 -0500
Message-ID: <45ED2E63.3070700@vmware.com>
Date: Tue, 06 Mar 2007 01:03:31 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Gerd Hoffmann <kraxel@suse.de>, Jeremy Fitzhardinge <jeremy@goop.org>,
       virtualization <virtualization@lists.osdl.org>,
       Jan Beulich <jbeulich@novell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Xen & VMI?
References: <20070305120631.GA14105@elte.hu> <1173101297.26165.39.camel@localhost.localdomain> <1173142644.4644.6.camel@localhost.localdomain> <45ECBDDC.8080708@vmware.com> <45ECC076.9050209@goop.org> <45ECC91D.1020809@vmware.com> <45ECC9B6.1060209@goop.org> <20070306081909.GA9331@elte.hu> <45ED2837.3020108@suse.de> <20070306085222.GA17002@elte.hu>
In-Reply-To: <20070306085222.GA17002@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>>> there are already 5 major hypervisors we are going to support (in 
>>> alphabetical order):
>>>
>>>  - KVM
>>>  - lguest
>>>  - Windows
>>>  - VMWare
>>>  - Xen
>>>
>>> the QA matrix is gonna be a _mess_.
>>>       
>> I fail to see how xen-via-vmirom instead of xen-via-paravirt_ops 
>> reduces the QA effort.  You still have 5 Hypervisors you have to test 
>> against.
>>     
>
> yes, just like we have thousands of separate PC boards to support. But 
> as long as the basic ABI is the same, the QA effort on the Linux kernel 
> side is alot more focused. (Distros still have 18446744073709551616 
> total combinations to QA, and have to make an educated guess to reduce 
> that to a more manageable number.)
>   

But hardware PC boards don't do anything as remotely complicate as 
changing the semantics required for correctness in you MMU 
implementation.  There might be some weird MTRR and caching things, 
which are a property of the architecture, and which all modern boards 
have in common.  You don't have completely diverse implementation 
properties like shadow vs direct vs native page tables.  Or hardware 
virtualization vs direct CPL raised execution.  You simply can't test 
this diversity by making an educated guess, because in this case, 
something will always be omitted.  The test matrix has to be raised, and 
if that is a problem, the burden of proper testing shifted onto the 
manufacturers, just as you would with some new PC board or new 
architecture that wanted to be Linux friendly but was radically 
different in some way.

Zach
