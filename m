Return-Path: <linux-kernel-owner+w=401wt.eu-S1757048AbYHUX4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048AbYHUX4q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 19:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751811AbYHUX4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 19:56:37 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:39049 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbYHUX4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 19:56:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=lvVJILbG5D4CASK7dlO9I2mzvRSCv14HAUI+e3zHQnXIs9Km8Ni7s2ZdR2t2kr5rGu
         +wkVlBtHfGy3c0B//jHckTwg5Ost8Jw769joYcx5/jRv0Vps2Z4xjQuD9VS8Y18YN26d
         4HnicdwKOFUa8lVgjuRr1lXsz77D//f6c0Foc=
Message-ID: <86802c440808211656o20f9a22dv34e3ac8e8e84b4e1@mail.gmail.com>
Date: Thu, 21 Aug 2008 16:56:36 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: [PATCH] x86: fix probe_nr_irqs for xen
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Alex Nixon" <alex.nixon@citrix.com>
In-Reply-To: <48ADFFD2.7030309@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1219349409-15698-1-git-send-email-yhlu.kernel@gmail.com>
	 <48ADFB33.8010204@goop.org>
	 <86802c440808211649h37ac7533q4b95a83306ecd430@mail.gmail.com>
	 <48ADFFD2.7030309@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 4:52 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Yinghai Lu wrote:
>> On Thu, Aug 21, 2008 at 4:33 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>>
>>> Yinghai Lu wrote:
>>>
>>>> otherwise Xen is _completely_ unusable with 5 or more VCPUs.
>>>> ( when !CONFIG_HAVE_SPARSE_IRQ)
>>>>
>>>> based on Alex's patch
>>>>
>>>> also add +1 offset after redir_entries
>>>>
>>>> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>>>> Cc: Alex Nixon <alex.nixon@citrix.com>
>>>>
>>>>
>>> Looks good to me.  We can fix this in a better way later.
>>>
>>
>> later could set CONFIG_HAVE_SPARSE_IRQ to true by default.
>>
>
> Well, perhaps.  But we can use vectors rather than IRQs for Xen event
> channel mappings, which will save us from having to allocate lots of
> per-cpu irqs.

like system vectors with smp-ipi etc?

>
> Also, implementing probe_nr_irqs() in a more generic (rather than
> io_apic-specific) way.  Using some interface that queries each irq chip
> for how many irqs it supports, or something.

hope we can kill nr_irqs/NR_IRQS

YH
