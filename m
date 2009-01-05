Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207AbZAEVZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbZAEVZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 16:25:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753529AbZAEVZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 16:25:18 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:59311 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512AbZAEVZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 16:25:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oOl1pb4gxpL4ZObKCa9D4eEhjEaX6dGr/Ny/oVniBgsAZWTpAbwq/EpUXkvFGV1rrN
         FTnu9OM9v6lmfkWRs23XNsLcpXgonoSlP0DtkgPqI/J/fG7bMnEs+8zzT8w701PQyEGN
         C3w+yrcL6lyPypUN/2wu85SHBlzCSegwdAdUU=
Date: Tue, 6 Jan 2009 00:25:11 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: david@lang.hm
Cc: Jiri Slaby <jirislaby@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       LKML <linux-kernel@vger.kernel.org>, yhlu.kernel@gmail.com
Subject: Re: early exception error
Message-ID: <20090105212511.GA7468@localhost>
References: <alpine.DEB.1.10.0901021131210.21567@asgard.lang.hm> <20090102203058.GH5372@localhost> <alpine.DEB.1.10.0901030823190.23262@asgard.lang.hm> <20090103161052.GB11093@localhost> <alpine.DEB.1.10.0901031118450.23262@asgard.lang.hm> <20090103190316.GB7367@localhost> <20090103212426.GC7367@localhost> <496001A3.1040201@gmail.com> <20090104112919.GC7632@localhost> <alpine.DEB.1.10.0901051420030.27641@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901051420030.27641@asgard.lang.hm>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[david@lang.hm - Mon, Jan 05, 2009 at 02:20:42PM -0800]
> On Sun, 4 Jan 2009, Cyrill Gorcunov wrote:
>
> I assume you want this instead of the prior patches. I will test this  
> shortly.
>
> David Lang
>
>> ---
>> include/linux/mmzone.h |    1 +
>> 1 file changed, 1 insertion(+)
>>
>> Index: linux-2.6.git/include/linux/mmzone.h
>> ===================================================================
>> --- linux-2.6.git.orig/include/linux/mmzone.h
>> +++ linux-2.6.git/include/linux/mmzone.h
>> @@ -980,6 +980,7 @@ extern struct mem_section mem_section[NR
>>
>> static inline struct mem_section *__nr_to_section(unsigned long nr)
>> {
>> +	BUG_ON(SECTION_NR_TO_ROOT(nr) >= NR_SECTION_ROOTS);
>> 	if (!mem_section[SECTION_NR_TO_ROOT(nr)])
>> 		return NULL;
>> 	return &mem_section[SECTION_NR_TO_ROOT(nr)][nr & SECTION_ROOT_MASK];
>>
>

Yes, you even may combine it with the patch Johannes proposed.
They should not interfere.

		- Cyrill -
