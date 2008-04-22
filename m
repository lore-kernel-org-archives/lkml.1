Return-Path: <linux-kernel-owner+w=401wt.eu-S1762612AbYDVNDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762612AbYDVNDw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 09:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759044AbYDVNDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 09:03:43 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:3804 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596AbYDVNDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 09:03:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=KHS/j7aI0nqXEqhA6Vwe3rcL7i6HE/YV7xtF1h5P7BLAv5hSFet/MQpYXrtpgj2i7vE3mBs6F/+4DG8ZouSPR6oVCwYjQjwvoWi51NZJEw6An36pG84lZ8siFNhg50GHx7Oas7kj561xfs9uXHGBfeecU1kO1gwTWkAb7KfoFG8=
Message-ID: <480DE215.2070803@gmail.com>
Date: Tue, 22 Apr 2008 22:03:17 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       oliver@neukum.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       zaitcev@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/2] klist: implement KLIST_INIT() and DEFINE_KLIST()
References: <480DB6A4.20101@gmail.com> <1208869049.7115.254.camel@twins>
In-Reply-To: <1208869049.7115.254.camel@twins>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Tue, 2008-04-22 at 18:57 +0900, Tejun Heo wrote:
>> klist is missing static initializers and definition helper.  Add them.
>>
>> Signed-off-by: Tejun Heo <htejun@gmail.com>
>> ---
>> I can't tell who's in charge of this code, so I'm including last two
>> people who made changes and Andrew :-) This will be used by later USB
>> mode switch support, so I'm cc'ing USB people too.
>>
>> Thanks.
>>
>>  include/linux/klist.h |    8 ++++++++
>>  1 files changed, 8 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/klist.h b/include/linux/klist.h
>> index 7407125..c6b697c 100644
>> --- a/include/linux/klist.h
>> +++ b/include/linux/klist.h
>> @@ -25,6 +25,14 @@ struct klist {
>>  	void			(*put)(struct klist_node *);
>>  };
>>  
>> +#define KLIST_INIT(_name, _get, _put)					\
>> +	{ .k_lock	= __SPIN_LOCK_UNLOCKED(klist.k_lock),		\
> 
> May I ask you make that: __SPIN_LOCK_UNLOCKED(_name.k_lock)
 >
> Otherwise we'll end up with multiple classes that have the same name.

These locks don't nest so being in the same class should be okay and I 
was following what (at least some of) other __SPIN_LOCK_UNLOCKED users 
are doing.  If putting these locks into separate classes is the RTTD, sure.

Thanks.

-- 
tejun
