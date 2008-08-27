Return-Path: <linux-kernel-owner+w=401wt.eu-S1754216AbYH0HQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbYH0HQA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 03:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbYH0HPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 03:15:52 -0400
Received: from elasmtp-curtail.atl.sa.earthlink.net ([209.86.89.64]:51112 "EHLO
	elasmtp-curtail.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752053AbYH0HPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 03:15:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=VFC+NgRkUNVDYoD40y3S6qTf89q1gn515XX4smwiaEzH1vWtDrIK/2tyR0TZmH8H;
  h=Received:Cc:Message-Id:From:To:In-Reply-To:Content-Type:Content-Transfer-Encoding:Mime-Version:Subject:Date:References:X-Mailer:X-ELNK-Trace:X-Originating-IP;
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Message-Id: <A45237D9-5E44-4900-86C4-C59666FA3142@earthlink.net>
From: Bruce Leonard <brucle@earthlink.net>
To: dedekind@infradead.org
In-Reply-To: <1219815617.18027.132.camel@sauron>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH 2/2] Add support for > 2GiB MTD devices
Date: Wed, 27 Aug 2008 00:15:48 -0700
References: <48AB3AAF.3010504@earthlink.net> <1219815617.18027.132.camel@sauron>
X-Mailer: Apple Mail (2.926)
X-ELNK-Trace: 481fc18f0ae4055094f5150ab1c16ac08868399773331e3008a6827e39a46c5f8e35f4a8fa63e935350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 70.110.34.130
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 26, 2008, at 10:40 PM, Artem Bityutskiy wrote:

> Hi Bruce,
>
> On Tue, 2008-08-19 at 14:27 -0700, Bruce Leonard wrote:
>> +/*
>> + * Inline function for determining the size of the MTD device,  
>> independant
>> + * of old or new way of doing things.
>> + *
>> + */
>> +static inline u_int64_t device_size(struct mtd_info *a)
>> +{
>> +	return a->num_eraseblocks == 0 ? a->size : a->num_eraseblocks * a- 
>> >erasesize;
>> +}
>
> I do not think it is a good idea to do multiplication every time we  
> need
> MTD device size. It is unnecessarily large overhead in terms of speed
> and code size.
>
> Did you consider a possibility of just making mtd->size 64 bit?

I did consider making size 64-bit, but it seemed less intrusive to go  
the direction I did.  I wanted to change as little code as possible  
but at the same time make it obvious there was a fundamental change.   
There's also a desire to move more in the direction of a BIO-like  
aspect to the MTD layer and some of the suggestions I got early made  
it seem that this would make that future move easier.

>
> Or using eraseblock:offset pairs instead of absolute address?

I didn't really see how I could convey the idea of size using  
eraseblock:offset.

Bruce


