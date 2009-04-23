Return-Path: <linux-kernel-owner+w=401wt.eu-S1754721AbZDWJHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbZDWJHd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 05:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590AbZDWJHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 05:07:19 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:27128 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbZDWJHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 05:07:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=vqHIUSP9GQPbRdqcUMEi23NvflB/g5Aykru1RHlF++XdvUNUuGb+51lAkldkXSYh+/
         31jGwgaiDmcBZL/0iOtLn6BHRXx6Ot2taCXNQ3640subYenlyfR2ExLuJ4Jpa9QPM9x3
         bGfoJKCI9ktjearXR1VVb3bZsQchEY4yW+1rg=
Message-ID: <49F02FBE.3020504@panasas.com>
Date: Thu, 23 Apr 2009 12:07:10 +0300
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1b3pre) Gecko/20090223 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Whitehouse <swhiteho@redhat.com>
CC: Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] __ffs64()
References: <1240415192.29604.90.camel@localhost.localdomain>	 <alpine.DEB.1.10.0904221654370.32682@qirst.com> <1240474923.3396.7.camel@localhost.localdomain>
In-Reply-To: <1240474923.3396.7.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr. 23, 2009, 11:22 +0300, Steven Whitehouse <swhiteho@redhat.com> wrote:
> Hi,
> 
> On Wed, 2009-04-22 at 16:59 -0400, Christoph Lameter wrote:
>> On Wed, 22 Apr 2009, Steven Whitehouse wrote:
>>
>>> I'd like to add a new bitop, __ffs64() which I need in order to fix a
>>> bug in GFS2. The question is, where should it go?
>> I think the location is right.
>>
>>> On 64 bit arches, __ffs64() would be a synonym for __ffs(), but on 32
>>> bit arches it degenerates to a conditional plus a call to __ffs(). I'm
>>> assuming that there would not be a lot of point in optimising this
>>> operation on 32 bit arches even if such an instruction was available, so
>>> that I should do something like the below patch.
>>>
>>> Does that seem reasonable, or should I give it a separate header file
>>> under asm-generic/bitops/ like some of the similar operations? It looks
>>> like I'd have to touch a lot of other files if I were to go that route,
>> One issue may be that some 32 bit architectures have a better way of doing
>> 64 bit ffs.
>>
> Yes, thats what I was worried about. I don't have a wide enough
> knowledge of the different architectures to make a judgement about
> whether this is likely or not.
> 
> I guess maybe the right thing to do is to leave it as I did it in the
> patch and if an arch wants to create its own implementation, then it
> could be moved at that stage.

Agreed.

Benny

> 
> Steve.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

