Return-Path: <linux-kernel-owner+w=401wt.eu-S1753164Ab0ATGoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab0ATGoV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 01:44:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752275Ab0ATGoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 01:44:13 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:25728 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025Ab0ATGoJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 01:44:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=stUPbNC6yk35hZFwi/m/NuDJTzgbD5lh8HEdv8eKBO2KYProIDWqUm2oy1giXy90KT
         dza3hffsNiKgRj1RM/didPXJ7L8REgKVjzH8AnTeJaZA5SSN41oTti2N/n29JjxZUEtJ
         t2Zk8fSiX29I0+5NpLD1fHwX/qCACg5VetFr0=
MIME-Version: 1.0
In-Reply-To: <4B5678E2.2050709@gmail.com>
References: <20100116235653.898098245@gmail.com>
	 <20100116235851.884756038@gmail.com> <4B5678E2.2050709@gmail.com>
Date: Wed, 20 Jan 2010 07:44:07 +0100
Message-ID: <7eb6a4d81001192244k19d28805p9cb4eaec7eed9366@mail.gmail.com>
Subject: Re: [patch 2/2] sata_via: Delay on vt6420 when starting ATAPI DMA 
	write
From: Bart Hartgers <bart.hartgers@gmail.com>
To: Tejun Heo <htejun@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
       linux-ide@vger.kernel.org, juergen.metzdorf@telelev-dsl.de,
       markpschool@hotmail.com, sporadic.crash@gmail.com, apopov@sirma.bg,
       david@coomber.co.za, jay4mail@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2010/1/20 Tejun Heo <htejun@gmail.com>:
> Hello,
>
> On 01/17/2010 08:56 AM, Bart Hartgers wrote:
>> When writing a disc on certain lite-on dvd-writers (also rebadged as
>> optiarc/LG/...) connected to a vt6420, the ATAPI CDB ends up in the
>> datastream and on the disc, causing silent corruption.  Delaying
>> between sending the CDB and starting DMA seems to prevent this.
>>
>> I do not know if there are burners that do not suffer from this, but
>> the patch should be safe for those as well.
>>
>> There are many reports of this issue, but AFAICT no solution was
>> found before. For example:
>> http://lkml.indiana.edu/hypermail/linux/kernel/0802.3/0561.html
>>
>> Signed-off-by: Bart Hartgers <bart.hartgers@gmail.com>
>
> Ah... you found solution for this?  That's great.  This is one of the
> three problems that have been lingering for years - the other two
> being pata_ali ATAPI DMA problem and sata_sil data corruption problem.
> I'll be ecstatic if this fix works.  Just one thing, I don't think
> we'll need a warning message there.  It's useful during development
> but it doesn't really provide any useful information afterwards.
>

Yes, you're right. I'll drop the printk_once and send another patch
for inclusion. However, for testing I found it very useful to make
sure that I got the right module loaded. So I figured it could be
helpful for the interpretation of success/failure reports.

Assuming that this patch works for other people as well, what is
prefered: resending both patches or just to make a new #2/2 (the
vt6420 one)?

Groeten,
Bart

> Digging up the mailing list and cc'ing people who have reported this
> problem.  If you still have the affected systems, can you guys please
> test the patch in the following message and see whether it fixes the
> problem?
>
>  http://article.gmane.org/gmane.linux.kernel/939112/raw
>
> Thanks a lot.  :-)
>
> --
> tejun
>



-- 
Bart Hartgers - New e-mail: bart.hartgers@gmail.com
