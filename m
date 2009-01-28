Return-Path: <linux-kernel-owner+w=401wt.eu-S1754558AbZA1SP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbZA1SP3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 13:15:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751601AbZA1SPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 13:15:14 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:6583 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbZA1SPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 13:15:12 -0500
Message-ID: <4980A07A.5060904@caviumnetworks.com>
Date: Wed, 28 Jan 2009 10:14:18 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, corbet@lwn.net,
       linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk,
       linux-api@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH, RFC] Remove fasync() BKL usage, take 3325
References: <20090115153211.663df310@bike.lwn.net> <20090122065104.2787df2d.akpm@linux-foundation.org> <20090122203248.GA20159@infradead.org> <20090123045646.GK15750@one.firstfloor.org> <20090127165504.53ed7a2d.akpm@linux-foundation.org> <20090128031439.GA11025@redhat.com> <20090128173618.GA3174@infradead.org>
In-Reply-To: <20090128173618.GA3174@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jan 2009 18:14:18.0380 (UTC) FILETIME=[3C4034C0:01C98174]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Wed, Jan 28, 2009 at 04:14:39AM +0100, Oleg Nesterov wrote:
>> I didn't send the actual patch. The idea is,
>>
>> 	can't we use O_LOCK_FLAGS bit? I agree, it is a bit ugly,
>> 	and I won't insist if you don't like is.
>>
>> 		static inline int try_lock_f_flags(struct file *file)
>> 		{
>> 			return !test_and_set_bit(O_LOCK_FLAGS, file->f_flags);
>> 		}
> 
> ->f_flags is an unsigned int and the bit macros need an unsigned long.
> Increasing the size of struct file for this is probably a bad idea.
> 

Could that be seen as a deficiency in the bit macros?

Could we modify them so that they worked on unsigned int as well?  I 
know we could for some architectures.

David Daney
