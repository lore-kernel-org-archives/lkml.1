Return-Path: <linux-kernel-owner+w=401wt.eu-S1752851AbYIJJzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851AbYIJJzg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 05:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbYIJJz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 05:55:28 -0400
Received: from il.qumranet.com ([212.179.150.194]:49110 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489AbYIJJz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 05:55:27 -0400
Message-ID: <48C7998D.1030408@qumranet.com>
Date: Wed, 10 Sep 2008 12:55:25 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>, Xen Devel <xen-devel@lists.xensource.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] Re: [PATCH 1 of 7] x86: add _PAGE_IOMAP pte flag
 for IO	mappings
References: <4d93ba619c716c45cca0.1220826073@localhost>	<48C67AE0.5060503@qumranet.com> <48C68C6B.7030803@goop.org> <48C68EA3.4050508@qumranet.com>
In-Reply-To: <48C68EA3.4050508@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
>>
>> I'm not sure; I still don't really understand how _PAGE_SPECIAL gets
>> used, other than being user-mode mapping only.  But in principle,
>> _PAGE_IOMAP could be set on both kernel and user mappings (if you direct
>> map a device into a process address space), so I think they would
>> conflict then?
>>
>>   
>
> It's a "don't refcount me" flag, which is not sematically the same as 
> I/O, but may be close enough.

Actually it's more of a "no struct page" flag, which implies no 
refcounting.  And not having a struct page should correspond well to a 
pte not requiring pfn->mfn conversion and being an I/O page.

-- 
error compiling committee.c: too many arguments to function

