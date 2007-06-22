Return-Path: <linux-kernel-owner+w=401wt.eu-S1754860AbXFVHs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbXFVHs1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 03:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751153AbXFVHsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 03:48:19 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:65305 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbXFVHsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 03:48:19 -0400
Message-ID: <467B7EB6.4050207@fr.ibm.com>
Date: Fri, 22 Jun 2007 09:48:06 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Herbert Poetzl <herbert@13thfloor.at>,
       Pavel Emelianov <xemul@openvz.org>
Subject: Re: [PATCH -mm] add a kmem_cache for nsproxy objects
References: <4676F0B9.3080408@fr.ibm.com> <20070619113501.a88bba50.akpm@linux-foundation.org> <Pine.LNX.4.64.0706191222420.7008@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0706191222420.7008@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Tue, 19 Jun 2007, Andrew Morton wrote:
> 
>> On Mon, 18 Jun 2007 22:53:13 +0200
>> Cedric Le Goater <clg@fr.ibm.com> wrote:
>>
>>> +static int __init nsproxy_cache_init(void)
>>> +{
>>> +	nsproxy_cachep = kmem_cache_create("nsproxy", sizeof(struct nsproxy),
>>> +					   0, SLAB_PANIC, NULL, NULL);
>>> +	return 0;
>>> +}
>>> +
>> Christoph added this cheesy KMEM_CACHE macro.  But I don't immediately recall
>> the rationale so I'm a bit reluctant to ask people to use-the-cheesy-macro.
>>
>> Perhaps he can remind us why it is there?
> 
> Because it simplifies the handling of slabs.
> 
> The above will could become:
> 
> nsproxy_cachep = KMEM_CACHE(nsproxy, SLAB_PANIC);
> 
> meaning create a cache for the nsproxy struct, the nsproxy name and the 
> nsproxy size. See include/linux/slab.h.

yes, I should probably use that for the nsproxy struct.

my 2cts :
  
the macro sets the align parameter to "__alignof__(struct)" by default. 
is that something we want to do all the time ? if so, why not change 
kmem_cache_create() directly ?

Most of the complexity is in flags. I did a grep and picked what i thought 
was the most aggressive. The macro would probably be more useful if we could 
identify by it's name in which context it can be used. 


C.

