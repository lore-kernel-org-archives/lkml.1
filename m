Return-Path: <linux-kernel-owner+w=401wt.eu-S1752731Ab0AZDOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab0AZDOm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 22:14:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002Ab0AZDOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 22:14:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:41657 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706Ab0AZDOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 22:14:40 -0500
Message-ID: <4B5E5D3B.7040102@kernel.org>
Date: Tue, 26 Jan 2010 12:10:51 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: "H. Peter Anvin" <hpa@zytor.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org, axboe@kernel.dk, rusty@rustcorp.com.au,
       akpm@linux-foundation.org, ebiederm@xmission.com, tytso@mit.edu,
       Trond.Myklebust@netapp.com, aelder@sgi.com, hch@infradead.org,
       davem@davemloft.net, netdev@vger.kernel.org, x86@kernel.org,
       mingo@redhat.com, dan.j.williams@intel.com, borislav.petkov@amd.com,
       ying.huang@intel.com, lenb@kernel.org, neilb@suse.de,
       cl@linux-foundation.org
Subject: Re: [PATCH 7/8] percpu: add __percpu sparse annotations to	hw_breakpoint
References: <1264432935-10453-1-git-send-email-tj@kernel.org> <1264432935-10453-8-git-send-email-tj@kernel.org> <20100126001901.GI5087@nowhere> <4B5E3F2C.2010702@zytor.com> <4B5E4E12.7060900@kernel.org> <20100126020452.GB19799@ZenIV.linux.org.uk> <4B5E508A.1030305@kernel.org> <20100126023238.GC19799@ZenIV.linux.org.uk> <4B5E56EC.2090600@kernel.org> <20100126024857.GD19799@ZenIV.linux.org.uk>
In-Reply-To: <20100126024857.GD19799@ZenIV.linux.org.uk>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 26 Jan 2010 03:04:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 01/26/2010 11:48 AM, Al Viro wrote:
> On Tue, Jan 26, 2010 at 11:43:56AM +0900, Tejun Heo wrote:
> 
>>> Eh...  You are leaving that noderef in place in case of array.  And _that_
>>> is not an address space, so casts to AS 0 won't do you any good.
>>
>> Any ideas on how to fix it?
> 
> BTW, before we go any further, which warnings are you getting from sparse
> and which version of sparse are you using?
> 
> noderef is one thing; address_space mess is a different story.  The version
> I have here steps into the former, but not the latter; what are you seeing?

Oops, I too am seeing the noderef thing not the address space warning.

 char *estacks = per_cpu(exception_stacks, cpu);

I get

arch/x86/kernel/cpu/common.c:1149:19: warning: incorrect type in initializer (different modifiers)
arch/x86/kernel/cpu/common.c:1149:19:    expected char *estacks
arch/x86/kernel/cpu/common.c:1149:19:    got char [noderef] *<noident>
  CC      arch/x86/kernel/cpu/common.o

$ rpm -qi sparse
Name        : sparse                       Relocations: (not relocatable)
Version     : 0.4.1.git1                        Vendor: openSUSE
Release     : 3.2                           Build Date: Sat 24 Oct 2009 11:58:16 AM KST

Thanks.

-- 
tejun
