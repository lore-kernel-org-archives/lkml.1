Return-Path: <linux-kernel-owner+w=401wt.eu-S1756084Ab0ATGd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab0ATGd2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 01:33:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755692Ab0ATGd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 01:33:27 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:38407 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682Ab0ATGdZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 01:33:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FHEg11axlbgWzjPn2r0CygcXDITxt82DdGcdcVaYbLdAeTkL91N3zXuEW7Va8lVQPR
         2TpJdDbPw3sFPTtr29GlliVa4YF7UTjnr86BIOWCqgusZoKQM2rpnGRaUCKo/ybrvosP
         Z+F2DHgXT1PgfIGlOo2Sh+Qw6BY9rdyMs51/E=
MIME-Version: 1.0
In-Reply-To: <4B568C63.4050506@gmail.com>
References: <20100116235653.898098245@gmail.com>
	 <20100116235851.884756038@gmail.com> <4B5678E2.2050709@gmail.com>
	 <4B568C63.4050506@gmail.com>
Date: Wed, 20 Jan 2010 07:33:24 +0100
Message-ID: <7eb6a4d81001192233i5418249ct5a1717045f75167c@mail.gmail.com>
Subject: Re: [patch 2/2] sata_via: Delay on vt6420 when starting ATAPI DMA 
	write
From: Bart Hartgers <bart.hartgers@gmail.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       juergen.metzdorf@telelev-dsl.de, markpschool@hotmail.com,
       sporadic.crash@gmail.com, apopov@sirma.bg, david@coomber.co.za,
       jay4mail@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2010/1/20 Robert Hancock <hancockrwd@gmail.com>:
> On 01/19/2010 09:30 PM, Tejun Heo wrote:
>>
>> Hello,
>>
>> On 01/17/2010 08:56 AM, Bart Hartgers wrote:
>>>
>>> When writing a disc on certain lite-on dvd-writers (also rebadged as
>>> optiarc/LG/...) connected to a vt6420, the ATAPI CDB ends up in the
>>> datastream and on the disc, causing silent corruption.  Delaying
>>> between sending the CDB and starting DMA seems to prevent this.
>>>
>>> I do not know if there are burners that do not suffer from this, but
>>> the patch should be safe for those as well.
>>>
>>> There are many reports of this issue, but AFAICT no solution was
>>> found before. For example:
>>> http://lkml.indiana.edu/hypermail/linux/kernel/0802.3/0561.html
>>>
>>> Signed-off-by: Bart Hartgers<bart.hartgers@gmail.com>
>>
>> Ah... you found solution for this?  That's great.  This is one of the
>> three problems that have been lingering for years - the other two
>> being pata_ali ATAPI DMA problem and sata_sil data corruption problem.
>> I'll be ecstatic if this fix works.  Just one thing, I don't think
>> we'll need a warning message there.  It's useful during development
>> but it doesn't really provide any useful information afterwards.
>
> Another tiny nitpick about the patch, the unlikely() around the
> DMA_TO_DEVICE check probably shouldn't be there - unlikely() is for things
> that will always be either highly unlikely or a slow path, neither of which
> really apply.
>

Well, the ata_sff_pause actually does a ndelay(400), and with today's
processors that would be a 'slow path', right?

Groeten,
Bart

>>
>> Digging up the mailing list and cc'ing people who have reported this
>> problem.  If you still have the affected systems, can you guys please
>> test the patch in the following message and see whether it fixes the
>> problem?
>>
>>   http://article.gmane.org/gmane.linux.kernel/939112/raw
>>
>> Thanks a lot.  :-)
>>
>
>



-- 
Bart Hartgers - New e-mail: bart.hartgers@gmail.com
