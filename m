Return-Path: <linux-kernel-owner+w=401wt.eu-S1760528AbZCTTpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760528AbZCTTpU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 15:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755786AbZCTTpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 15:45:04 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:44664 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755564AbZCTTpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 15:45:03 -0400
Message-ID: <49C3F1EE.90903@vflare.org>
Date: Sat, 21 Mar 2009 01:13:42 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: cl@linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] xvmalloc memory allocator
References: <ztOQA2Cz.1237575719.7896090.penberg@cs.helsinki.fi>
In-Reply-To: <ztOQA2Cz.1237575719.7896090.penberg@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Antivirus: avast! (VPS 090319-0, 19-03-2009), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> On 3/20/2009, "Christoph Lameter" <cl@linux-foundation.org> wrote:
>>> I think, with a bit playing around with interfaces, it can be turned into
>>> general purpose allocator (this will most probably lack highmem support).
>> Then it would need to implement the SLAB api (see include/linux/slab.h).
>> Thus we are getting slab allocator #5.
> 
> I do not see the point in that. As I suggested earlier, you should
> probably just move this into drivers/block/ and make it a private
> compcache allocator.
> 

Your wish. But, really, we should not dismiss an O(1) allocator with great
space-efficiency so easily. I think it will be great at least for embedded
devices (its counterpart, SLOB is simply funny).

Just to add to this, Xen recently included a variant of TLSF allocator
which was used in earlier versions of compcache. TLSF is allocator on
which xvmalloc is based.
http://xenbits.xensource.com/xen-unstable.hg?file/0477f9061c8a/xen/common/xmalloc_tlsf.c
(Though I do not know which parts of xen depend on this allocator).

and xvmalloc vs tlsf arguments are here:
http://code.google.com/p/compcache/wiki/xvMalloc

tlsf:
http://rtportal.upv.es/rtmalloc/

Anyways, I will move it to drivers/block.

Thanks,
Nitin

