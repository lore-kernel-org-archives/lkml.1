Return-Path: <linux-kernel-owner+w=401wt.eu-S1030859AbXDMW1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030859AbXDMW1O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 18:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030861AbXDMW1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 18:27:13 -0400
Received: from gw.goop.org ([64.81.55.164]:54677 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030859AbXDMW1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 18:27:12 -0400
Message-ID: <4620039B.9000608@goop.org>
Date: Fri, 13 Apr 2007 15:26:35 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i386: For debugging, make the initial page table setup
 less forgiving.
References: <200704132149.l3DLnvUY012097@tazenda.hos.anvin.org> <462001A9.3030006@vmware.com>
In-Reply-To: <462001A9.3030006@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> H. Peter Anvin wrote:
>> +    /*
>> +     * End condition: we must map up to and including
>> +     * INIT_MAP_BEYOND_END bytes beyond the end of our
>> +     * own page tables; 0x1000 is the size of the page
>> +     * table were about to write, and +0x007 is the
>> +     * attribute bits.
>> +     */
>> +    leal (INIT_MAP_BEYOND_END+0x1000+0x007)(%edi),%ebp
>>   
>
> hrmm?  Shouldn't that still be INIT_MAP_BEYOND_END+0x0007?  Seems you
> are mapping 4M more than you need. 

No, that's an actual byte address of the end of the mapped area, not a pfn.

    J
