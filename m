Return-Path: <linux-kernel-owner+w=401wt.eu-S1756915AbZFCLnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915AbZFCLnm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 07:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754459AbZFCLne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 07:43:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33536 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754047AbZFCLne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 07:43:34 -0400
Message-ID: <4A266186.8010303@redhat.com>
Date: Wed, 03 Jun 2009 13:41:58 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       George Dunlap <george.dunlap@eu.citrix.com>,
       David Miller <davem@davemloft.net>, jeremy@goop.org, avi@redhat.com,
       xen-devel@lists.xensource.com, x86@kernel.org,
       linux-kernel@vger.kernel.org, Keir Fraser <Keir.Fraser@eu.citrix.com>,
       torvalds@linux-foundation.org, gregkh@suse.de, kurt.hackel@oracle.com,
       Ian Pratt <Ian.Pratt@eu.citrix.com>, xen-users@lists.xensource.com,
       ksrinivasan <ksrinivasan@novell.com>, EAnderson@novell.com,
       wimcoekaerts@wimmekes.net, Stephen Spector <stephen.spector@citrix.com>,
       jens.axboe@oracle.com, npiggin@suse.de
Subject: Re: Merge Xen (the hypervisor) into Linux
References: <20090602232843.GA6577@elte.hu> <793c2ffe-16d3-4e6c-9cd2-32fa089e46a3@default> <20090603024311.GZ31943@mit.edu> <4A26263A.7010809@redhat.com> <20090603094753.6eb32099@lxorguk.ukuu.org.uk> <4A263DD3.3090901@redhat.com> <20090603111541.GC31943@mit.edu>
In-Reply-To: <20090603111541.GC31943@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/09 13:15, Theodore Tso wrote:
> On Wed, Jun 03, 2009 at 11:09:39AM +0200, Gerd Hoffmann wrote:
>> It wasn't my intention to imply that.  The interface can be extended
>> when needed.  PAT support will probably be such a case.  Changing it in
>> incompatible ways isn't going to work though.
>
> But that means that if there is some fundamentally broken piece of
> dom0 design, that the Linux kernel will be stuck with it ***forever***
> and it will contaminate code paths and make the code harder to
> maintain ***forever*** if we consent to the Xen merge?

No.  Xen is stuck with it forever (or at least for a few releases). 
Even when adding new & better dom0/xen interfaces in the merge process 
Xen has to keep the old ones to handle the other dom0 guests (NetBSD, 
Solaris, old 2.6.18 out-of-tree linux kernel).  Pretty much like the 
linux kernel has to keep old syscalls to not break the ABI for the 
applications, xen has to maintain old hypercalls[1].

Other way around:  Apps can use new system calls only when running one 
recent kernels, and they have to deal with -ENOSYS.  Likewise it might 
be that the pv_ops-based dom0 kernel can provide some features only when 
running on a recent hypervisor.  That will likely be the case for PAT.

cheers,
   Gerd

[1] and other interfaces like trap'n'emulate certain instructions.
