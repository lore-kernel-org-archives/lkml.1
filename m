Return-Path: <linux-kernel-owner+w=401wt.eu-S1763175AbYBMPzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763175AbYBMPzv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 10:55:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756533AbYBMPzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 10:55:43 -0500
Received: from spirit.analogic.com ([204.178.40.4]:2356 "EHLO
	spirit.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896AbYBMPzm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 10:55:42 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 13 Feb 2008 15:55:36.0615 (UTC) FILETIME=[DF832370:01C86E58]
Content-class: urn:content-classes:message
Subject: Re: [PATCH] fs/coda: remove static inline forward declarations
Date: Wed, 13 Feb 2008 10:55:35 -0500
Message-ID: <Pine.LNX.4.61.0802131052520.4866@chaos.analogic.com>
In-Reply-To: <Pine.LNX.4.64.0802131554180.31652@kivilampi-30.cs.helsinki.fi>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] fs/coda: remove static inline forward declarations
Thread-Index: AchuWN+PI18z/TP3SxWl+ulL3BagXQ==
References: <Pine.LNX.4.64.0802131417460.31652@kivilampi-30.cs.helsinki.fi> <Pine.LNX.4.61.0802130838100.4463@chaos.analogic.com> <Pine.LNX.4.64.0802131554180.31652@kivilampi-30.cs.helsinki.fi>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: =?iso-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: <jaharkes@cs.cmu.edu>, "Andrew Morton" <akpm@linux-foundation.org>,
       "LKML" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 13 Feb 2008, [iso-8859-1] Ilpo Järvinen wrote:

> On Wed, 13 Feb 2008, linux-os (Dick Johnson) wrote:
>>
>> On Wed, 13 Feb 2008, [iso-8859-1] Ilpo Järvinen wrote:
>>
>>> They're defined later on in the same file with bodies and
>>> nothingin between needs them.
>>>
>>> Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
>>> ---
>>> include/linux/coda_linux.h |    3 ---
>>> 1 files changed, 0 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/include/linux/coda_linux.h b/include/linux/coda_linux.h
>>> index 1c47a34..31b7531 100644
>>> --- a/include/linux/coda_linux.h
>>> +++ b/include/linux/coda_linux.h
>>> @@ -43,9 +43,6 @@ int coda_getattr(struct vfsmount *, struct dentry *, struct kstat *);
>>> int coda_setattr(struct dentry *, struct iattr *);
>>>
>>> /* this file:  heloers */
>>> -static __inline__ struct CodaFid *coda_i2f(struct inode *);
>>> -static __inline__ char *coda_i2s(struct inode *);
>>> -static __inline__ void coda_flag_inode(struct inode *, int flag);
>>> char *coda_f2s(struct CodaFid *f);
>>> int coda_isroot(struct inode *i);
>>> int coda_iscontrol(const char *name, size_t length);
>>> --
>>> 1.5.2.2
>>>
>>
>> I was taught formally that all procedures must be declared
>> before they are encountered in a file. This constitutes what
>> is generally known as "good standards of engineering practice."
>> It also guarantees a compiler diagnostic if the declaration and
>> the function doesn't match.
>
> They still are declared before they are used (the other two functions are
> similar to this randomly picked example):
>
> $ grep "coda_i2f" include/linux/coda_linux.h
> static __inline__ struct CodaFid *coda_i2f(struct inode *);
> static __inline__ struct CodaFid *coda_i2f(struct inode *inode)
>
> I removed the first one of these. The latter is followed by the body of
> the function.
>
> By using some fuzzy word like "encountered" you just make your point
> obscure enough so that I cannot follow what you're trying to say. If you
> refer to use of the function by "encountering", then that property is
> still maintained and we still get all the type-checking and so on (even
> after this removal).
>
>> You should not remove things just because you don't think they
>> are necessary. They do no harm and removing them can cause
>> code checking tools to issue diagnostic messages.
>
> Do you really think so? I mean in this specific case, did you even
> bothered to check the file before hitting the send button? ...I just fail
> to see what is your point in keeping these three because they're declared
> later on in the same file, though with the body at that time. Do you also
> claim that all the other ~5000+ static inlines with body in kernel headers
> (but not forward declared) are not following those "good standards" you're
> asking for (they certainly won't issue extra diagnostic messages)?
>
>
> -- 
> i.
>

Have you EVER seen the diagnostic message, "function is not a prototype?"

It's rhetorical. You don't have to answer. Furthermore "encountered" is
not fuzzy.

Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.28 BogoMips).
My book : http://www.AbominableFirebug.com/
_

****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
