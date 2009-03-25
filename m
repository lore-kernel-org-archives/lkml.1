Return-Path: <linux-kernel-owner+w=401wt.eu-S1755237AbZCYQiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbZCYQiq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 12:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753410AbZCYQig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 12:38:36 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:54902 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbZCYQif convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 12:38:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=BhRgH3riQp2bBAOTe5z3FWREFK3cC2I+ovi3tNMKeKaDVuHTaqldd5rAWp9Yopvim+
         hlMCIsQqxy58OTgoch09OxQQiIe+b0sHwS8WYzo1ttK9NLfx2fLEmGr6dxqYQFemzhC0
         VOmCmPFvidj7nHm1KdxQCfjdPqAM2XrbXpMac=
MIME-Version: 1.0
Reply-To: petkovbb@gmail.com
In-Reply-To: <49CA582B.9080706@kernel.org>
References: <1237990673-8358-1-git-send-email-tj@kernel.org>
	 <1237990673-8358-3-git-send-email-tj@kernel.org>
	 <da824cf30903250904n211b157eje2db99b0bdb1f33a@mail.gmail.com>
	 <49CA582B.9080706@kernel.org>
Date: Wed, 25 Mar 2009 17:38:32 +0100
Message-ID: <9ea470500903250938t35cbc403l2d0bb3ea5f1f1def@mail.gmail.com>
Subject: Re: [PATCH 02/10] ide-tape: use single continuous buffer
From: Borislav Petkov <petkovbb@googlemail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Grant Grundler <grundler@google.com>, bzolnier@gmail.com,
       linux-kernel@vger.kernel.org, axboe@kernel.dk,
       linux-ide@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Mar 25, 2009 at 5:13 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Grant.
>
> Grant Grundler wrote:
>> On Wed, Mar 25, 2009 at 7:17 AM, Tejun Heo <tj@kernel.org> wrote:
>>> Impact: simpler buffer allocation and handling, fix DMA transfers
>> ...
>>> +               atomic_set(&bh->b_count, bcount);
>>>                if (atomic_read(&bh->b_count) == bh->b_size)
>> ...
>>
>> I'm failing to see why bh->b_count is an atomic_t.
>> I always assumed tapes were exclusive access devices
>> and would be serialized at a higher level.
>
> Beats me.  I don't know.  The code is generally pretty over-engineered
> but, well, it's an ancient piece of code with (probably too) rich
> history.

Yep, actually the driver was even bigger and it implemented a bunch of fun stuff
like command pipelining and those atomics had to protect the pipeline from
simultaneous ->open()s through its chrdev interface, IIRC.

-- 
Regards/Gruss,
Boris
