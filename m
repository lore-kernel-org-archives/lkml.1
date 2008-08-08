Return-Path: <linux-kernel-owner+w=401wt.eu-S1762620AbYHHWPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762620AbYHHWPQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:15:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbYHHWPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 18:15:00 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:3607 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbYHHWO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 18:14:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ixHb/xDdYZ0GOzIo6QJy9oBeL60SBGh55VvGZPhaHgwi9P6HmIDRmitkDC92GfCmC6
         vHIK9lvFFG+QuKNt+AYxP0VQgHx89xPt7fpTrKHUchBm8BP8d3oYi9pfQTMclZ5s4FC7
         NW2lX9RQbJZvKUP3rtjIG+BGBOiNNbTpkG5HM=
Message-ID: <86802c440808081514w3a7ea1d6hda2442e7bf6729a4@mail.gmail.com>
Date: Fri, 8 Aug 2008 15:14:55 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 00/42] dyn_array/nr_irqs/sparse_irq support v5
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Mike Travis" <travis@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <489CC246.5000202@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1218232368-31228-1-git-send-email-yhlu.kernel@gmail.com>
	 <489CC246.5000202@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 8, 2008 at 3:01 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Yinghai Lu wrote:
>>
>> Please check dyn_array support for x86
>> v3: split changing to nr_irqs to small patches
>>   fix checkpatch error
>>   reorder the patch sequence to make dyn_array support go at first
>>       so could use that with arrays other than NR_IRQS
>> v4: add CONFIG_HAVE_SPARSE_IRQ with list to use condensed irq_desc array
>>   so could use 32 init, and init more if needed.
>>   x86 32bit: have CONFIG_HAVE_DYN_ARRAY
>>   x86 64bit: have CONFIG_HAVE_DYN_ARRAY and CONFIG_HAVE_SPARSE_IRQ
>>
>
> So I'm still clearly missing something about this... if we need sparse IRQs
> in the first place (which we do), what's the point of the dyn_array?

x86_64: support CONFIG_HAVE_SPARSE_IRQ and CONFIG_DYN_ARRAY
x86_32: support CONFIG_DYN_ARRAY

some arches could use dyn_array with probing nr_irqs and it could be
32 and much less than 224.
some could have that like 512. and those arch may not need to mess up
with sparse_irq at first point.
but still could get some flexibilty about that array size.

YH
