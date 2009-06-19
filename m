Return-Path: <linux-kernel-owner+w=401wt.eu-S1757289AbZFSAt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289AbZFSAt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 20:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbZFSAtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 20:49:20 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:64272 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbZFSAtT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 20:49:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=LPPi1fdA7TPExDUYFX2oWkPpPtlR1YsIAL4wZlhc33xEeNzl/niSsVz4QR7kYRudr9
         wM09/vLvuFMPxHwe4leKxQmP/0AfgNZCzm65VlDOgvxEE1Vk5AZWmMO3LFmBNBkd5qyr
         AWAwW8rIsjTJuk1snT5L/8OOBHrGZEUTFuR94=
MIME-Version: 1.0
In-Reply-To: <19002.57382.880505.913539@cargo.ozlabs.ibm.com>
References: <18995.20685.227683.561827@cargo.ozlabs.ibm.com> 
	<8bd0f97a0906181655jd68835fg10fe0783b6a6068d@mail.gmail.com> 
	<19002.57382.880505.913539@cargo.ozlabs.ibm.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 18 Jun 2009 20:49:02 -0400
Message-ID: <8bd0f97a0906181749h43f70338te96ea41f90caa3b7@mail.gmail.com>
Subject: Re: [PATCH 1/2] lib: Provide generic atomic64_t implementation
To: Paul Mackerras <paulus@samba.org>
Cc: benh@kernel.crashing.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 18, 2009 at 20:47, Paul Mackerras wrote:
> Mike Frysinger writes:
>> On Sat, Jun 13, 2009 at 03:10, Paul Mackerras wrote:
>> > +typedef struct {
>> > +       long long counter;
>> > +} atomic64_t;
>>
>> lack of volatile seems odd compared to:
>> include/linux/types.h:
>> typedef struct {
>>     volatile int counter;
>> } atomic_t;
>
> It's only accessed under a spinlock, so I don't think it needs to be
> volatile.  On UP it's accessed within local_irq_save/restore which
> should also be compiler barriers and prevent memory access reordering,
> so again volatile isn't needed.

i'm not suggesting it is needed, i'm saying it's a bit confusing.  a
simple comment above the atomic64_t type with your simple explanation
here would go a long way.
-mike
